import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/user_role_cubits/deactivate_account_cubit/deactivate_account_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/deactivate_account_cubit/deactivate_account_state.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class DeactivateAccountScreen extends StatefulWidget {
  const DeactivateAccountScreen({super.key});

  @override
  State<DeactivateAccountScreen> createState() =>
      _DeactivateAccountScreenState();
}

class _DeactivateAccountScreenState extends State<DeactivateAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();
  late DeactivateAccountCubit deactivateAccountCubit;
  late PasswordVisibility passwordVisibility;

  @override
  void initState() {
    super.initState();
    deactivateAccountCubit = BlocProvider.of<DeactivateAccountCubit>(context);
    passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
  }

  @override
  void dispose() {
    super.dispose();
    deactivateAccountCubit.close();
    passwordVisibility.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
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
                  "Deactivate Account",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: theme.textTheme.labelLarge!.copyWith(height: 1),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    customTextFormField(
                      theme: theme,
                      hintText: "Enter Password",
                      controller: _passwordController,
                      prefixIcon: "lock",
                      onTap: () {
                        passwordVisibility.toggleVisibility();
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
                  ],
                )),
                const SizedBox(
                  height: 50,
                ),
                BlocConsumer<DeactivateAccountCubit, DeactivateAccountStates>(
                    listener: (context, state) {
                  if (state is DeactivateAccountLoadedState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.signIn, (route) => false);
                  } else if (state is DeactivateAccountErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                }, builder: (context, state) {
                  if (state is DeactivateAccountLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.tertiary,
                      ),
                    );
                  }
                  return Center(
                    child: customButton(
                        context: context,
                        theme: theme,
                        onPressed: () {
                          deactivateAccountCubit.initiateDeactivation(
                              password: _passwordController.text.trim());
                        },
                        title: "Deactivate"),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
