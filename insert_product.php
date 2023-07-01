<?php
$sensorAccounts = [];
foreach($accounts as $account => $permissions) {
	if (in_array(ROLE_SENSOR, $permissions, true)) {
		$sensorAccounts[] = $account;
	}
}
$smarty->assign('sensorAccounts', $sensorAccounts);
if (isset($_POST['productName']) &&
	isset($_POST['ghgValue']) &&
	isset($_POST['qualityID']) &&
	isset($_POST['sensorAccount'])
	) {
	$send_data = new stdClass();
    $send_data->name = $_POST['productName'];
	$send_data->activities = ['Raw Material'];
    $send_data->activitiesGHG = [$_POST['ghgValue']];
    $send_data->products = [];
    $send_data->qualityId = $_POST['qualityID'];
	$send_data->sensor = $_POST['sensorAccount'];
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	try {
		$result = $contract->send('createProduct', get_object_vars($send_data), $extra_data);
		$resultString = getTransactionResultString($result, $web3);
		$resultString .= 'Product ID: ' . $contract->call('getProductLastId', [])->result;				
		$smarty->assign('result', $resultString);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}