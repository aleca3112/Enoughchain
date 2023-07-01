<?php
$operations = [];

$operation = new stdClass();
$operation->auth = false;
$operation->description = 'Gets the trust value of an account.';
$operation->fa = 'fa-user';
$operation->page = 'account_trust';
$operation->permission = [];
$operation->title = 'Account trust';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = false;
$operation->description = 'Gets the information of a product.';
$operation->fa = 'fa-search';
$operation->page = 'product_search';
$operation->permission = [];
$operation->title = 'Product search';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = false;
$operation->description = 'Gets the owner account of the product.';
$operation->fa = 'fa-user-lock';
$operation->page = 'product_owner';
$operation->permission = [];
$operation->title = 'Product owner';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = 'Create a quality contract involving temperature.';
$operation->fa = 'fa-thermometer';
$operation->page = 'insert_quality';
$operation->permission = [ROLE_ADMIN];
$operation->title = 'Insert quality contract';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = 'Permit to add roles to accounts.';
$operation->fa = 'fa-users';
$operation->page = 'add_role';
$operation->permission = [ROLE_ADMIN];
$operation->title = 'Add role';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = 'A sensor that sends the current product temperature.';
$operation->fa = 'fa-tachometer-alt';
$operation->page = 'sensor_send';
$operation->permission = [ROLE_SENSOR];
$operation->title = 'Sensor: send data';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = 'Permit to create a new product.';
$operation->fa = 'fa-utensils';
$operation->page = 'insert_product';
$operation->permission = [ROLE_PRODUCER];
$operation->title = 'Insert product';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = ' Initializes the transfer of a product.';
$operation->fa = 'fa-truck-loading';
$operation->page = 'transfer_product';
$operation->permission = [ROLE_ADMIN];
$operation->title = 'Transfer product';
array_push($operations, $operation);

$operation = new stdClass();
$operation->auth = true;
$operation->description = 'Completes the transfer with a rating vote.';
$operation->fa = 'fa-truck-moving';
$operation->page = 'complete_transfer';
$operation->permission = [ROLE_PRODUCER, ROLE_TRADER];
$operation->title = 'Complete transfer';
array_push($operations, $operation);