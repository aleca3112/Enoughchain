<?php
if (isset($_POST['productID']) &&
	isset($_POST['traderRating'])
	) {
	$mockRegulatorRating = 10;
	$productQualityExceed = intval($contract->call('getProductQualityExceed', [$_POST['productID']])->result);
	$sensorRating = 10;
	if ($productQualityExceed < $sensorRating) {
		$sensorRating = $sensorRating - $productQualityExceed;
	} else {
		$sensorRating = 0;
	}
	$productGHG = intval($contract->call('getProductResource', [$_POST['productID']])->tuple_1->GHG);
	$send_data = new stdClass();
    $send_data->productId = $_POST['productID'];
	$send_data->rating = [$mockRegulatorRating, $sensorRating, $_POST['traderRating']];
	$send_data->ratingOtherValues = [];
	$send_data->trustOtherValues = [intval(ceil($productGHG/100))];
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	var_dump($send_data);
	try {
		$result = $contract->send('transferResource', get_object_vars($send_data), $extra_data);
		$resultString = getTransactionResultString($result, $web3);		
		$smarty->assign('result', $resultString);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}