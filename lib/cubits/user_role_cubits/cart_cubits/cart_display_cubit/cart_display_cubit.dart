import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_states.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';
import 'package:food_cafe/data/repository/user_role_repositories/cart_repositories/cart_display_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state of the cart display.
class CartDisplayCubit extends Cubit<CartDisplay> {
  CartDisplayCubit() : super(CartItemInitialState());

  // Instance of [CartDisplayRepository] to retrieve cart items.
  final CartDisplayRepository _cartDisplayRepository = CartDisplayRepository();

  /// Initialize the cart display by fetching cart items.
  /// - [entryNo]: The unique identifier associated with the cart entry.
  Future<void> initialize(String entryNo) async {
    emit(CartItemLoadingState(state.cartList));
    try {
      // Check internet connectivity before fetching cart items.
      await checkConnectivityForCubits(
        onDisconnected: () {
          CartItemErrorState(state.cartList, 'internetError');
        },
        onConnected: () {
          // Start listening for cart items stream.
          _cartDisplayRepository.startListening(entryNo);

          _cartDisplayRepository.cartItemsStream
              .listen((List<CartModel> cartItems) {
            // Update state with loaded cart items.
            emit(CartItemLoadedState(cartItems));
          });
        },
      );
    } catch (e) {
      // Handle errors by updating state with an error message.
      emit(CartItemErrorState(state.cartList, e.toString()));
    }
  }

  @override
  Future<void> close() async {
    // Close the subscription to avoid memory leaks.
    _cartDisplayRepository.closeSubscription();
    return super.close();
  }
}
