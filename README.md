
# Bistro Cafe

BistroCafe is a versatile and user-friendly mobile application designed to streamline the cafe experience for both customers and cafe owners. With distinct roles for users and cafe owners, BistroCafe aims to enhance the order management process and provide a seamless interaction platform.

<div style="display: flex; gap:40px; justify-content: center;">
<img src="https://drive.google.com/uc?export=view&id=125Inl2xe7LAhM4cel3RPKnRv-Uh5PA7s"  width="200"/>

<img src="https://drive.google.com/uc?export=view&id=18O5SUw9hgG4O0cTuaiI3cmzlodIM2iyF"  width="200"/>

<img src="https://drive.google.com/uc?export=view&id=1WY416kXPujVbjPtFk2h5uYXA7MTUy_6H"  width="200"/>


</div>



## Badges

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

![Static Badge](https://img.shields.io/badge/BistroCafe-Version_1.0.0-blue)

![Static Badge](https://img.shields.io/badge/Pull_Requests-Welcome-blue)

![Static Badge](https://img.shields.io/badge/Release_Date-February_20,_2024-blue)





## Key Features [Non Technical]

### Overall App Features
These features will be **included in both User and Cafe Owner Roles.**
* **Themes**
    * Dark Mode
    * Light Mode

* **Profile Management**
    * Change Information
    * Change Password

* **General Settings**
    * About Us [Option]
    * Privacy [Option]
    * Bug Reporting [Option]
    * Credits [Option]

### Specific **User Role** Features
These features will only be **included in User Role.**
* **Menu Item Display**
    * Whole Menu Display
    * Category wise Menu Display
* Cart Screen with Item quantity Increase and Decrease
* Dine In and Dine Out Feature
* Cash on Delivery and Onlne Mode of Payment Feature
* **Order Tracking with**
    * Order History
    * Curated Notifications on Order update
* Deactivate Account

### Specific **Cafe Owner Role** Features
These features will only be **included in Cafe Owner Role.**

* **4 stages of Order Management**
    * Requested Orders
    * Unpaid Orders
    * Current Orders
    * Past Orders
    
* Notifications regarding new Orders

* **Analytics**
    * Daily Analytics
    * Monthly Analytics
    * Product Monthly Analytics

* **Menu Items**
    * Add New Menu Item
    * View Available Menu Items
    * Update Menu Item availibility [on the go].
    * Modify Details of Menu Items

* **Cafe Management**
    * Store Timings
    * Store availibility



## Technical Key Features

* **Security**
    * Email Verification (For both Cafe Owner and User Role).
    * Allows only Authenticated Emails to use the application.

* **State Persistence**
    * Includes Authentication State Persistence.
    * Includes various states for persistence to route the user to the same screen, left before at the time of verification.

* **Cart Local State** [For User Role]
    * Maintains a Cart Local state (HashMap) to store Item IDs and their respective quantities.
    * This is done to minimise reads and writes and also to provide better User experience while increasing and decresing an item's quantity.

* **Billing Checkout checks**
    * Checks if the timing is in Business hour range set by the store owner.
    * Checks the availibity of the store.

* **Messaging Functionality**
    * Notifies the user about his/her order on at evry stage.
    * Also notifies the Cafe Owner about the new requested order.
    * Uses Dio (https client) to send API request to the Firebase Cloud Messaging server.





## Technology Overview
### Tech Stacks Used
* Flutter
* **Firebase**
    * Firebase Authentication
    * Firestore
    * Cloud Storage
    * Firebase Cloud Messaging

### Flutter State management Used
* Bloc (Business Logic Component) - Cubits Extension

### HTTPS CLient Used
* Dio

### Flutter Project Dependencies

- **cupertino_icons: ^1.0.2**
  - Flutter's built-in Cupertino icons. Provides iOS-style icons for your app.

- **flutter_bloc: ^8.1.3**
  - Implements the BLoC (Business Logic Component) pattern for state management in Flutter.

- **flutter_screenutil: ^5.8.4**
  - A Flutter plugin for adapting screen and font size to different devices.

- **flutter_svg: ^2.0.7**
  - Allows rendering SVG files as Flutter widgets.

- **google_nav_bar: ^5.0.6**
  - A customizable bottom navigation bar with a Google Material Design style.

- **firebase_auth: ^4.7.3**
  - Flutter plugin for Firebase Authentication. Handles user sign-in and sign-up.

- **firebase_core: ^2.15.1**
  - Flutter plugin for Firebase Core. Initializes Firebase for your Flutter app.

- **cloud_firestore: ^4.15.4**
  - Flutter plugin for Cloud Firestore. Enables communication with Firebase Firestore.

- **dotted_border: ^2.0.0+3**
  - A Flutter package to create dotted borders around widgets.

- **image_picker: ^1.0.4**
  - Allows picking images from the image library or taking new pictures with the camera.

- **firebase_storage: ^11.2.6**
  - Flutter plugin for Firebase Cloud Storage. Handles storage and retrieval of files.

- **intl: ^0.19.0**
  - Flutter package for internationalization and localization.

- **firebase_messaging: ^14.7.15**
  - Flutter plugin for Firebase Cloud Messaging. Handles push notifications.

- **flutter_local_notifications: ^16.3.2**
  - A Flutter plugin to display local notifications.

- **app_settings: ^5.1.1**
  - A Flutter package to open the device settings for the app.

- **shared_preferences: ^2.2.1**
  - Flutter plugin for reading and writing simple key-value pairs to persistent storage.

- **email_validator: ^2.1.17**
  - A Dart package for validating email addresses.

- **dio: ^5.4.0**
  - A powerful Dart HTTP client for making RESTful API calls.

- **pretty_dio_logger: ^1.3.1**
  - A Dio interceptor for logging HTTP requests and responses in a readable format.

- **cached_network_image: ^3.3.1**
  - Flutter package for caching and displaying network images.

- **connectivity_plus: ^5.0.2**
  - Flutter plugin for monitoring and accessing network connectivity.


## Software Engineering Techniques Used

### Design Patterns
* Repository Pattern
* Observer Pattern
* Dependency Injection or Service Locator Pattern

### Architecture Used
* Clean Architechture
    * Seperated Repositories, Cubits and Presentation.
    * Repository for direct communication for a particular functionality with database.
    * Cubits to manage the Presentation layer with the data layer.
    * Presentation contains all the frontend of the application.




## Installation

Install my-project with npm

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) version greater than 3.7.7 is preferred.
- [fvm](https://fvm.app/) tool to manage Flutter versions.

### Steps
1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/your-repo.git
   ```
2. **Navigate to the Project Directory**
```bash
cd your-repo
```
3. **Install Flutter Dependencies**
```bash
fvm install
fvm use
```
4. **Install Project Dependencies**
```bash
flutter pub get
```

5. **Configure Firebase**
If you're using Firebase for Android, make sure to include the google-services.json file in the android/app folder.

6. **Run the Application**
Run the Flutter Application
```bash
flutter run

```

**Note**
Ensure that all the dependencies mentioned in the pubspec.yaml file are correctly installed.

    
## Usage Guide

### User Role
1. Browse through the available items and select the ones you want to order.
2. Add the selected items to your cart by tapping on them.
3. Proceed to the "Cart" section to review your order.
4. If satisfied, click on the "Proceed" button.
6. Choose the necessary details such as Dine-in or Dine-out options or COD or Online Payments.
7. Place the order to complete the process.


### Cafe Owner Role
#### Managing Orders
1. Access the "Your Orders" section in the side drawer of the application.
2. View the list of incoming/requested orders.
3. Process each order by updating its status (requested, unpaid, current, prepared).
4. Use the app's features to mark orders as paid or completed.

#### Add New Menu items
1. Navigate to the "Add Menu Items" section in the side drawer of the application.
2. Add new items to the menu.
3. Specify details such as item name, category, price, etc.
4. Save the changes to to upload the new menu item.

#### Viewing Sales Analytics

1. Access the "Analytics" section in Home Screen.
2. Review sales data, including popular items and revenue.
3. Use the insights to make informed business decisions.
## Useful Links

## Conclusion

Thank you for exploring my application! I hope you find it intuitive and helpful in solving real-life problems for both users and cafe owners. Your feedback and contributions are incredibly valuable to me.

If you encounter any issues, have suggestions for improvement, or want to contribute to the project, feel free to open an issue) or create a pull request. I appreciate your support in making this project better.

If you find this project helpful, consider giving it a star on GitHub or [becoming a sponsor](https://github.com/sponsors/itsvinayyay). Your support encourages me to continue enhancing and maintaining the application.

I would like to express my gratitude to the contributors, library maintainers, and the open-source community for their continuous support. Together, we can make a positive impact.

Happy coding!

@itsvinayyay

