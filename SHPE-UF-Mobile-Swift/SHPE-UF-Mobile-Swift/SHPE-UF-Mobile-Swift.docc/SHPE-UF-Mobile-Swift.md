# ``SHPE_UF_Mobile_Swift``

Catalog SHPE events, track attendance, and stay updated with the latest activities at the University of Florida.

@Metadata {
    @PageImage(
            purpose: icon, 
            source: "shpe_logo.svg")
    @PageColor(blue)
}

## Overview

SHPE UF Mobile App provides students with a way to explore and track SHPE events on campus. You can view event details, check event maps, and receive real-time notifications.

The app is designed to help users:
- Discover upcoming SHPE events
- View detailed event locations with MapsView
- Track personal event attendance through ProfileView



![The SHPE Icon.](shpe_logo.svg)

## Topics

### Data Management
- ``DataManager``: Handles data persistence and retrieval.
- ``CoreUserEvent``: Defines the core user data model.
- ``CoreFunctions``: Contains utility functions for data operations.

### Database
- ``MongoDB``: Manages the connection and queries to the database.

### Authentication
- ``SignInView``: Handles user sign-in logic.

---

## 🖼 SHPE App Views

### Profile
- ``ProfileView``: Manages user profiles and event history.

### Startup
- ``StartupView``: Initial app loading and welcome screen.

### Registration
- ``RegisterView``: Handles user registration.

### Sign-In
- ``SignInView``: Manages the sign-in page and authentication flow.

### Home
- ``HomeView``: Displays the main event feed and navigation hub.

### Points
- ``PointsView``: Tracks and displays points earned from attending events.

---

## 🛠 Helpers and Utilities

### UI Helpers
- ``ImageHelper``: Handles image processing and loading.
- ``TextFieldHelper``: Manages text field behaviors and validation.

### Camera Utilities
- ``QRCodeScanner``: Scans QR codes for event check-ins.

---

## 🧠 App Architecture

### App Core
- ``SHPE_UF_Mobile_SwiftApp``: Main entry point for the app.
- ``SHPEUFAppView``: Defines the overall app layout.
- ``SHPEUFAppViewModel``: Manages global app state and business logic.
