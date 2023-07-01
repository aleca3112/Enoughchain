// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;
//pragma experimental SMTChecker;

import "./Utils.sol";
import "@openzeppelin/contracts@4.8.3/access/Ownable.sol";

contract Account is Ownable {
    
    mapping(address=>uint) private _accountPenalties;
    mapping(address=>string[]) private _accountsRoles;

    uint public constant _MAX_HISTORY_RATING = 10;
    uint public constant _MAX_SUSPECT_RATING = 30;
    string public constant _PRODUCER_ROLE = "producer";
    string public constant _SENSOR_ROLE = "sensor";
    string public constant _TRADER_ROLE = "trader";
    string[] private _roles = [_PRODUCER_ROLE, _SENSOR_ROLE, _TRADER_ROLE]; 

    function addRole(string calldata role, address account) 
    external onlyOwner validRole(role) {
        require(
            !hasRole(role, account),
            "Account already has this role!!!"
            );
        _accountsRoles[account].push(role);                
    }

    function getAccountRoles(address account)
    external view returns(string[] memory) {        
        return _accountsRoles[account];
    }

    function getRoles()
    external view returns(string[] memory) {        
        return _roles;
    }

    function hasRole(address account)
    external view returns(bool) {        
        return _accountsRoles[account].length > 0;
    }

    function hasRole(string memory role, address account)
    public view validRole(role) returns(bool)
    {
        return Utils.stringListExists(role, _accountsRoles[account]);
    }

    function hasRoleProducer(address account)
    external view returns(bool)
    {
        return hasRole(_PRODUCER_ROLE, account);
    }

    function hasRoleSensor(address account)
    external view returns(bool)
    {
        return hasRole(_SENSOR_ROLE, account);
    }

    function hasRoleTrader(address account)
    external view returns(bool)
    {
        return hasRole(_TRADER_ROLE, account);
    }

    function isValidRole(string memory role)
    public view returns(bool) {
        return Utils.stringListExists(role, _roles);
    }

    function removeRolefromAccount(string calldata role, address account)
    external onlyOwner validRole(role) {
        Utils.stringListRemove(role, _accountsRoles[account]);
    }

    function setPenalties(address account, uint dataIndex, uint[][] memory data)
    external onlyOwner returns(bool) {
        if (data.length > 1) {
            uint[] memory population = new uint[](data.length);         
            uint value = data[data.length-1][dataIndex];
            uint i = data.length;            
            uint count = 0;        
            while(count < _MAX_HISTORY_RATING && i > 0) {
                count +=1;
                i -=1;
                population[i] = data[i][dataIndex];
            }               
            (bool result, uint average, uint stdDev) = Utils.calcStocastic(population, _MAX_HISTORY_RATING);
            unchecked {
                if (stdDev > 0 && result && Utils.abs(int(average - value)) > stdDev ) {
                    _accountPenalties[account]+=1;
                    return true;
                }
            } 
            if (_accountPenalties[account] >= _MAX_SUSPECT_RATING) {
                _accountPenalties[account] = 0;
                Utils.stringListRemove(_PRODUCER_ROLE, _accountsRoles[account]);
                Utils.stringListRemove(_TRADER_ROLE, _accountsRoles[account]);
                return true;
            }
        }
        return false;
    }
    
    modifier validRole(string memory role) {
        require(isValidRole(role),"Not valid role!");
        _;
    }
}