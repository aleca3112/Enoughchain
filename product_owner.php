<?php
if (isset($_POST['productID'])) {
	$resultString = 'The owner of the product is ' . $contract->call('getProductOwner', [$_POST['productID']])->result . '.';
	$smarty->assign('result', $resultString);
}