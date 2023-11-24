abstract class BillingState{}


class BillLoadedState extends BillingState{
  int subTotal;
  int total;
  BillLoadedState(this.subTotal, this.total);
}

class DineOutLoadedState extends BillingState{
  int subTotal;
  int total;
  DineOutLoadedState(this.subTotal, this.total);
}

class LoadingState extends BillingState{}


abstract class BillingCheckoutState{}

class BillingCheckoutInitialState extends BillingCheckoutState{}

class BillingCheckoutLoadedState extends BillingCheckoutState{}

class BillingCheckoutLoadingState extends BillingCheckoutState{}

class BillingCheckoutErrorState extends BillingCheckoutState{
  final String error;

  BillingCheckoutErrorState(this.error);
}

