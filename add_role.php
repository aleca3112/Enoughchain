<?php
if (isset($_POST['selectAccount']) &&
	isset($_POST['selectRole'])) {	
	$send_data = new stdClass();    
    $send_data->role = $_POST['selectRole'];
	$send_data->account = $_POST['selectAccount'];
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	try {
		$result = $contract->send('addRole', get_object_vars($send_data), $extra_data);
		$resultString = getTransactionResultString($result, $web3);
		$smarty->assign('result', $resultString);
		$accounts = getAccountsRoles($accountsInitial, $contract);
		$smarty->assign('accounts', $accounts);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}