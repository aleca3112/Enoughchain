<?php
if (isset($_GET['login'])) {
	require_once('sign.php');
} else {
	$smarty->assign('body', 'main.tpl');
	$newOperation = [];		
	if (isset($_SESSION['account'])) {
		foreach($operations as $operation) {
			if ($operation->auth) {
				$result = false;
				foreach($operation->permission as $permission) {
					if (in_array($permission, $_SESSION['account']->permission, true)) {
						$result = true;
						break;
					}
				}
				if ($result) {
					$newOperation[] = $operation;
				}
			}
		}
		$smarty->assign('account', $_SESSION['account']->address);
		$smarty->assign('permissions', implode(', ', $_SESSION['account']->permission));
		$smarty->assign('logged', true);
		$web3->setPersonalData($_SESSION['account']->address, $_SESSION['account']->privateKey);
	} else {
		$smarty->assign('logged', false);
	}
	foreach($operations as $operation) {
		if (!$operation->auth)
		$newOperation[] = $operation; 
	}
	$smarty->assign('operations', $newOperation);
	if (isset($_GET['page'])) {
		$smarty->assign('result', 'Result will be visible here!');
		require_once($_GET['page'] . '.php');
		$smarty->assign('page', $_GET['page'] . '.tpl');
	}
}