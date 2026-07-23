<?php declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

return (new Config())
    ->setRules([
        '@PHP82Migration' => true,
        '@PSR12' => true,
        '@PhpCsFixer' => true,
        '@Symfony' => true,
    ])
    ->setFinder((new Finder())->ignoreDotFiles(false)->ignoreVCSIgnored(true)->in(__DIR__));
