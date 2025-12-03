# Inventory Management App

## Overview

This is a Flutter application for managing an inventory of products. It allows users to view a list of products, see the details of each product, add new products, edit existing products, and delete products from the inventory. The application uses Firebase Firestore as its backend.

## Features

*   **Product List:** View a list of all products in the inventory.
*   **Product Details:** View the details of a specific product, including its name, description, price, and quantity.
*   **Add Product:** Add a new product to the inventory.
*   **Edit Product:** Edit the details of an existing product.
*   **Delete Product:** Delete a product from the inventory.
*   **Dashboard:** View a dashboard with a summary of the inventory.
*   **Theme Toggle:** Switch between light and dark themes.

## Project Structure

*   `lib/`
    *   `core/`
        *   `router/`
            *   `app_router.dart`: Defines the routes for the application.
        *   `theme/`
            *   `app_theme.dart`: Defines the light and dark themes for the application.
            *   `theme_provider.dart`: The provider for managing the theme.
    *   `features/`
        *   `home/`
            *   `screens/`
                *   `home_screen.dart`: The main screen of the application.
        *   `products/`
            *   `models/`
                *   `product.dart`: The model for a product.
            *   `providers/`
                *   `product_provider.dart`: The provider for managing the products using Firebase Firestore.
            *   `screens/`
                *   `product_list_screen.dart`: The screen for the product list.
                *   `add_product_screen.dart`: The screen for adding a new product.
                *   `product_detail_screen.dart`: The screen for the product details.
                *   `edit_product_screen.dart`: The screen for editing an existing product.
    *   `main.dart`: The main entry point of the application.
*   `blueprint.md`: This file.

