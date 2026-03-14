<?php

return [
    'driver' => $_SERVER['DB_DRIVER'] ?? 'pdo_mysql',
    'host' => $_SERVER['DB_HOST'] ?? 'localhost',
    'port' => $_SERVER['DB_PORT'] ?? 3306,
    'dbname' => $_SERVER['DB_NAME'] ?? '',
    'user' => $_SERVER['DB_USER'] ?? '',
    'password' => $_SERVER['DB_PASSWORD'] ?? '',
];
