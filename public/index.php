<?php

declare(strict_types=1);

use App\Command\DBConnectCommand;
use App\Command\HelloCommand;
use App\Core\DoctrineORM;
use Doctrine\ORM\Tools\Console\ConsoleRunner;
use Doctrine\ORM\Tools\Console\EntityManagerProvider\SingleManagerProvider;
use Dotenv\Dotenv;
use Symfony\Component\Console\Application;

require_once __DIR__ . '/../vendor/autoload.php';

$dotenv = Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();


$version = \Composer\InstalledVersions::getPrettyVersion('doctrine/orm');

$application = new Application('Doctrine ORM', $version);
$application->addCommand(new HelloCommand());
$application->addCommand(new DBConnectCommand());

$entityManagerProvider = new SingleManagerProvider(DoctrineORM::getInstance());
ConsoleRunner::addCommands($application, $entityManagerProvider);

$application->run();
