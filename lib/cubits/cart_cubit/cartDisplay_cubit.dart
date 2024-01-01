import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cart_cubit/cartDisplay_states.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';
import 'package:food_cafe/data/repository/cartscreen_repository/fetchcart_repository.dart';

// class CartDisplayCubit extends Cubit<List<Cart_FoodCard_Model>> {
//   CartDisplayCubit() : super([]);

//   final _fireStore = FirebaseFirestore.instance;
//   StreamSubscription<QuerySnapshot>? _subscription;

//   // int totalMRP = 0;

//   void startListening(String userID) {

//     final collectionRef = _fireStore.collection('Users').doc('SMVDU$userID').collection(
//         'cartitem');

//     _subscription = collectionRef.snapshots().listen((snapshot) {
//       final CartItems = snapshot.docs.map((docs) =>
//           Cart_FoodCard_Model.fromJson(docs.data())).toList();
//       emit(CartItems);
//     });

//   }

//   // void calculateTotal(){
//   //   final itemList = state;
//   //   int total = 0;
//   //   for(var cartItem in itemList){
//   //     total+= cartItem.mrp! * cartItem.quantity!;
//   //   }
//   //
//   //   totalMRP = total;
//   // }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }
// }

class CartDisplayCubit extends Cubit<CartDisplay> {
  CartDisplayCubit() : super(CartItemInitialState());

  FetchCartItems _fetchCartItems = FetchCartItems();

  void initialize(String entryNo) {
    emit(CartItemLoadingState(state.cartList));
    try {
      _fetchCartItems.startListening(entryNo);

      _fetchCartItems.cartItemsStream.listen((List<Cart_FoodCard_Model> cartItems) {
        emit(CartItemLoadedState(cartItems));
      });
    } catch (e) {
      emit(CartItemErrorState(state.cartList, e.toString()));
    }
  }

  @override
  Future<void> close() async {
    _fetchCartItems.closeSubscription();
    return super.close();
  }
}

