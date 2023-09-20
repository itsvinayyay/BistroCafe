import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';

class CartDisplayCubit extends Cubit<List<Cart_FoodCard_Model>> {
  CartDisplayCubit() : super([]);

  final _fireStore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;


  // int totalMRP = 0;


  void startListening(String userID) {
    print(userID);
    final collectionRef = _fireStore.collection('Users').doc('SMVDU$userID').collection(
        'cartitem');

    _subscription = collectionRef.snapshots().listen((snapshot) {
      final CartItems = snapshot.docs.map((docs) =>
          Cart_FoodCard_Model.fromJson(docs.data())).toList();
      emit(CartItems);
    });


  }

  // void calculateTotal(){
  //   final itemList = state;
  //   int total = 0;
  //   for(var cartItem in itemList){
  //     total+= cartItem.mrp! * cartItem.quantity!;
  //   }
  //
  //   totalMRP = total;
  // }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}