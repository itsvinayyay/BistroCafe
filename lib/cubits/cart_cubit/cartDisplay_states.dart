import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';

abstract class CartDisplay {
  List<Cart_FoodCard_Model> cartList;
  CartDisplay(this.cartList);
}

class CartItemInitialState extends CartDisplay {
  CartItemInitialState() : super([]);
}

class CartItemLoadingState extends CartDisplay {
  CartItemLoadingState(super.cartList);
}

class CartItemLoadedState extends CartDisplay {
  CartItemLoadedState(super.cartList);
}

class CartItemErrorState extends CartDisplay {
  final String message;
  CartItemErrorState(super.cartList, this.message);
}
