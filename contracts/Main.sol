// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;
//pragma experimental SMTChecker;

import "./Account.sol";
import "./ProductManagement.sol";
import "./Rating.sol";
import "@openzeppelin/contracts@4.8.3/utils/Strings.sol";

contract Main is Ownable { 

    event BannedAccount(
        address trader
    );
    
    event QualityWarning(
        address productOwner,
        address sensor,
        uint productId, 
        uint qualityId,
        uint timestamp,
        uint[] values
    );

    event UncompletedTransferWarning(
        address productBuyer,
        address productSeller,
        uint productId,
        uint timestamp
    );    

    uint private _minTrust;    
        
    Account private _account = new Account();    
    ProductManagement private _productManagement;    
    Rating private _rating = new Rating(this.reputationCalc, this.trustCalc);        

    constructor(
        uint maxActivities, uint maxAggregateProducts, uint minTrust
    ) {
      require(minTrust > 0 && minTrust < 100, "Not valid min trust value!");
      _productManagement = new ProductManagement(maxActivities, maxAggregateProducts);
      _minTrust = minTrust;
    }

    function addRole(string memory role, address account) 
    external onlyOwner
    {
        if (!_account.hasRole(account)) {
            _rating.createSBT(account);        
            _rating.resetTrust(account, _minTrust);
        }
        _account.addRole(role, account);            
    }

    function createQuality(
      string calldata name, uint[] calldata bounds
    ) external onlyOwner returns(uint)
    {                
        return _productManagement.createQuality(name, bounds);        
    }

    function createProduct(
        string calldata name, string[] memory activities,
        uint[] memory activitiesGHG, uint[] memory products,
        uint qualityId, address sensor
    ) external validSensor(sensor) returns(uint) {
        require(this.isTrustedProducer(msg.sender), "Only trusted producer could create material!");        
        return _productManagement.createProduct(msg.sender, name, activities, activitiesGHG, products,
               qualityId, sensor);
    }

    function getProductLastId() external view returns(uint) {
        return _productManagement.getProductLastId();
    }

    function getProductOwner(uint productId)
    external view returns(address) {
        return _productManagement.getProductOwner(productId);
    }

    function getProductResource(uint productId)
    external view returns(Product.Resource memory) {
        return _productManagement.getProductResource(productId);
    }

    function getProductQualityExceed(uint productId)
    external view returns(uint) {
        return _productManagement.getProductQualityExceed(productId);
    }

    function getQualityBounds(uint qualityId)
    external view returns(Quality.QualityBounds memory) {
        return _productManagement.getQualityBounds(qualityId);
    }

    function getQualityLastId() external view returns(uint) {
        return _productManagement.getQualityLastId();
    }

    function getStakeholderRoles(address stakeholder) external view returns(string[] memory) {
        return _account.getAccountRoles(stakeholder);         
    }

    function getStakeholderReputation(address stakeholder)
    public view returns(uint) {
        return _rating.getLastReputation(stakeholder);         
    }

    function getStakeholderTrust(address stakeholder)
    public view returns(uint) {
        return _rating.getLastTrust(stakeholder);         
    }

    function isTrusted(address account) 
    public view returns(bool) {
        uint trust = getStakeholderTrust(account);
        return trust >=_minTrust;              
    }

    function isTrustedProducer(address account) 
    public view returns(bool) {
        return _account.hasRoleProducer(account) && this.isTrusted(account);              
    }

    function isTrustedTrader(address account) 
    public view returns(bool)
    {
         return _account.hasRoleTrader(account) && this.isTrusted(account);             
    }

    function isTrustedTransfer(address from, address to) 
    public view returns(bool)
    {
        return (this.isTrustedProducer(from) || this.isTrustedTrader(from)) &&
               (this.isTrustedProducer(to) || this.isTrustedTrader(to));             
    }

    function removeSensorProduct(uint productId)
    external onlyOwner
    {
       _productManagement.removeSensorProduct(productId); 
    }

    function removeRole(string calldata role, address stakeholder)
    external onlyOwner validRole(role) {
        _account.removeRolefromAccount(role, stakeholder);
    }

    function reputationCalc(
        uint[] memory ratings,
        uint[] memory history,
        uint[] memory subValues)
    external pure returns(uint)
    {   uint[] memory weights = new uint[](3);
        weights[0] = 3;
        weights[1] = 3;
        weights[2] = 3;
        require(weights.length == ratings.length, string.concat("Ratings array length must be equal to ", Strings.toString(weights.length)));
        uint result = 0;        
        for(uint i = 0; i< ratings.length; i++) {
            result += ratings[i] * weights[i];
        }
        for(uint i = 0; i< subValues.length; i++) {
            result -= subValues[i];
        }
        if (history.length > 0) {
            uint average = 0;
            uint i = history.length;
            uint count = 0;
            while(count < 10 && i > 0) {
                count +=1;
                i -=1;
                average += history[i];
            }
            average = (result + average)/(count+1);
            result = uint(average);
        }        
        return result;
    }

    function sensorSendData(uint[] calldata values) external validSensor(msg.sender) {
                   
        uint[] memory ids = _productManagement.getSensorProduct(msg.sender);
        
        for (uint i; i < ids.length; i++) {

            uint productId = ids[i];
            if (_productManagement.checkProductBound(productId, values)) {
				_productManagement.increaseProductQualityExceed(productId);
                emit QualityWarning(_productManagement.getProductOwner(productId), msg.sender,
                                    productId, _productManagement.getProductQuality(productId),
                                    block.timestamp, values);
            }
        }
    }   

    function setTransfer(address to, uint productId) 
    external onlyOwner
    {
        address from = _productManagement.getProductOwner(productId);
        require(from != to, "Source address and Destination address must be different!");
        require(this.isTrustedTransfer(from,to), "Only trusted producer or trader could trade resources!");
        _productManagement.setProductTransferAddress(to, productId);           
    }
       
    function transferResource(
        uint productId,
        uint[] memory rating,
        uint[] memory ratingOtherValues,
        uint[] memory trustOtherValues
    )
    external {
        address to = _productManagement.getProductTransferAddress(productId);
        require(msg.sender == to, "Only destination trader could complete transfer!!!");
        address from = _productManagement.getProductOwner(productId);
        if (this.isTrustedTransfer(from,to)) {                               
            _productManagement.setProductTransfer(from, to, productId);            
            _rating.setReputation(from, rating, ratingOtherValues);
            _rating.setTrust(from, trustOtherValues);            
            _productManagement.resetProductQualityExceed(productId);
            if (_account.setPenalties(to, 2, _rating.getRatings(from))) {
               emit BannedAccount(to);
            }            
        } else {
            emit UncompletedTransferWarning(from, to, productId, block.timestamp);
        }
        _productManagement.setProductTransferAddress(address(0), productId);
    }
	
    function trustCalc(
        uint[] memory reputations,
        uint[] memory history,
        uint[] memory subValues
    )
    external pure returns(uint)
    {   
        uint result = reputations[reputations.length-1];
        for(uint i = 0; i< subValues.length; i++) {
            result -= subValues[i];
        }
        if (history.length > 0) {
            uint average = 0;
            uint i = history.length;
            uint count = 0;
            while(count < 10 && i > 0) {
                count +=1;
                i -=1;
                average += history[i];
            }
            average = (result + average)/(count+1);
            result = uint(average);
        }
        return result;
    }

    modifier validRole(string calldata role) {
        require(_account.isValidRole(role),"Not valid role!");
        _;
    }

    modifier validSensor(address sensor) {
        require(_account.hasRoleSensor(sensor), "Not valid sensor account!");
        _;
    }

}