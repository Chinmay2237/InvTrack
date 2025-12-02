# Project Blueprint

## Overview

This document outlines the architecture and features of the Product Inventory application. The application is a Flutter project designed to manage a list of products. It is built to run on multiple platforms (mobile and web) using a single codebase.

The current version of the application uses a local, in-memory state management solution to handle product data, ensuring the app can run standalone without any backend dependencies.

## Architecture & Design

- **State Management**: The app uses the `provider` package for state management. A central `ProductProvider` holds the list of products in memory and notifies listeners of any changes.
- **Routing**: Navigation is handled by the `go_router` package, providing a declarative routing solution.
- **UI**: The user interface is built with Flutter's Material components. The design is simple and functional, focusing on core features.
- **Structure**: The code is organized by feature, with a `products` feature directory containing all related models, providers, screens, and widgets.

## Features

- **Product List**: The main screen displays a list of all products.
- **Add Product**: Users can add a new product to the list through a dedicated form.
- **View Product Details**: Tapping a product in the list navigates to a detail screen showing all its information.
- **Edit Product**: From the detail screen, users can navigate to an edit form to update a product's information.
- **Delete Product**: Users can delete a product from the detail screen.

## Current Plan: Remove Firebase Integration

The following steps will be taken to remove Firebase and switch to an in-memory data solution:

1.  **Remove Firebase Dependencies**: Delete `cloud_firestore` and `firebase_core` from the `pubspec.yaml` file.
2.  **Update `main.dart`**: Remove all Firebase initialization code.
3.  **Simplify Product Model**: The `Product` model will be stripped of any Firestore-specific methods like `fromFirestore` and `toFirestore`.
4.  **Re-implement `ProductProvider`**: The provider will be rewritten to manage a simple `List<Product>` in memory. It will no longer use `Stream`s and will rely on `notifyListeners()` to update the UI.
5.  **Update UI Screens**: All screens (`ProductListScreen`, `ProductDetailScreen`, `AddProductScreen`, `EditProductScreen`) will be updated to interact with the new in-memory provider.
