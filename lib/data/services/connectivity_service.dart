import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_cafe/widgets/custom_alert_dialog_box.dart';

Future<void> checkConnectivity(
    {required BuildContext context, required Function onConnected}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => CustomNoInternetAlertDialogBox(),
      );
    }
  } else {
    onConnected();
  }
}

Future<void> checkConnectivityForCubits(
    {required Function onDisconnected, required Function onConnected}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    onDisconnected();
  } else {
    onConnected();
  }
}
