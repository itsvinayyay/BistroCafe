import 'package:flutter_bloc/flutter_bloc.dart';


class OrdersTabCubit extends Cubit<int> {
  OrdersTabCubit() : super(0);

  void toggleTab(int tabNumber) {
    emit(tabNumber);
  }
}

