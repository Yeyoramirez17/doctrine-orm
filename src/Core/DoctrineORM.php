<?php

declare(strict_types=1);

namespace App\Core;

use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Exception\ConnectionException;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\ORMSetup;
use Exception;
use RuntimeException;

class DoctrineORM
{
    private string $entitiesPath;
    private ?array $dbConfig;

    private static ?EntityManager $entityManager = null;

    public function __construct(string $entitiesPath = __DIR__ . '/../Entities', ?array $dbConfig = null)
    {
        if (self::$entityManager === null) {
            try {
                $this->entitiesPath = $entitiesPath;
                $this->dbConfig = $dbConfig ?? require __DIR__ . '/../../config/database.php';

                $config = ORMSetup::createAttributeMetadataConfiguration(
                    paths: [$this->entitiesPath],
                    isDevMode: true
                );

                $connection = DriverManager::getConnection(
                    params: $this->dbConfig,
                    config: $config
                );

                self::$entityManager = new EntityManager($connection, $config);
            } catch (ConnectionException $e) {
                echo 'Error: ' . $e->getMessage();
                throw new RuntimeException('Error connecting to the database. Please check your configuration.');
            }
        }
    }

    /**
     * Get the singleton instance of the EntityManager.
     * @return EntityManager
     */
    public static function getInstance(): EntityManager
    {
        if (self::$entityManager == null) {
            try {
                $path = __DIR__ . '/../Entities';
                /** @var array<string, string> */
                $dbParams = require __DIR__ . '/../../config/database.php';

                $config = ORMSetup::createAttributeMetadataConfiguration(
                    paths: [$path],
                    isDevMode: true
                );

                $config->enableNativeLazyObjects(true);

                $connection = DriverManager::getConnection(
                    params: $dbParams,
                    config: $config
                );

                self::$entityManager = new EntityManager($connection, $config);
            } catch (ConnectionException $e) {
                echo 'Error: ' . $e->getMessage();
                throw new RuntimeException('Error connecting to the database. Please check your configuration.');
            }
        }
        return self::$entityManager;
    }
}
