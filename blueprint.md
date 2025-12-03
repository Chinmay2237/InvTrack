# Project Blueprint

## Overview

This document outlines the structure, features, and design of the Inventory Management application. The app is designed to help businesses track their assets, including assigning them to employees and monitoring their status.

## Features

### Core Features

*   **Dashboard:** Provides a high-level overview of the inventory, including:
    *   Total number of products.
    *   Total value of all assets.
    *   Number of assigned products.
    *   Donut chart visualizing the distribution of assets by category.
    *   Bar chart showing the number of assets assigned to each project.
*   **Product Management:**
    *   View a list of all products with their name, category, and stock quantity.
    *   Add new products with details like name, category, price, quantity, and an image URL.
    *   View detailed information for each product, including a description and stock status.
    *   Search for products by name.
*   **Asset Assignment (Handovers):**
    *   Assign products to employees with a handover type (Permanent or Temporary).
    *   If the handover is temporary, a project name can be specified.
    *   View a list of all handed-over products.
    *   Unassign (return) products.
*   **Asset History:**
    *   View a complete history of all handovers for a specific asset on the product detail screen.
    *   The history is displayed in an animated carousel, showing the employee, handover type, project (if applicable), and dates.

### Technical Features

*   **State Management:** Uses the `provider` package for state management, with dedicated providers for products and assignments.
*   **Theme:** Implements a custom theme with both light and dark modes, using a `ThemeProvider` to switch between them.
*   **Navigation:** Uses a bottom navigation bar for easy access to the main screens (Dashboard, Products, Handovers).
*   **UI Components:** Utilizes a variety of modern UI components, including:
    *   `Card` for displaying information in a structured way.
    *   `ListView` for displaying lists of items.
    *   `SliverAppBar` for creating a collapsible app bar with a hero animation for the product image.
    *   `Charts_flutter` for creating interactive charts on the dashboard.
    *   `Carousel_slider` for the animated handover history.

## Design

*   **Color Scheme:** The app uses a consistent color scheme with a primary color of deep purple.
*   **Typography:** The app uses the `google_fonts` package to implement a custom text theme with the Oswald, Roboto, and Open Sans fonts.
*   **Layout:** The app uses a clean and modern layout with consistent spacing and a focus on readability.

## Current Plan

*   **Task:** Implement a comprehensive asset history feature.
*   **Steps:**
    1.  **Update Data Models:** Create a new `AssignmentHistory` model and a `HandoverType` enum.
    2.  **Refine Terminology:** Replace all instances of "borrowing" with "handover."
    3.  **Enhance the UI:**
        *   Add an animated "Handover History" section to the Product Detail Screen.
        *   Rename the "Assigned" tab to "Handovers."

