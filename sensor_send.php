<?php
if (isset($_POST['temperature'])) {
	$extra_data = ['nonce' => $web3->personal->getNonce()];
	try {
		$result = $contract->send(
			'sensorSendData',
			[$_POST['temperature']],
			$extra_data
		);
		$resultString = getTransactionResultString($result, $web3);		
		$res = $contract->getLogs('latest');
		if (is_array($res) &&
			count($res)>0) {
			$resultString .= 'In the logs there is an event called ' .
			$res[0]->event_name;
		} else {
			$resultString .= 'There are no events in the logs';
		}				
		$smarty->assign('result', $resultString);
	} catch (Exception $e) {
		$smarty->assign('result', 'ERROR!!!&#13;&#10' . $e->getMessage());
	}	
}