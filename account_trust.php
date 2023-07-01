<?php
if (isset($_POST['selectAccount'])) {
	$resultString = 'Account trust value is ' . $contract->call('getStakeholderTrust', [$_POST['selectAccount']])->result . '.';
	$smarty->assign('result', $resultString);
}