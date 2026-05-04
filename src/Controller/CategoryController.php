<?php

namespace App\Controller;

use App\Repository\CategoryRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

final class CategoryController extends AbstractController
{
    private CategoryRepository $repository;

    public function __construct(CategoryRepository $repository)
    {
        $this->repository = $repository;
    }
    #[Route('/category/all', name: 'app_category', methods: ['GET'])]
    public function index(): JsonResponse
    {
        $categories = $this->repository->findAll();

        return $this->json([
            'data' => $categories,
        ]);
    }
}
