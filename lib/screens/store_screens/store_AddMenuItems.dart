import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/store_additem_cubit/addImage_state.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_cubit.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/headings.dart';
import 'package:dotted_border/dotted_border.dart';

class store_AddItemsScreen extends StatefulWidget {
  const store_AddItemsScreen({Key? key}) : super(key: key);

  @override
  State<store_AddItemsScreen> createState() => _store_AddItemsScreenState();
}

class _store_AddItemsScreenState extends State<store_AddItemsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  File? imageFile;
  bool isAvailable = false;
  String selectedCategory = 'Appetizers';
  late String storeID;
  late String ID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAddMenuItems();
  }


  Future<void> initializeAddMenuItems() async{
    ID = context.read<LoginCubit>().getEntryNo();
    storeID = await context.read<LoginCubit>().getStoreID(ID);

  }

  @override
  Widget build(BuildContext context) {
    // Set a default category
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 82.h,
                  width: 233.w,
                  child: Text(
                    "Add your Menu Items!",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Menu Items will be added to store ",
                      style: theme.textTheme.bodySmall,
                    ),
                    FutureBuilder<String>(
                      future: context.read<LoginCubit>().getStoreID(ID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while fetching storeID
                          return Text('Loading...', style: theme.textTheme.bodySmall,);
                        } else if (snapshot.hasError) {
                          // Handle error if any
                          return Text("Error: ${snapshot.error}", style: theme.textTheme.bodySmall,);
                        } else {
                          // Display your content once storeID is fetched
                          return Text('${snapshot.data.toString()}.', style: theme.textTheme.bodySmall,);
                        }
                      },
                    ),
                  ],
                ),
                Text("The Item ID will be generated automatically relative to the previous Item ID.", style: theme.textTheme.bodySmall,),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subHeading(theme: theme, heading: "Item Name"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _itemnameController,
                        decoration: InputDecoration(
                          fillColor: theme.colorScheme.primary,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 0, color: theme.colorScheme.primary)),
                          hintText: "Enter Item Name",
                          hintStyle: theme.textTheme.bodyMedium,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 28.w, vertical: 22.h),
                        ),
                        style: theme.textTheme.bodyLarge,
                        cursorColor: theme.colorScheme.secondary,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subHeading(theme: theme, heading: "MRP"),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 160.w,
                                child: TextFormField(
                                  controller: _mrpController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: theme.colorScheme.primary,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            width: 0,
                                            color: theme.colorScheme.primary)),
                                    hintText: "Enter MRP",
                                    hintStyle: theme.textTheme.bodyMedium,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 28.w, vertical: 22.h),
                                  ),
                                  style: theme.textTheme.bodyLarge,
                                  cursorColor: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subHeading(theme: theme, heading: "Category"),
                              SizedBox(
                                height: 10,
                              ),
                              BlocProvider(
                                  create: (context) => CategoryCubit(),
                                  child: BlocBuilder<CategoryCubit, String>(
                                    builder: (context, state) {
                                      return Container(
                                        // height: 50,
                                        width: 160.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              theme.colorScheme.secondary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          value: state,
                                          onChanged: (String? newValue) {
                                            selectedCategory = newValue!;
                                            context
                                                .read<CategoryCubit>()
                                                .toggleCategory(newValue);
                                          },
                                          items: categories
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      subHeading(theme: theme, heading: "Availability"),
                      SizedBox(
                        height: 10,
                      ),
                      BlocProvider(
                        create: (context) => AvailableCubit(),
                        child: BlocBuilder<AvailableCubit, bool>(
                            builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              bool newvalue = state == true ? false : true;
                              context
                                  .read<AvailableCubit>()
                                  .toggleAvailibility(newvalue);
                              isAvailable = newvalue;

                              print("value of isAvailable $isAvailable");
                            },
                            child: Container(
                              width: 150.w,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                color: state == true
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Available",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Icon(
                                    Icons.check_box,
                                    color: state == true
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      subHeading(theme: theme, heading: "Add Image"),
                      SizedBox(
                        height: 10,
                      ),
                      BlocProvider(
                        create: (context) => AddImageCubit(),
                        child: BlocConsumer<AddImageCubit, AddImage>(
                          listener: (context, state) {
                            if (state is ImageErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)));
                            }
                          },
                          builder: (context, state) {
                            if (state is ImageLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (state is ImageLoadedState) {
                              imageFile = state.image;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 106.w,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.file(
                                      state.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state is ImageInitialState ||
                                state is ImageErrorState) {
                              return GestureDetector(
                                onTap: () =>
                                    context.read<AddImageCubit>().PickImage(),
                                child: DottedBorder(
                                  color: theme.colorScheme.secondary,
                                  strokeWidth: 3,
                                  dashPattern: <double>[3, 3],
                                  radius: Radius.circular(20),
                                  child: SizedBox(
                                    width: 106.w,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: theme.colorScheme.secondary,
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            "Image",
                                            style: theme.textTheme.labelLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Text("Waiting!");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                BlocConsumer<AddItemCubit, AddItemState>(
                    builder: (context, state) {
                  if (state is AddItemLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if (state is AddItemImageUploadedState) {
                    return Text("Image Uploaded!");
                  }
                  String itemName = _itemnameController.text;
                  String price = _mrpController.text;
                  return Center(
                      child: customButton(
                          context: context,
                          theme: theme,
                          onPressed: () => context
                              .read<AddItemCubit>()
                              .uploadItemtoFireStore(
                            storeID: storeID,
                            name: itemName,
                            category: selectedCategory,
                            mrp: int.parse(price),
                            isavailable: isAvailable,
                            imageFile: imageFile!,),
                          title: "Add Item"));
                }, listener: (context, state) {
                  if (state is AddItemImageUpload_ErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  } else if (state is AddItemErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  } else if (state is AddItemUploadedState) {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.store_ItemAdded, (route) => false);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> categories = [
  'Appetizer',
  'Main Courses',
  'Desserts',
  'Beverages'
];
