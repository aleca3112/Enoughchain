<?php
$smarty->assign('body', 'sign.tpl');
$smarty->assign('boolContractDeploy', $boolContractDeploy);

if (isset($_POST['accountSelect']) &&
    !isset($_SESSION['account'])) {
		
	$account = new \stdClass();
	$account->address = $_POST['accountSelect'];
	$account->privateKey = $_POST['privateKey'];
	$web3->setPersonalData($account->address, $account->privateKey); 
	$account->permission = $accounts[$account->address];
	$_SESSION['account'] = $account;	
	
	if ($boolContractDeploy) {		
		$bytecode = file_get_contents(MAIN_CONTRACT_PATH . '.bin');
        $contract->setBytecode($bytecode);
        $nonce =  $web3->personal->getNonce();		
		$extra_params = [ 
			'from' => $account->address,
			'nonce' => $nonce
		];  
		$result = $contract->deployContract([MAX_PRODUCT_ACTIVITIES, MAX_PRODUCT_AGGREGATE, MIN_TRUST], $extra_params); 
		if(isset($result->result))
		{
			$newAddress = '';
			
			do {
				sleep(5);
				$checkContract = $web3->call('eth_getTransactionReceipt', [$result->result]);
				if(isset($checkContract->result->contractAddress)) $newAddress = $checkContract->result->contractAddress;

			} while ($newAddress == '');
			
			file_put_contents(
				MAIN_CONTRACT_PATH_JSON,
				json_encode(array(
					'abi' => $abi,
					'bytecode' => $bytecode,
					'contractAddress' => $newAddress
				)));			
		}
		else 
		{
			echo 'Transaction error <br/>';
			echo json_encode($result);
		}
	}	
	header("Status: 301 Moved Permanently");
    header("Location: index.php");
	exit();
}