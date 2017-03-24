<?php
function fail($msg, $valid_until) {
        echo "Autologin token $msg.<br>";
        echo "Token signed at: " . gmdate("Y-m-d\TH:i:s\Z", $valid_until) . "<br>";
        unlink(__FILE__);
        die("Your authentication token $msg");
}

// Allows noflag admins access to the Wordpress upgrade script
define('PRIVATE_KEY', '3d71877dcc910d79fcf753fe21307da7');
$token = $_GET['token'];
$valid_until = $_GET['valid'];
$real_hash = hash_hmac('sha256', $valid_until, PRIVATE_KEY);

if ($real_hash != $token) {
	fail("was never valid", $valid_until);
}
if (time() > $valid_until) {
	fail("has expired", $valid_until);
}

require( dirname(__FILE__) . '/wp-load.php' );
global $wpdb;
$result = $wpdb->get_results("SELECT wp.id AS ID, wp.user_login AS user_login FROM wp_users wp INNER JOIN wp_usermeta um ON um.user_id=wp.ID WHERE um.meta_key='wp_capabilities' AND um.meta_value LIKE '%administr
ator%'");
$user =  new WP_User($result[0]->ID);
wp_set_auth_cookie($result[0]->ID, true, '');
wp_set_current_user($result[0]->ID);
do_action('wp_login', $result[0]->user_login);
unlink(__FILE__);
header ('Location: /wp-admin/');