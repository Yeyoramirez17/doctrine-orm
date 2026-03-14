<?php

declare(strict_types=1);

namespace App\Command;

use Symfony\Component\Console\Attribute\Argument;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Attribute\Option;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\ConsoleOutputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand('app:hello')]
class HelloCommand extends Command
{

    protected function configure(): void
    {
        $this->setDescription('Hello Command')
            ->setHelp('This command allows you to say hello');
    }

    public function __invoke(
        SymfonyStyle $io,
        #[Option(description: 'Name to greeting (optional)')] ?string $name = null
    ): int {

        if (empty($name)) {
            $name = 'World';
        }

        $greeting = sprintf('Hello %s', $name);

        $io->info($greeting);

        return Command::SUCCESS;
    }
}
