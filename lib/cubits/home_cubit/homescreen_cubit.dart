

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_state.dart';
import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCardCubit extends Cubit<HomeCardState>{
  HomeCardCubit() : super(HomeCardLoadingState()){
    fetchHomeCard();
  }

  FetchFirebaseRepo fetchFirebaseRepo = FetchFirebaseRepo();

  void fetchHomeCard() async{
    try{
      List<Home_FoodCard> cards = await fetchFirebaseRepo.fetchHomePosts();
      emit(HomeCardLoadedState(cards));
    } catch(exception){
      emit(HomeCardErrorState(exception.toString()));
    }
  }
}

class FetchFirebaseRepo{


  Future<List<Home_FoodCard>> fetchHomePosts() async{
    try{
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collection("menuItems").doc("SMVDU101").collection("menuItems").get();


      final List<Home_FoodCard> menuItems = querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Home_FoodCard.fromJson(data);
      }).toList();

      return menuItems;

    } catch(exception){
      rethrow;
    }
  }
}