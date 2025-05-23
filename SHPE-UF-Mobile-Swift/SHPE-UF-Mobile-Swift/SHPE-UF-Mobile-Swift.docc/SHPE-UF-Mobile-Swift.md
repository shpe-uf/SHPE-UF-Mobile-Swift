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
- Track personal event attendance through PointsView
- and more

### Featured

@Links(visualStyle: detailedGrid) {
    - <doc:GettingStarted>
    - <doc:LearningSwiftUI>
}


![The SHPE Icon.](shpe_logo.svg)

---

## Essentials
---
- <doc:GettingStarted>
- <doc:LearningSwiftUI>
- <doc:AdvancedSwiftUI>
- <doc:SettingUpXcode>
---

## SHPE APP Views
---

### Profile View

- ``ProfileView``
- ``ProfileViewModel``
- ``VisualEffectBlur``
- ``CurvedTopRectangle``
- ``ValidationFunction``
- ``DropDown``
- ``MultipleLabels``
- ``ImagePicker``
- ``Loading``

### Start Up View
- ``CheckCore``
- ``CheckCoreViewModel``

### Register View
- ``RegisterView``
- ``LandingPageView``
- ``PersonalView``
- ``AcademicView``
- ``RegisterViewModel``

### Sign In View
- ``SignInView``
- ``CustomTextFieldStyle``
- ``ToastView``
- ``SignInViewModel``

### Map View
- ``Destination``
- ``MapManager``
- ``LocationDetailView``
- ``LocationManager``
- ``MTPlacemark``
- ``LocationView``
- ``LocationViewPopUp``

### Notification View

- ``NotificationView``
- ``NotificationViewModel``

### Event View
- ``HomeView``
- ``HomeViewModel``
- ``HomePageContentView``
- ``EventBox``
- ``EventNoTimeView``
- ``EventWithTimeView``
- ``EventInfoView``
- ``HomePageContentView``
- ``Constants``
- ``DateHelper``

### Points View
- ``PointsView``
- ``PointsViewModel``
- ``PointsViewDark``
- ``PointsUI``
- ``RedeemView``
- ``RedeemPointsButton``
- ``CircularProgessView``
- ``CircularProgessViewDark``
- ``TableView``
- ``SingleEventView``


### QR Code View
- ``QRCodeScannerView``
- ``ZoomSlider``

---

## Data Management

---

### Core Data
- ``User``
- ``DataManager``
- ``CoreFunctions``
- ``CoreUserEvent``
- ``CalendarEvent``

### Data Models
- ``Event``
- ``Creator``
- ``EventDateTime``
- ``Organizer``
- ``SHPEito``
- ``UserEvent``

### SHPE Schema
- ``SHPESchema``
- ``SHPESchema_SelectionSet``
- ``SHPESchema_InlineFragment``
- ``SHPESchema_MutableSelectionSet``
- ``SHPESchema_MutableInlineFragment``

### Application Structure
- ``SHPEUFAppView``
- ``AppViewModel``
- ``SHPE_UF_Mobile_SwiftApp``

### GraphQL
- ``RequestHandler``
