<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once(__DIR__ . '/vendor/autoload.php');
require_once('library.php');
require_once('session.php');

use stdClass; 
use SWeb3\SWeb3;
use SWeb3\Utils;
use SWeb3\SWeb3_Contract;
use phpseclib\Math\BigInteger as BigNumber;

define('ADMIN_ACCOUNT', '0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73');
define('ETH_PROVIDER', 'http://localhost:8545');
define('MAIN_CONTRACT_PATH', __DIR__ . '/contracts/Main');
define('MAIN_CONTRACT_PATH_JSON', MAIN_CONTRACT_PATH . '.json');
define('MAX_PRODUCT_ACTIVITIES', 5);
define('MAX_PRODUCT_AGGREGATE', 5);
define('MIN_TRUST', 30);
define('ROLE_ADMIN', 'admin');
define('ROLE_PRODUCER', 'producer');
define('ROLE_SENSOR', 'sensor');
define('ROLE_TRADER', 'trader');

require_once('operations.php');

$smarty = new Smarty();

$smarty->setTemplateDir(__DIR__ . '/smarty/templates');
$smarty->setCompileDir(__DIR__ . '/smarty/templates_c');
$smarty->setCacheDir(__DIR__ . '/smarty/cache');
$smarty->setConfigDir(__DIR__ . '/smarty/configs');

$boolContractDeploy = false;
$web3 = new SWeb3(ETH_PROVIDER);
$web3->chainId = hexdec($web3->call('eth_chainId', [])->result);
$contractInfo = json_decode(file_get_contents(MAIN_CONTRACT_PATH_JSON));

$accountsInitial = new ArrayObject(array(
	ADMIN_ACCOUNT => [ROLE_ADMIN],
	'0x627306090abaB3A6e1400e9345bC60c78a8BEf57' => [],
	'0xf17f52151EbEF6C7334FAD080c5704D77216b732' => [],
	'0x03Dd24EE515e6c74cE6EA24Ea94aaC55547e5044' => [],
	'0x6d832866fB72F5f78AE7a4B7cddf1721E8343094' => [],
	'0xE6aBF89FCEB42Cfb5F581550A958e2D364375eF2' => [],
	'0x1180b3f981ceb70e2E39e0EEdB0c1C0A1a1e0eB4' => []
));

$abi = file_get_contents(MAIN_CONTRACT_PATH . '.abi');
$res = $web3->call('eth_getCode', [$contractInfo->contractAddress, 'latest']);
if ($res->result !== '0x') {	
	$contract = new SWeb3_contract($web3, $contractInfo->contractAddress, $abi);
	$accounts = getAccountsRoles($accountsInitial, $contract);
    $smarty->assign('accounts', $accounts);	
	require_once('main.php');	
} else {
	$accounts = $accountsInitial->getArrayCopy();
	$boolContractDeploy = true;
    $contract = new SWeb3_contract($web3, '', $abi);	
	require_once('sign.php');
	$accountAdmin = [];
	$accountAdmin[ADMIN_ACCOUNT] = $accounts[ADMIN_ACCOUNT];
	$smarty->assign('accounts', $accountAdmin);	
}
$smarty->display('index.tpl');