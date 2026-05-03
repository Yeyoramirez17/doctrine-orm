<?php

namespace App\Command;

use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'TestConnection',
    description: 'Test database connection',
)]
class TestConnectionCommand extends Command
{
    private EntityManagerInterface $em;

    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addArgument('host', InputArgument::OPTIONAL, 'Database host')
            ->addArgument('port', InputArgument::OPTIONAL, 'Database port')
            ->addArgument('user', InputArgument::OPTIONAL, 'Database user')
            ->addArgument('pass', InputArgument::OPTIONAL, 'Database password')
            ->addArgument('db_name', InputArgument::OPTIONAL, 'Database name')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        try {
            $connection = $this->em->getConnection();
            
            $schemaManager = $connection->createSchemaManager();
            $tables = $schemaManager->introspectTableNames();

            if (empty($tables)) {
                $io->warning('Conexión establecida, pero no se encontraron tablas en la base de datos.');
            } else {
                $io->section('Tablas encontradas en la base de datos:');
                $tableRows = array_map(fn($table) => [$table->toString()], $tables);
                $io->table(['Nombre de la Tabla'], $tableRows);
                $io->success('Conexión a la base de datos exitosa.');
            }
        } catch (\Exception $e) {
            $io->error('Error de conexión: ' . $e->getMessage());
            return Command::FAILURE;
        }

        return Command::SUCCESS;
    }
}
