# InvTrack

> **Inventory, without the friction.**

InvTrack is a warm-minimal asset and inventory management application designed for operational teams. Built with Flutter, Riverpod, GoRouter, and Drift (SQLite), InvTrack provides offline-first cataloging, barcode scanning, stock movement logging, and asset handovers across mobile, tablet, and desktop environments.

---

## Key Features

- **Inventory Pulse & Analytics**: Real-time stock valuation, catalog breakdown, velocity trends, and low-stock alerts.
- **Dedicated Scan Station**: Barcode and QR code scanning for fast check-in, check-out, and stock adjustments.
- **Asset Handover Management**: Human-centric asset assignment workflow tracking who has what, when, and for which project.
- **Offline-First Storage**: Powered by Drift SQLite, ensuring seamless operational continuity even without network connectivity.
- **Adaptive Responsive Design**: Tailored layouts for Mobile (bottom navigation), Tablet (navigation rail), and Desktop (sidebar with constrained canvas).
- **Warm Minimal Visual System**: Editorial design language with ivory backgrounds, espresso typography, terracotta accents, and Material 3 theming.

---

## Tech Stack

- **Framework**: Flutter 3.x / Dart 3.x
- **State Management**: Flutter Riverpod
- **Routing**: GoRouter (Declarative Shell Routing)
- **Local Database**: Drift (SQLite)
- **Design Tokens**: Material 3 + Custom Warm Minimal Tokens + Google Fonts (Lora & Plus Jakarta Sans) + Lucide Icons

---

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Chinmay2237/InvTrack.git
   cd InvTrack
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (if modifying database schema or models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch application:
   ```bash
   flutter run
   ```

---

## License

Private repository. All rights reserved.

