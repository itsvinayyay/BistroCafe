import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';

String checkLoginStateForUser(
    {required BuildContext context, required String screenName}) {
  final state = context.read<LoginCubit>().state;
  if (state is LoginLoggedInState) {
    return state.personID;
  } else {
    log("Some State Error Occured in $screenName");
    return 'error';
  }
}

MapEntry<String, String> checkLoginStateForCafeOwner(
    {required BuildContext context, required String screenName}) {
  final state = context.read<LoginCubit>().state;
  if (state is CafeLoginLoadedState) {
    String personID = state.personID;
    String storeID = state.storeID;
    return MapEntry(personID, storeID);
  } else {
    log("Some State Error Occured in $screenName");
    return const MapEntry('error', 'error');
  }
}
