<?php

declare(strict_types=1);

use App\Command\HelloCommand;
use Dotenv\Dotenv;
use Symfony\Component\Console\Application;

require_once __DIR__ . '/../vendor/autoload.php';

$dotenv = Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

$application = new Application('Doctrine ORM', '1.0.0');
$application->addCommand(new HelloCommand());

$application->run();
