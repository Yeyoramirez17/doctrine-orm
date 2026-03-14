<?php

declare(strict_types=1);

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(name: 'db:connect')]
class DBConnectCommand extends Command
{

    protected function configure(): void
    {
        $this->setDescription('Test database connection')
            ->setHelp('This command allows you to test the database connection');
    }

    public function __invoke(SymfonyStyle $io): int
    {
        try {
            $entityManager = \App\Core\DoctrineORM::getInstance();
            $connection = $entityManager->getConnection();

            $result = $connection->executeQuery('SELECT now();');
            $io->success('Database connection successful!');
        } catch (\Exception $e) {
            $io->error('Database connection failed: ' . $e->getMessage());
        }

        return Command::SUCCESS;
    }
}
