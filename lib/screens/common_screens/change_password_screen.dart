import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/change_password_cubit/change_password_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/change_password_cubit/change_password_states.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newConfirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late OldpasswordVisibility _oldpasswordVisibility;
  late PasswordVisibility _passwordVisibility;
  late ConfirmPasswordVisibility _confirmPasswordVisibility;
  late ChangePasswordCubit _changePasswordCubit;

  void _initializeCubits() {
    _oldpasswordVisibility = BlocProvider.of<OldpasswordVisibility>(context);
    _passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
    _confirmPasswordVisibility =
        BlocProvider.of<ConfirmPasswordVisibility>(context);
    _changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(context);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _oldpasswordVisibility.close();
    _passwordVisibility.close();
    _confirmPasswordVisibility.close();
    _changePasswordCubit.close();
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
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Change Password",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(
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
                      const SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                        theme: theme,
                        hintText: "Enter Old Password",
                        controller: _oldPasswordController,
                        prefixIcon: "lock",
                        onTap: () {
                          _oldpasswordVisibility.toggleVisibility();
                        },
                        obscure: context.watch<OldpasswordVisibility>().state,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return kNullPasswordError;
                          } else if (value.length < 6) {
                            return kShortPasswordError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "New Password",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                        theme: theme,
                        hintText: "Enter New Password",
                        controller: _newPasswordController,
                        prefixIcon: "lock",
                        onTap: () {
                          _passwordVisibility.toggleVisibility();
                        },
                        obscure: context.watch<PasswordVisibility>().state,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return kNullPasswordError;
                          } else if (value.length < 6) {
                            return kShortPasswordError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Confirm Password",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      customTextFormField(
                          theme: theme,
                          hintText: "Confirm New Password",
                          controller: _newConfirmPasswordController,
                          prefixIcon: "lock",
                          onTap: () {
                            _confirmPasswordVisibility.toggleVisibility();
                          },
                          obscure:
                              context.watch<ConfirmPasswordVisibility>().state,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return kConfPasswordError;
                            }
                            if (value.trim() !=
                                _newPasswordController.text.trim()) {
                              return kNoPasswordMatchError;
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                const SizedBox(
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                        child: customButton(
                            context: context,
                            theme: theme,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await checkConnectivity(
                                    context: context,
                                    onConnected: () {
                                      _changePasswordCubit
                                          .initiatePasswordChange(
                                              oldPassword:
                                                  _oldPasswordController.text
                                                      .trim(),
                                              newPassword:
                                                  _newPasswordController.text
                                                      .trim());
                                    });
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
