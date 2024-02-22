import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:food_cafe/widgets/custom_alert_dialog_box.dart';

/// Check device connectivity and perform actions based on the result.
///
/// This function checks the device's connectivity using the Connectivity plugin.
/// If there is no internet connection, it shows a custom alert dialog box.
///
/// Parameters:
/// - `context`: The build context for the widget tree.
/// - `onConnected`: The function to be executed when the device is connected to the internet.
Future<void> checkConnectivity(
    {required BuildContext context, required Function onConnected}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // If there is no internet connection, show a custom alert dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => const CustomNoInternetAlertDialogBox(),
      );
    }
  } else {
    // If there is an internet connection, execute the onConnected function
    onConnected();
  }
}

/// Check device connectivity for Cubits and trigger actions accordingly.
///
/// This function checks the device's connectivity using the Connectivity plugin.
/// It allows specifying different actions for connected and disconnected states.
///
/// Parameters:
/// - `onDisconnected`: The function to be executed when the device is not connected to the internet.
/// - `onConnected`: The function to be executed when the device is connected to the internet.
Future<void> checkConnectivityForCubits(
    {required Function onDisconnected, required Function onConnected}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // If there is no internet connection, execute the onDisconnected function
    onDisconnected();
  } else {
    // If there is an internet connection, execute the onConnected function
    onConnected();
  }
}
