<?php
/**
 * Shamelessly stolen from Pantheon, who use a similar setup.
 *
 * This config file is yours to hack on. It will work out of the box on Pantheon
 * but you may find there are a lot of neat tricks to be used here.
 *
 * See our documentation for more details:
 *
 * https://pantheon.io/docs
 */

if (file_exists('/var/www/' . $_ENV['PRIMARY_SUBDOMAIN'] . '/public_html/wp-config.php')):
   require_once('/var/www/' . $_ENV['PRIMARY_SUBDOMAIN'] . '/public_html/wp-config.php');

/**
 * Platform settings. Everything you need should already be set.
 */
else:
    // ** MySQL settings - included in the Pantheon Environment ** //
    /** The name of the database for WordPress */
    define('DB_NAME', $_ENV['DB_NAME']);

    /** MySQL database username */
    define('DB_USER', $_ENV['DB_USER']);

    /** MySQL database password */
    define('DB_PASSWORD', $_ENV['MYSQL_PWD']);

    if ($_ENV['MYSQL_HOST'] == "localhost") {
        define('DB_HOST', 'localhost');
	} else {
		   /** MySQL hostname; on Pantheon this includes a specific port number. */
	    define('DB_HOST', $_ENV['MYSQL_HOST'] . ':' . $_ENV['MYSQL_TCP_PORT']);
	}
    /** Database Charset to use in creating database tables. */
    define('DB_CHARSET', 'utf8');

    /** The Database Collate type. Don't change this if in doubt. */
    define('DB_COLLATE', '');

    if (!isset($_ENV['HTTP_HOST']) && (isset($_ENV['SERVER_NAME']))) {
        $_ENV['HTTP_HOST'] = $_ENV['SERVER_NAME'];
    }
    if (!isset($_ENV['HTTP_HOST']) && (isset($_ENV['HOSTNAME']))) {
        $_ENV['HTTP_HOST'] = $_ENV['HOSTNAME'];
    }
    /**#@+
     * Authentication Unique Keys and Salts.
     *
     * Change these to different unique phrases!
     * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
     * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
     *
     * Pantheon sets these values for you also. If you want to shuffle them you
     * can do so via your dashboard.
     *
     * @since 2.6.0
     */
    if (file_exists(dirname(__FILE__) . '/salts.php')) {
    	include(dirname(__FILE__) . '/salts.php');
    } elseif (isset($_ENV['SALTS_FILE'])) {
        include $_ENV['SALTS_FILE'];
    } else {
	    define('AUTH_KEY',         $_ENV['AUTH_KEY']);
	    define('SECURE_AUTH_KEY',  $_ENV['SECURE_AUTH_KEY']);
	    define('LOGGED_IN_KEY',    $_ENV['LOGGED_IN_KEY']);
	    define('NONCE_KEY',        $_ENV['NONCE_KEY']);
	    define('AUTH_SALT',        $_ENV['AUTH_SALT']);
	    define('SECURE_AUTH_SALT', $_ENV['SECURE_AUTH_SALT']);
	    define('LOGGED_IN_SALT',   $_ENV['LOGGED_IN_SALT']);
	    define('NONCE_SALT',       $_ENV['NONCE_SALT']);
	    /**#@-*/
	}

    /** A couple extra tweaks to help things run well on Pantheon. **/
    if (isset($_ENV['HTTP_HOST']) && ($_ENV['HTTP_HOST'] != "")) {
        // HTTP is still the default scheme for now.
        $scheme = 'http';
        // If we have detected that the end use is HTTPS, make sure we pass that
        // through here, so <img> tags and the like don't generate mixed-mode
        // content warnings.
        if (isset($_ENV['HTTP_USER_AGENT_HTTPS']) && $_ENV['HTTP_USER_AGENT_HTTPS'] == 'ON') {
            $scheme = 'https';
            $_SERVER['HTTPS']='on';
        }
        if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
            $scheme = 'https';
            $_SERVER['HTTPS']='on';
        }

        define('WP_HOME', $scheme . '://' . $_ENV['HTTP_HOST']);
        define('WP_SITEURL', $scheme . '://' . $_ENV['HTTP_HOST']);
    }

    if (isset($_ENV['WP_CONTENT_DIR']) && ($_ENV['WP_CONTENT_DIR'] != "")) {
        define('WP_CONTENT_DIR', $_ENV['WP_CONTENT_DIR']);
    }

    if (file_exists($_ENV['WEBROOT'] . '/wp-config-inc.php')) {
        include_once($_ENV['WEBROOT'] . '/wp-config-inc.php');
    }
    if (file_exists(dirname(__FILE__) . '/wp-config-inc.php')) {
        include_once(dirname(__FILE__) . '/wp-config-inc.php');
    }
    // Force the use of a safe temp directory when in a container
    #if ( defined( 'PANTHEON_BINDING' ) ):
    #    define( 'WP_TEMP_DIR', sprintf( '/srv/bindings/%s/tmp', PANTHEON_BINDING ) );
    #endif;

    // FS writes aren't permitted in test or live, so we should let WordPress know to disable relevant UI
    if ( in_array( $_ENV['ENVIRONMENT'], array( 'test', 'live' ) ) && ! defined( 'DISALLOW_FILE_EDIT' ) ) :
        define('DISALLOW_FILE_EDIT', true);
    endif;

endif;

/** Standard wp-config.php stuff from here on down. **/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */

if (isset($_ENV['MAX_SIZE']) && ($_ENV['MAX_SIZE'] != "")) {
	ini_set( 'upload_max_size' , $_ENV['MAX_SIZE'] );
	ini_set( 'post_max_size', $_ENV['MAX_SIZE']);
} else {
	ini_set( 'upload_max_size' , '32M' );
	ini_set( 'post_max_size', '32M');
}
if (isset($_ENV['MAX_EXECUTION_TIME']) && ($_ENV['MAX_EXECUTION_TIME'] != "")) {
	ini_set( 'max_execution_time', $_ENV['MAX_EXECUTION_TIME'] );
} else {
	ini_set( 'max_execution_time', '180' );
}

if (isset($_ENV['WP_PREFIX']) && ($_ENV['WP_PREFIX'] != "")) {
    $table_prefix = $_ENV['WP_PREFIX'];
} else {
    $table_prefix = 'wp_';
}

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */

if (isset($_ENV['WPLANG']) && ($_ENV['WPLANG'] != "")) {
    define('WPLANG', $_ENV['WPLANG']);
} else {
    define('WPLANG', "");
}


/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * You may want to examine $_ENV['ENVIRONMENT'] to set this to be
 * "true" in dev, but false in test and live.
 */

if (isset($_ENV['WP_DEBUG']) && ($_ENV['WP_DEBUG'] == "true")) {
     define('WP_DEBUG', true); 
     error_reporting(0);
} else {
     define('WP_DEBUG', false);   
     error_reporting(E_ALL);
}

/* That's all, stop editing! Happy Pressing. */

define( 'WP_AUTO_UPDATE_CORE', false );


/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');