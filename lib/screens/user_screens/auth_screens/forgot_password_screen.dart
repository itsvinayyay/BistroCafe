import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/forgotpassword_cubit/forgotpassword_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/forgotpassword_cubit/forgotpassword_states.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/headings.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late ForgotPasswordCubit forgotPasswordCubit;
  @override
  void initState() {
    
    super.initState();
    forgotPasswordCubit = BlocProvider.of<ForgotPasswordCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loginHeader(
                      context: context,
                      theme: theme,
                      title: "Forgot Password?",
                      subheading:
                          "Enter your email which is associated with your account."),
                  const SizedBox(
                    height: 20,
                  ),
                  customTextFormField(
                      theme: theme,
                      hintText: "Email",
                      controller: _emailController),
                ],
              ),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordStates>(
                listener: (context, state) {
                  if (state is ForgotPasswordLoadedState) {
                    Navigator.pushReplacementNamed(
                        context, Routes.forgotPasswordSuccessScreen);
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  return Center(
                    child: customButton(
                        context: context,
                        theme: theme,
                        onPressed: () async {
                          await checkConnectivity(
                              context: context,
                              onConnected: () {
                                forgotPasswordCubit.initiateForgotPassword(
                                    email: _emailController.text.trim());
                              });
                        },
                        title: "Next"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
