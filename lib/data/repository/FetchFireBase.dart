import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFirebaseRepo{


  Future<List<Home_FoodCard>> fetchHomePosts() async{
    try{
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collection("groceryStores").doc("SMVDU101").collection("menuItems").get();


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