# InvTrack Blueprint

## Overview

InvTrack is a Flutter application designed for efficient inventory management. It allows users to track products, categorize them, and manage their assignments. The application is built with a focus on a clean, modern user interface and a robust architecture.

## Style and Design

- **Theming**: The application uses a modern, Material 3 theme with a custom color scheme derived from a seed color. It supports both light and dark modes.
- **Typography**: The app uses the `google_fonts` package to provide a consistent and aesthetically pleasing set of text styles.
- **Layout**: The layout is designed to be responsive and work well on both mobile and web. It uses a combination of `ListView`, `GridView`, and `CustomScrollView` to display data effectively.
- **Components**: The app uses a variety of Material Design components, including `Card`, `ElevatedButton`, `IconButton`, `TextField`, `DropdownButtonFormField`, and `ChoiceChip`.

## Features

- **Product Management**: Users can add, edit, and delete products. Each product can have a name, category, price, serial number, assigned user, and notes.
- **Image Uploads**: Users can upload images for each product. Images are stored in Firebase Storage.
- **Search and Filtering**: Users can search for products by name or serial number and filter them by category.
- **Data Persistence**: Product data is stored in Cloud Firestore, providing real-time data synchronization.
- **User Authentication**: The app uses Firebase Authentication to manage user sign-in and registration.
- **CSV Import**: Users can import product data from a CSV file.

## Current Task: Remove `gap` package

### Plan

1.  **Replace `Gap` with `SizedBox`**: Go through all the files in the project and replace all instances of the `Gap` widget with the `SizedBox` widget.
2.  **Remove `gap` dependency**: Remove the `gap` package from the `pubspec.yaml` file.
3.  **Run `flutter pub get`**: Run `flutter pub get` to update the dependencies.
4.  **Fix any errors**: Fix any errors that may have occurred during the replacement process.
