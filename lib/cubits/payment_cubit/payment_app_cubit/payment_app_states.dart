import 'package:upi_india/upi_india.dart';

abstract class PaymentAppsState {
  List<UpiApp> upiApps;
  PaymentAppsState(this.upiApps);
}

class PaymentAppInitialState extends PaymentAppsState {
  PaymentAppInitialState() : super([]);
}

class PaymentAppLoadingState extends PaymentAppsState {
  PaymentAppLoadingState(super.upiApps);
}

class PaymentAppLoadedState extends PaymentAppsState {
  PaymentAppLoadedState(super.upiApps);
}

class PaymentAppErrorState extends PaymentAppsState {
  final String message;
  PaymentAppErrorState(super.upiApps, this.message);
}
