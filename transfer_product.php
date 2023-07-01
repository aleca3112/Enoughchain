<?php
$transferAccounts = [];
foreach($accounts as $account => $permissions) {
	if (in_array(ROLE_PRODUCER, $permissions, true) ||
		in_array(ROLE_TRADER, $permissions, true)
	) {
		$transferAccounts[$account] = $permissions;
	}
}
$smarty->assign('accounts', $transferAccounts);
if (isset($_POST['productID']) &&
	isset($_POST['selectAccount'])
	) {
	$send_data = new stdClass();
    $send_data->to = $_POST['selectAccount'];
	$send_data->productId = $_POST['productID'];
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	try {
		$result = $contract->send('setTransfer', get_object_vars($send_data), $extra_data);
		$resultString = getTransactionResultString($result, $web3);		
		$smarty->assign('result', $resultString);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}