abstract class BillingCheckoutState{}

class BillingCheckoutInitialState extends BillingCheckoutState{}

class BillingCheckoutLoadedState extends BillingCheckoutState{}

class BillingCheckoutLoadingState extends BillingCheckoutState{}

class BillingCheckoutErrorState extends BillingCheckoutState{
  final String error;

  BillingCheckoutErrorState(this.error);
}