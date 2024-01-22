import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:food_cafe/cubits/change_password_cubit/change_password_states.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newConfirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late OldpasswordVisibility oldpasswordVisibility;
  late PasswordVisibility passwordVisibility;
  late ConfirmPasswordVisibility confirmPasswordVisibility;
  late ChangePasswordCubit changePasswordCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldpasswordVisibility = BlocProvider.of<OldpasswordVisibility>(context);
    passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
    confirmPasswordVisibility =
        BlocProvider.of<ConfirmPasswordVisibility>(context);
    changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    oldpasswordVisibility.close();
    passwordVisibility.close();
    confirmPasswordVisibility.close();
    changePasswordCubit.close();
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Change Password",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Old Password",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                        theme: theme,
                        hintText: "Enter Old Password",
                        controller: _oldPasswordController,
                        prefixIcon: "lock",
                        onTap: () {
                          oldpasswordVisibility.toggleVisibility();
                        },
                        obscure: context.watch<OldpasswordVisibility>().state,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return knullpasserror;
                          } else if (value.length < 6) {
                            return kshortpass;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "New Password",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                        theme: theme,
                        hintText: "Enter New Password",
                        controller: _newPasswordController,
                        prefixIcon: "lock",
                        onTap: () {
                          passwordVisibility.toggleVisibility();
                        },
                        obscure: context.watch<PasswordVisibility>().state,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return knullpasserror;
                          } else if (value.length < 6) {
                            return kshortpass;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Confirm Password",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                          theme: theme,
                          hintText: "Confirm New Password",
                          controller: _newConfirmPasswordController,
                          prefixIcon: "lock",
                          onTap: () {
                            confirmPasswordVisibility.toggleVisibility();
                          },
                          obscure:
                              context.watch<ConfirmPasswordVisibility>().state,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return kconfpassnull;
                            }
                            if (value.trim() !=
                                _newPasswordController.text.trim()) {
                              return knopassmatch;
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
                  listener: (context, state) {
                    if (state is ChangePasswordLoadedState) {
                      Navigator.pushReplacementNamed(
                          context, Routes.changePasswordSuccessScreen);
                    } else if (state is ChangePasswordErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  builder: (context, state) {
                    if (state is ChangePasswordLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                        child: customButton(
                            context: context,
                            theme: theme,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                changePasswordCubit.initiatePasswordChange(
                                    oldPassword:
                                        _oldPasswordController.text.trim(),
                                    newPassword:
                                        _newPasswordController.text.trim());
                              }
                            },
                            title: "Change Password"));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
