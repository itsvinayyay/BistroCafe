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