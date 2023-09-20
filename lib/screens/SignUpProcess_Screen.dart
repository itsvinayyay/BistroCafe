import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/layouts/Subsequent_Layout.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/headings.dart';

class SignUpProcess extends StatefulWidget {
  const SignUpProcess({Key? key}) : super(key: key);

  @override
  State<SignUpProcess> createState() => _SignUpProcessState();
}

class _SignUpProcessState extends State<SignUpProcess> {
  String? rollNo;

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  // String getrollNo(){
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if(currentUser!=null){
  //     String email = currentUser.email!;
  //     String rollNo = "";
  //     for(int i=0; i<8; i++){
  //       rollNo = rollNo + email[i];
  //     }
  //     rollNo.toLowerCase();
  //     return rollNo;
  //   } else{
  //     return "error getting RollNo.";
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }




  @override
  Widget build(BuildContext context) {
    rollNo = ModalRoute.of(context)!.settings.arguments as String;
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loginHeader(context: context, theme: theme, title: "Fill in your bio to get started", subheading: "This data will be displayed in your account profile for security"),
                
                SizedBox(
                  height: 20.h,
                ),
                customTextFormField(
                    theme: theme,
                    hintText: "First Name",
                    controller: _firstnameController),
                SizedBox(
                  height: 20.h,
                ),
                customTextFormField(
                    theme: theme,
                    hintText: "Last Name",
                    controller: _lastnameController),
                SizedBox(
                  height: 20.h,
                ),
                // customTextFormField(
                //     theme: theme,
                //     hintText: "Mobile Number",
                //     controller: _mobileController),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 60.h,
                  width: MediaQuery.of(context).size.width,
                  child: Text(rollNo!, style: theme.textTheme.bodyLarge,),

                ),
                SizedBox(height: 150.h,),
                Center(
                  child: customButton(
                      context: context,
                      theme: theme,
                      onPressed: (){},
                      title: "Next"),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
