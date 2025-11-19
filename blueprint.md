# Blueprint: Inventory Tracking App

## 1. Overview

A Flutter application for tracking inventory items. It will use Firebase for authentication, data storage (Firestore), and image storage. The app will have a clean, modern interface and will be structured for future expansion.

## 2. Core Features

*   **User Authentication:**
    *   Login screen (using the existing `login_screen.dart`).
    *   Registration screen for new users.
    *   Authentication state management to show the correct screen (login vs. home).
*   **Inventory Management:**
    *   **Home Screen:** A dashboard displaying a list of all inventory items from Firestore.
    *   **Add/Edit Item Screen:** A form to create and update inventory items, including fields for name, description, quantity, and an image.
    *   **CRUD Operations:** A service class to handle Create, Read, Update, and Delete operations for items in Cloud Firestore.
    *   **Image Handling:** Users can upload item images from their device, which will be stored in Firebase Storage.
*   **Navigation:**
    *   A robust routing system using `go_router` to navigate between the login, registration, home, and add/edit screens.
*   **Styling & UX:**
    *   A consistent and modern theme using Material Design 3 and `google_fonts`.
    *   Loading indicators and user-friendly error messages.
