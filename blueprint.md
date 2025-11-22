# Blueprint: InvTrack - Inventory Management App (Flutter Web)

## 1. Overview

InvTrack is a clean, simple, and modern Flutter Web application designed for efficient inventory management. It prioritizes ease of use, a lightweight architecture, fast performance, and smooth transitions with basic animations. The app uses Firestore for data storage and Firebase Storage for product images. It is built to be production-ready for a quick delivery and pitch.

## 2. Core Features

*   **Authentication (Static Login):**
    *   A simple static username + password login system (`admin` / `InvTrack@123`).
    *   Login status stored locally using `localStorage`.
    *   All routes, except the login screen, are protected and require authentication.
*   **Product Management:**
    *   **Add & Manage Products:** Create new products with details: name, serial number, category, cost, assigned to, notes, and an optional image.
    *   **Edit Products:** Modify existing product details.
    *   **Delete Products:** Remove products from the inventory.
    *   **View Products:** Products displayed in a clean, searchable, and filterable table view.
    *   **Search & Filter:** Easily find products by serial number, name, and status.
    *   **Assign Items:** Assign products to specific employees or locations.
    *   **Image Upload:** Upload product images to Firebase Storage.
    *   **Product History Log (Simple):** Track basic events like creation, updates, and assignments.
    *   **CSV Import & Export:** Basic functionality for importing and exporting product data.
*   **Category-Specific Pages:**
    *   Dedicated pages for various product categories (e.g., Laptops, Mobiles, Accessories, Furniture, Others).
    *   Each category features its own:
        *   Product List Page
        *   Add Product Page
        *   Edit Product Page
        *   Product Detail Page
*   **Dashboard:**
    *   Displays key inventory metrics (e.g., Total Items, Assigned, Available) in an easy-to-digest format using cards.
*   **Navigation:**
    *   A robust routing system using `go_router` for seamless navigation between the login screen, dashboard, and all category-specific product pages.
    *   **Route Protection:** Ensures only authenticated users can access protected routes.
    *   **Sidebar Navigation:** A consistent sidebar provides easy access to different product categories and other main sections.
*   **Styling & UX:**
    *   Light theme with soft shadows, rounded corners, clean typography, simple colors, and modern spacing.
    *   Smooth page transitions (Fade or Slide).
    *   `AnimatedList` or `AnimatedSwitcher` for product updates (considered for future enhancement or alternative list views, currently relies on `DataTable`'s inherent update mechanism).
    *   Clean layout and modern Material Design 3 aesthetic.
    *   Simple console logs for debugging (e.g., `[InvTrack] Product added`).

## 3. Tech Stack

*   **Platform:** Flutter Web only
*   **State Management:** Provider (for simple, efficient state management)
*   **Routing:** `go_router`
*   **Database:** Cloud Firestore
*   **Storage:** Firebase Storage
*   **CSV Handling:** `csv` package
*   **File Picking:** `file_picker` package

## 4. Backend (Firebase Services)

*   **Firestore:** Primary database for storing all product details and history logs.
*   **Firebase Storage:** Used for storing all product images uploaded by users.
*   **Optional Cloud Function:** (Future consideration) To automatically create history log entries upon product updates or assignments.

## 5. UI/UX Modernization Plan

This section outlines the plan to refactor and modernize the UI/UX of the InvTrack application, adhering to the user's request.

### 5.1. Folder Structure Refactoring

- **Goal:** Improve organization and separation of concerns.
- **Actions:**
    - Consolidate UI-related files into a more intuitive structure.
    - `lib/features/{feature}/screens` will be moved to `lib/ui/screens/{feature}`.
    - `lib/features/{feature}/widgets` will be moved to `lib/ui/widgets/{feature}`.
    - Create `lib/ui/widgets/common` for highly reusable components (e.g., `PrimaryButton`, `AppTextField`).
    - Create `lib/ui/widgets/layout` for structural elements like `AppScaffold`, `Sidebar`, and `TopAppBar`.

### 5.2. Theme Modernization (Material 3)

- **Goal:** Implement a modern, cohesive, and visually appealing theme.
- **Actions:**
    - Update `lib/core/theme/modern_theme.dart`.
    - Implement `ThemeData` using `ColorScheme.fromSeed` with a primary color.
    - Define custom styles for `AppBar`, `ElevatedButton`, `Card`, `InputDecoration`, and `TextTheme` to ensure consistency.
    - Implement both light and dark themes.

### 5.3. Reusable Component Creation

- **Goal:** Reduce code duplication and build a consistent UI library.
- **Widgets to Create:**
    - **`AppScaffold`:** A stateful widget managing the main layout, including a responsive sidebar and a top app bar.
    - **`SummaryCard`:** A stateless widget for dashboard metrics, featuring an icon, title, value, and subtle styling.
    - **`StatusChip`:** A widget to display product status (In Stock, Low, Out of Stock) with appropriate colors.
    - **`PrimaryButton`:** A customized `ElevatedButton` for primary actions.
    - **`AppTextField`:** A styled `TextFormField` for consistent input fields.
    - **`ResponsiveDataTable`:** A wrapper around `DataTable` to handle responsive behavior and consistent styling.

### 5.4. Page-by-Page Redesign

- **Login Page (`login_screen.dart`):**
    - **Layout:** Centered card on a clean background.
    - **Components:** Use `AppTextField` for email/password, `PrimaryButton` for login.
    - **UX:** Add "Remember me" checkbox and "Forgot password?" text button. Implement clear validation feedback.

- **Main Layout (`AppScaffold`):**
    - **App Bar:** App name/logo, a global search bar, and a user profile menu.
    - **Sidebar:** Collapsible navigation with icons and labels for Dashboard, Products, etc. Use `AnimatedContainer` for smooth collapse/expand transitions.

- **Dashboard Page (`dashboard_screen.dart`):**
    - **Layout:** Grid-based layout for summary cards.
    - **Components:** Use `SummaryCard` for key metrics. Add a placeholder for a chart and a list for recent activities.

- **Products Page (`product_list_page.dart`):**
    - **Layout:** Use the new `ResponsiveDataTable`.
    - **Toolbar:** Add search and filter controls.
    - **Actions:** An FAB or styled button to trigger the "Add Product" dialog/side sheet.
    - **Add/Edit Form (`product_form.dart`):** Redesign for clarity and use within a modal. Improve validation and input decoration.

- **Other Pages (Categories, Stock, Suppliers):**
    - Apply the same principles: use the `AppScaffold`, `ResponsiveDataTable`, and consistent styling for a unified look and feel.

### 5.5. Animations and Transitions

- **Goal:** Enhance the user experience with subtle, professional animations.
- **Implementations:**
    - **Page Transitions:** Use `FadeTransition` or `SlideTransition` for routing.
    - **Hero Animations:** Apply to product images when navigating from the product list/grid to the detail page.
    - **AnimatedContainer:** For the collapsible sidebar and other state-dependent UI changes.
    - **AnimatedOpacity:** For showing/hiding elements smoothly.

## 6. Detailed Outline

### 6.1 Authentication System

*   **`AuthService` (`lib/core/services/auth_service.dart`):**
    *   Refactored to remove all Firebase Auth imports and dependencies.
    *   Implements static login logic: username `admin`, password `InvTrack@123`.
    *   Uses `shared_preferences` for `localStorage` to persist login status.
    *   `signInWithEmailAndPassword` method now performs static credential check and updates `localStorage`.
    *   `signOut` method clears login status from `localStorage`.
    *   `isLoggedIn` getter reflects the current login status from `_isLoggedIn` state, initialized from `localStorage`.
*   **`main.dart`:**
    *   Updated to remove `firebase_auth` import.
    *   `AuthService` provider initialization changed to `ChangeNotifierProvider(create: (_) => AuthService())`.
    *   `PageTransitionsTheme` added to `lightTheme` and `darkTheme` for smooth page transitions, using `FadeUpwardsPageTransitionsBuilder` for mobile platforms and `ZoomPageTransitionsBuilder` for desktop platforms.
*   **`app_router.dart`:**
    *   `GoRoute` entries for `/signup` and `/forgot-password` have been removed.
    *   The `redirect` logic is updated to specifically handle `/login` as the only unauthenticated entry point.
    *   Unauthenticated users are redirected to `/login`.
    *   Logged-in users attempting to access `/login` are redirected to the home page (`/`).
*   **`LoginScreen` (`lib/features/authentication/screens/login_screen.dart`):**
    *   Implemented with `TextFormField` for username and password.
    *   Includes an `ElevatedButton` to trigger `AuthService.signInWithEmailAndPassword`.
    *   Provides visual feedback (`SnackBar`) for successful login and navigates to the dashboard or error messages for failed attempts.
    *   Designed with a clean, modern UI, rounded corners, and soft shadows.
*   **Deleted Files:**
    *   `lib/features/authentication/widgets/auth_widget_builder.dart`
    *   `lib/features/authentication/screens/forgot_password_screen.dart`
    *   `lib/features/authentication/screens/signup_screen.dart`

### 6.2 Product Management

*   **`Product` Model (`lib/features/products/models/product.dart`):**
    *   Updated to include fields: `id`, `name`, `serialNumber`, `category`, `cost`, `assignedTo`, `notes`, `imageUrl`, `createdAt`, `updatedAt`.
    *   `fromFirestore` and `toFirestore` methods are adjusted to correctly serialize/deserialize these fields, including `DateTime` from Firestore `Timestamp` and `FieldValue.serverTimestamp()`.
*   **`History` Model (`lib/core/models/history.dart`):**
    *   Created with fields: `id`, `productId`, `action`, `timestamp`, `details`.
    *   Includes `fromFirestore` and `toFirestore` methods for serialization.
*   **`FirestoreService` (`lib/core/services/firestore_service.dart`):**
    *   Imports `firebase_storage/firebase_storage.dart`.
    *   Initializes `FirebaseStorage.instance` for image uploads.
    *   `addProduct` and `updateProduct` methods handle `createdAt` (only on add) and `updatedAt` (on both) using `FieldValue.serverTimestamp()`.
    *   Includes `uploadProductImage` method to upload `Uint8List` image data to Firebase Storage, returning the download URL.
    *   `getProducts` and `getProductById` are updated to fetch and map all new `Product` model fields.
    *   Added `CollectionReference _historyCollection = _db.collection('history');`.
    *   Implemented `Future<void> addHistoryEntry(History history)` to save history records.
    *   `addProduct` and `updateProduct` now call `addHistoryEntry` to log creation and updates, respectively.
    *   Added `Stream<List<History>> getProductHistory(String productId)` to retrieve history for a specific product.
    *   Added `Future<List<Product>> getAllProducts()` to fetch all products for CSV export.
*   **`ProductList` Widget (`lib/features/products/widgets/product_list.dart`):**
    *   Refactored from `StatelessWidget` to `StatefulWidget` to manage search state.
    *   Features a search input field (`TextFormField` with `TextEditingController`) for filtering by `serialNumber`, `name`, and `assignedTo`.
    *   Displays product data in a `DataTable` format, showing `name`, `serialNumber`, `assignedTo`, `category`, `cost`, and action buttons (`Edit`, `Delete`).
    *   Uses `StreamBuilder` to reactively display product data from `FirestoreService`.
    *   Implements `_deleteProduct` method to call `firestoreService.deleteProduct` and handles navigation to `details` or `edit` pages via `go_router`.
    *   `AnimatedList` or `AnimatedSwitcher` were considered for individual item updates but not directly implemented with `DataTable` to preserve its structural benefits. The `StreamBuilder` ensures data updates are smoothly reflected.
*   **`AddProductPage` (`lib/features/products/screens/add_product_page.dart`):**
    *   Provides a form with `TextFormField`s for all product details.
    *   Includes a button for image picking using `file_picker` and displays a preview.
    *   Uses `DropdownButtonFormField` for category selection from predefined options.
    *   `ElevatedButton` for saving, triggering form validation, image upload (if new), and calling `firestoreService.addProduct`.
    *   Provides `SnackBar` feedback and navigates back on success.
*   **`EditProductPage` (`lib/features/products/screens/edit_product_page.dart`):**
    *   Form fields are pre-filled with existing product data fetched using `firestoreService.getProductById(productId)`.
    *   Displays the current `imageUrl` and allows picking a new one, which replaces the old one upon update.
    *   **Hero Animation for Image:** The product image display is wrapped in a `Hero` widget using `'product-image-${widget.productId}'` as the tag, enabling smooth visual transitions.
    *   **Image Upload Progress Indicator:** A `LinearProgressIndicator` is shown during image upload, providing visual feedback to the user.
    *   **Clear Image Button:** A dedicated button allows users to clear a newly selected image before saving.
    *   **Enhanced Form Field Styling:** All `TextFormField`s now consistently use `const InputDecoration` for optimized performance and a uniform, modern appearance.
    *   **Refined UI Layout:** Minor adjustments have been made to spacing, padding, and widget composition for improved visual balance and aesthetic appeal.
    *   **Robust Error Handling:** More comprehensive error handling and `SnackBar` messages are implemented for image picking and product update processes.
    *   `ElevatedButton` for updating, handling form validation, image re-upload (if new), and calling `firestoreService.updateProduct`.
    *   Ensures `createdAt` remains constant and `updatedAt` is updated on save.
    *   Provides `SnackBar` feedback and navigates back on success.
*   **`ProductDetailPage` (`lib/features/products/screens/product_detail_page.dart`):**
    *   Displays all product details in a clean layout.
    *   **Hero Animation for Image:** The product image display is wrapped in a `Hero` widget using `'product-image-${product.id}'` as the tag, matching the `EditProductPage` for seamless transitions.
    *   Shows the product image if `imageUrl` is available.
    *   Uses `FutureBuilder` to asynchronously load and display product data.
    *   Includes loading (`CircularProgressIndicator`) and error states.
    *   A 'Product History' section has been added. It uses a `StreamBuilder` to display history entries fetched via `firestoreService.getProductHistory(productId)`, showing action, timestamp, and details, with formatted timestamps.

### 6.3 CSV Import & Export

*   **`CsvImportPage` (`lib/features/csv/screens/csv_import_page.dart`):**
    *   Provides a "Pick CSV File" button using `file_picker`.
    *   Parses the selected CSV file using the `csv` package.
    *   Displays parsed data in a `DataTable` for user preview.
    *   An "Import" button processes the previewed data, iterating to add/update products in Firestore via `FirestoreService`.
    *   Includes error handling and `SnackBar` messages for user feedback, along with console logging for actions.
    *   Assumes CSV headers match `Product` model fields for data mapping.
*   **`app_router.dart`:**
    *   Added a `GoRoute` for `/csv-import` pointing to `CsvImportPage`.
*   **`sidebar.dart`:**
    *   A new `ListTile` for 'CSV Import' has been added to the `Drawer`, linking to the `/csv-import` route.
*   **CSV Export (`DashboardScreen`):**
    *   An 'Export to CSV' button has been added to the `DashboardScreen`.
    *   When pressed, it fetches all products using `firestoreService.getAllProducts()`.
    *   Converts the product list into CSV format, including headers for all product fields.
    *   Initiates a file download (`invtrack_products.csv`) using `dart:html` for web compatibility.
    *   Provides `SnackBar` feedback for success or failure.

### 6.4 Dashboard

*   **`DashboardScreen` (`lib/features/dashboard/screens/dashboard_screen.dart`):**
    *   Features an `AppBar` with "Dashboard" title and a logout button.
    *   Displays three placeholder cards: "Total Items", "Assigned", and "Available".
    *   Includes an 'Export to CSV' button as detailed above.
    *   Logout button calls `AuthService.signOut` and navigates to the login page.
    *   Designed with a clean, modern UI, rounded corners, and soft shadows.

## 7. Goal

To deliver a simple, smooth, well-structured, and production-ready Flutter Web inventory management app (InvTrack) with separate pages for different product categories, basic animations, clean UI, and robust static authentication, suitable for immediate demonstration and deployment.
