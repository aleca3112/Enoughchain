<?php
function getAccountsRoles($accountsInitial, $contract) {
	$resultAccounts = $accountsInitial->getArrayCopy();
	foreach($resultAccounts as $account=>$permission) {
		$roles = (array) $contract->call('getStakeholderRoles', [$account]);
		foreach($roles['array_1'] as $role) {
			array_push($resultAccounts[$account], $role);
		}
		asort($resultAccounts[$account]);
	}
	return $resultAccounts;
}

function getTransactionResultString($result, $web3) {
	$resultString = 'Transaction succesfully sent: ' .
		$result->result . '&#13;&#10;&#13;&#10;';		
	$txResult = null;			
	do {
		sleep(2);
		$checkTx = $web3->call('eth_getTransactionReceipt', [$result->result]);
		if(isset($checkTx->result)) $txResult = $checkTx->result;
	} while (is_null($txResult));
	$resultString .= json_encode($txResult) . '&#13;&#10;&#13;&#10;';
	return $resultString;
}