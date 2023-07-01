<?php
if (isset($_POST['productID'])) {
	$resource = $contract->call('getProductResource', [$_POST['productID']])->tuple_1;
	$resultString = 'Product components: &#13;&#10;&#13;&#10;' .
	'Name: ' . $resource->name . '&#13;&#10;' .
	'GHG: ' . $resource->GHG;
	$smarty->assign('result', $resultString);
}