import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_cafe/core/routes/named_routes.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Function to request notification permission.
  ///
  /// This function uses the `messaging` object to request notification permissions
  /// with specific settings and logs messages based on the user's response.
  /// The results are logged using `dev.log` for development purposes.
  void requestNotificationPermission() async {
    try {
      // Request notification permissions using the messaging object
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      // Check the authorization status based on user's response
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // User granted permission, log the message
        dev.log("User Granted Permission");
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        // User granted provisional permission, log the message
        dev.log("User Granted Provisional Permission");
      } else {
        // User denied permission, log the message
        dev.log("User Denied Permission");
      }
    } catch (e) {
      // Handle any potential exceptions that may occur during the permission request
      dev.log("Error while requesting notification permission: $e");
    }
  }

  /// Initialize local notifications.
  ///
  /// This function initializes local notifications with the specified Android
  /// initialization settings and sets up a callback for when a notification
  /// response is received. It then calls the `handleMessage` function to process
  /// the received remote message.
  ///
  /// Parameters:
  /// - `context`: The build context for the widget tree.
  /// - `message`: The remote message received from push notifications.
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    // Specify Android initialization settings
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // Create InitializationSettings with Android settings
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
    );
// Initialize the FlutterLocalNotificationsPlugin with the specified settings
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // Callback function to handle the received notification response
      handleMessage(context, message);
    });
  }

  /// Initialize Firebase Cloud Messaging and handle incoming messages.
  ///
  /// This function sets up a listener for incoming FCM messages and logs various
  /// information from the received message. It also calls the `initLocalNotifications`
  /// function for Android devices to initialize local notifications and displays
  /// notifications using the `showNotification` function.
  ///
  /// Parameters:
  /// - `context`: The build context for the widget tree.
  void firebaseInit(BuildContext context) {
    // Set up a listener for incoming FCM messages
    FirebaseMessaging.onMessage.listen((message) {
      dev.log(message.notification!.title.toString());
      dev.log(message.notification!.body.toString());
      dev.log(message.data.toString());
      dev.log(message.data['message'].toString());
      dev.log(message.data['id'].toString());

      // Check if the platform is Android
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
      }

      // Show the notification
      showNotification(message);
    });
  }

  /// Show a notification based on the received FCM message.
  ///
  /// This function creates an AndroidNotificationChannel and AndroidNotificationDetails
  /// to configure the notification, then uses FlutterLocalNotificationsPlugin to display
  /// the notification with the specified title and body from the received FCM message.
  ///
  /// Parameters:
  /// - `message`: The FCM message containing notification information.
  Future<void> showNotification(RemoteMessage message) async {
    // Create an AndroidNotificationChannel for high importance notifications
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
        importance: Importance.max);

    // Create AndroidNotificationDetails with channel settings
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Your channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    // Create NotificationDetails with AndroidNotificationDetails
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Use Future.delayed(Duration.zero) to ensure the notification is shown in the next frame
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  /// Get the device token for push notifications.
  ///
  /// This asynchronous function retrieves the device token using the `getToken` method
  /// from FirebaseMessaging. It returns the obtained token as a String.
  ///
  /// Returns:
  /// - A Future<String> representing the device token for push notifications.
  Future<String> getDeviceToken() async {
    // Retrieve the device token using FirebaseMessaging
    String? token = await messaging.getToken();
// Ensure the token is not null before returning
    return token!;
  }

  /// Listen for token refresh events.
  ///
  /// This function sets up a listener for token refresh events using the
  /// `onTokenRefresh` stream from FirebaseMessaging. When a token refresh event
  /// occurs, it logs the event as a string.
  void isTokenRefresh({
    required String storeID,
  }) async {
    // Set up a listener for token refresh events
    messaging.onTokenRefresh.listen((newTokenID) async {
      // Log the token refresh event as a string
      dev.log('Token ID has been changed.');
      dev.log('The new Token ID is => ');
      dev.log(newTokenID);
      dev.log('Uploading this new Token ID to Firestore.');
      await _updateTokenInFireStore(storeID: storeID, newTokenID: newTokenID);
      dev.log('New Token ID has been successfully uploaded to Firestore.');
    });
  }

  Future<void> _updateTokenInFireStore(
      {required String storeID, required String newTokenID}) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('groceryStores').doc(storeID);

      await documentReference.update({'TokenID': newTokenID});
    } catch (e) {
      dev.log(
          "Exception occured while updating Token ID to Firestore (on Token Refresh) (Error from Notification Services)  => $e");
    }
  }

  /// Set up message handling for interactions with the app.
  ///
  /// This asynchronous function sets up message handling for scenarios where
  /// the app is terminated or in the background. It uses FirebaseMessaging to
  /// retrieve an initial message when the app is terminated and listens for
  /// message opening events when the app is in the background.
  ///
  /// Parameters:
  /// - `context`: The build context for the widget tree.
  Future<void> setupInteractMessage(BuildContext context) async {
    // Retrieve the initial message when the app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If there is an initial message, handle it using the handleMessage function
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // Set up a listener for message opening events when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  /// Handle incoming messages based on their content.
  ///
  /// This function takes a `context` and a `RemoteMessage` as parameters,
  /// checks the content of the message, and performs actions accordingly.
  ///
  /// Parameters:
  /// - `context`: The build context for the widget tree.
  /// - `message`: The received remote message containing data.
  void handleMessage(BuildContext context, RemoteMessage message) {
    // Check if the message data contains a specific content, e.g., 'Hello'
    if (message.data['message'] == 'Hello') {
      // If the message content is 'Hello', navigate to the notifications screen
      Navigator.pushNamed(context, Routes.notificationsScreen);
    }
  }
}
