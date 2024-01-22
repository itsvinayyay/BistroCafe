import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/change_user_details_cubit/change_user_details_cubit.dart';
import 'package:food_cafe/cubits/change_user_details_cubit/change_user_details_states.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class ChangeUserDetailsScreen extends StatefulWidget {
  const ChangeUserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ChangeUserDetailsScreen> createState() =>
      _ChangeUserDetailsScreenState();
}

class _ChangeUserDetailsScreenState extends State<ChangeUserDetailsScreen> {
  late ChangeUserDetailsCubit changeUserDetailsCubit;
  TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isModified = false;

  late String personID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeUserDetailsCubit = BlocProvider.of<ChangeUserDetailsCubit>(context);
    final state = context.read<LoginCubit>().state;
    if (state is CafeLoginLoadedState) {
      personID = state.personID;
    } else {
      log("Some State Error Occured in Change User Details Screen");
      personID = "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Change Details",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customTextFormField(
                        theme: theme,
                        hintText: "Name",
                        controller: _nameController,
                        prefixIcon: "profile",
                        onChanged: (value) => isModified = true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return kNameNull;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      BlocConsumer<ChangeUserDetailsCubit,
                          ChangeUserDetailsStates>(listener: (context, state) {
                        if (state is UserDetailsLoadedState) {
                          Navigator.pushReplacementNamed(
                              context, Routes.changeUserDetailsSuccessScreen);
                        }
                        if (state is UserDetailsErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)));
                        }
                      }, builder: (context, state) {
                        if (state is UserDetailsLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.tertiary,
                            ),
                          );
                        }
                        return customButton(
                            context: context,
                            theme: theme,
                            onPressed: () {
                              if (isModified) {
                                if (_formKey.currentState!.validate()) {
                                  changeUserDetailsCubit.initiateChange(
                                      name: _nameController.text.trim(),
                                      personID: personID);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Please Modify the Details")));
                              }
                            },
                            title: "Change");
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
