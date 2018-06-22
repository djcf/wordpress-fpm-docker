<?php
// Allows CommonWeal admins access to the Wordpress upgrade script
function fail($msg, $valid_until) {
        echo "Autologin token $msg.<br>";
        echo "Token signed at: " . gmdate("Y-m-d\TH:i:s\Z", $valid_until) . "<br>";
        unlink(__FILE__);
        die("Your authentication token $msg");
}

define('PRIVATE_KEY', $_ENV['MYSQL_PWD']);

$token = $_GET['token'];
$valid_until = $_GET['valid'];
$real_hash = hash_hmac('sha256', $valid_until, PRIVATE_KEY);

if ($real_hash != $token) {
	fail("was never valid", $valid_until);
}
if (time() > $valid_until) {
	fail("has expired", $valid_until);
}
if (isset($_ENV['WP_PREFIX']) && ($_ENV['WP_PREFIX'] != "")) {
	$PREFIX = $_ENV['WP_PREFIX'];
} else {
	$PREFIX = "wp_";
}
require( dirname(__FILE__) . '/wp-load.php' );
global $wpdb;
$result = $wpdb->get_results("SELECT wp.id AS ID, wp.user_login AS user_login FROM " . $PREFIX . "users wp INNER JOIN " . $PREFIX . "usermeta um ON um.user_id=wp.ID WHERE um.meta_key='" . $PREFIX . "capabilities' AND um.meta_value LIKE '%administrator%'");
$user =  new WP_User($result[0]->ID);
wp_set_auth_cookie($result[0]->ID, true, '');
wp_set_current_user($result[0]->ID);
do_action('wp_login', $result[0]->user_login);
unlink(__FILE__);
header ('Location: /wp-admin/');