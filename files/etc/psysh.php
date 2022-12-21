<?php

$config = [
    'defaultIncludes' => [],
];

/**
 * Composer autoload.
 */
if (file_exists(getcwd() . '/vendor/autoload.php')) {
    $config['defaultIncludes'][] = getcwd() . '/vendor/autoload.php';
}

return $config;
