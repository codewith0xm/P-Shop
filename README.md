# Food Ordering App

A simple iOS food ordering application built with **Swift** using **MVVM architecture** and **Coordinator pattern**.

## Features
- Browse menu items with prices and images
- Add/remove items to cart
- Adjust item quantities
- Real-time cart total calculation
- Minimum order value enforcement
- Persistent cart storage

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture with **Coordinators**:

- **Models:** `MenuItem`, `CartItemModel`
- **ViewModels:** `MenuViewModel`, `CartViewModel`
- **Views:** `MenuViewController`, `CartViewController`
- **Coordinators:** `RootCoordinator`, `MenuCoordinator`, `CartCoordinator`

## Data Flow

- **Menu data** is loaded from a local JSON file via `MenuRepository`
- **Cart data** is persisted using `UserDefaults` via `CartRepository`
- **UI updates** are handled through completion blocks
