import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_state.dart';
import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';
import 'package:food_cafe/data/repository/home_repository/fetchmenu_repository.dart';


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

