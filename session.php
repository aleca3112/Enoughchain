<?php

session_start();

if (!isset($_SESSION['destroyed'])) {
    $_SESSION['destroyed'] = time();
}

if ($_SESSION['destroyed'] < time() - 3600) {
    session_regenerate_id(true);
} else {
	session_regenerate_id();
}