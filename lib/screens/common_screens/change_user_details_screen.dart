import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/change_user_details_cubit/change_user_details_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/change_user_details_cubit/change_user_details_states.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class ChangeUserDetailsScreen extends StatefulWidget {
  final bool isCafeOwner;
  const ChangeUserDetailsScreen({super.key, required this.isCafeOwner});

  @override
  State<ChangeUserDetailsScreen> createState() =>
      _ChangeUserDetailsScreenState();
}

class _ChangeUserDetailsScreenState extends State<ChangeUserDetailsScreen> {
  late ChangeUserDetailsCubit _changeUserDetailsCubit;
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isModified = false;

  late String personID;

  @override
  void initState() {
    super.initState();
    _changeUserDetailsCubit = BlocProvider.of<ChangeUserDetailsCubit>(context);
    final state = context.read<LoginCubit>().state;
    if (state is LoginLoggedInState) {
      personID = state.personID;
    } else if (state is CafeLoginLoadedState) {
      personID = state.personID;
    } else {
      log("Some State Error Occured in Change User Details Screen");
      personID = "error";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _changeUserDetailsCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                const SizedBox(
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
                          } else if (value.length > 15) {
                            return kNameLong;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
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
                            onPressed: () async {
                              if (isModified) {
                                if (_formKey.currentState!.validate()) {
                                  await checkConnectivity(
                                      context: context,
                                      onConnected: () {
                                        _changeUserDetailsCubit.initiateChange(
                                            name: _nameController.text.trim(),
                                            personID: personID,
                                            isCafeOwner: widget.isCafeOwner);
                                      });
                                }
                              } else {
                                showSnackBar(
                                    context: context,
                                    error: 'Please Modify the Name');
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
