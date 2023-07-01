<?php
if (isset($_POST['qualityName']) &&
	isset($_POST['lowTemperature']) &&
	isset($_POST['highTemperature'])
	) {
	$send_data = new stdClass();
	$send_data->name = $_POST['qualityName'];
	$send_data->bounds = [$_POST['lowTemperature'], $_POST['highTemperature']];
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	try {
		$result = $contract->send(
			'createQuality',
			get_object_vars($send_data),
			$extra_data
		);
		$resultString = getTransactionResultString($result, $web3);
		$resultString .= 'Quality Contract ID: ' . $contract->call('getQualityLastId', [])->result;
		$smarty->assign('result', $resultString);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}