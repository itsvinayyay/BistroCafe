import 'package:food_cafe/data/models/user_cart_model.dart';

/// Abstract class representing the state of the cart display.
abstract class CartDisplay {
  /// List of cart items.
  List<CartModel> cartList;

  // Constructor for initializing the cart display state with a list of cart items.
  CartDisplay(this.cartList);
}

/// Initial state of the cart display with an empty list of cart items.
class CartItemInitialState extends CartDisplay {
  // Constructs the initial state with an empty list.
  CartItemInitialState() : super([]);
}

/// Loading state of the cart display indicating that cart items are being fetched.
class CartItemLoadingState extends CartDisplay {
  // Constructs the loading state with the current list of cart items.
  CartItemLoadingState(super.cartList);
}

/// Loaded state of the cart display containing the fetched list of cart items.
class CartItemLoadedState extends CartDisplay {
  // Constructs the loaded state with the current list of cart items.
  CartItemLoadedState(super.cartList);
}

/// Error state of the cart display with a specific error message.
class CartItemErrorState extends CartDisplay {
  /// Error message associated with the error state.
  final String message;

  // Constructs the error state with the current list of cart items and an error message.
  CartItemErrorState(super.cartList, this.message);
}
