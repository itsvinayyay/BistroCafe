import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/store_additem_cubit/addImage_state.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_cubit.dart';
import 'package:food_cafe/cubits/store_modify_menuitem_cubit.dart/modify_menuitem_cubit.dart';
import 'package:food_cafe/cubits/store_modify_menuitem_cubit.dart/modify_menuitem_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/menuitem_modification_repository.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/headings.dart';

class ModifyMenuItemScreen extends StatefulWidget {
  store_MenuItemsCard_Model menuItemModel;
  ModifyMenuItemScreen({Key? key, required this.menuItemModel})
      : super(key: key);

  @override
  State<ModifyMenuItemScreen> createState() => _ModifyMenuItemScreenState();
}

class _ModifyMenuItemScreenState extends State<ModifyMenuItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _itemnameController;
  late TextEditingController _mrpController;
  bool isModified = false;
  late String selectedCategory;
  File? imageFile;
  late bool isAvailable;
  late String imageUrl;
  late String storeID;

  late Modify_MenuItemCubit modify_menuItemCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _itemnameController =
        TextEditingController(text: widget.menuItemModel.itemName);
    _mrpController =
        TextEditingController(text: widget.menuItemModel.mrp.toString());
    selectedCategory = widget.menuItemModel.category!;
    isAvailable = widget.menuItemModel.isavailable!;
    imageUrl = widget.menuItemModel.imageUrl!;

    modify_menuItemCubit = BlocProvider.of<Modify_MenuItemCubit>(context);
    final state = context.read<LoginCubit>().state;
    if (state is CafeLoginLoadedState) {
      storeID = state.storeID;
    } else {
      log("Some State Error Occured in Modify Menu Item Screen");

      storeID = "error";
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Modify your",
                  style: theme.textTheme.headlineLarge!
                      .copyWith(height: 1.25, fontSize: 25),
                ),
                Text(
                  "Menu Item",
                  style: theme.textTheme.labelLarge!
                      .copyWith(height: 1.25, fontSize: 35),
                ),
                Row(
                  children: [
                    Text(
                      "Menu Items will be modified for store SMVDU101.",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  "There will be no change for the ItemID.",
                  style: theme.textTheme.bodySmall,
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
                        "Item Name",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          isModified = true;
                        },
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
                              Text(
                                "MRP",
                                style: theme.textTheme.labelLarge!
                                    .copyWith(height: 1),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 160.w,
                                child: TextFormField(
                                  onChanged: (value) {
                                    isModified = true;
                                  },
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
                              Text(
                                "Category",
                                style: theme.textTheme.labelLarge!
                                    .copyWith(height: 1),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocProvider(
                                  create: (context) =>
                                      CategoryCubit(category: selectedCategory),
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
                                            isModified = true;
                                            context
                                                .read<CategoryCubit>()
                                                .toggleCategory(newValue!);
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
                      Text(
                        "Availibility",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BlocProvider(
                        create: (context) =>
                            AvailableCubit(availability: isAvailable),
                        child: BlocBuilder<AvailableCubit, bool>(
                            builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              isModified = true;
                              bool newvalue = state == true ? false : true;
                              context
                                  .read<AvailableCubit>()
                                  .toggleAvailibility(newvalue);
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
                      Text(
                        "Item Image",
                        style: theme.textTheme.labelLarge!.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: 5,
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
                            } else if (state is ImageInitialState ||
                                state is ImageErrorState) {
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 90.w,
                                      child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      isModified = true;
                                      context.read<AddImageCubit>().PickImage();
                                    },
                                    child: DottedBorder(
                                      color: theme.colorScheme.tertiary,
                                      strokeWidth: 2,
                                      dashPattern: <double>[3, 3],
                                      radius: Radius.circular(20),
                                      child: SizedBox(
                                        width: 60.w,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  color: theme
                                                      .colorScheme.tertiary,
                                                ),
                                                Text(
                                                  "Change Image",
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.labelLarge!
                                                      .copyWith(
                                                    fontSize: 12.w,
                                                    height: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is ImageLoadedState) {
                              imageFile = state.image;
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 90.w,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.file(
                                          state.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      isModified = true;
                                      context.read<AddImageCubit>().PickImage();
                                    },
                                    child: DottedBorder(
                                      color: theme.colorScheme.tertiary,
                                      strokeWidth: 2,
                                      dashPattern: <double>[3, 3],
                                      radius: Radius.circular(20),
                                      child: SizedBox(
                                        width: 60.w,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  color: theme
                                                      .colorScheme.tertiary,
                                                ),
                                                Text(
                                                  "Change Image",
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.labelLarge!
                                                      .copyWith(
                                                    fontSize: 12.w,
                                                    height: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Text("Waiting!");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      BlocConsumer<Modify_MenuItemCubit, ModifyMenuItemStates>(
                        listener: (context, state) {
                          if (state is ModifyMenuItemLoadedState) {
                            Navigator.pushReplacementNamed(
                                context, Routes.store_ItemAdded);
                          }
                        },
                        builder: (context, state) {
                          if (state is ModifyMenuItemLoadingState) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (state is ModifyMenuItemErrorState) {
                            return Center(
                              child: Text(state.error),
                            );
                          }
                          return Center(
                            child: customButton(
                                context: context,
                                theme: theme,
                                onPressed: () {
                                  if (isModified) {
                                    modify_menuItemCubit.uploadModifiedMenuItem(
                                        storeID: storeID,
                                        itemName:
                                            _itemnameController.text.trim(),
                                        category: selectedCategory,
                                        mrp: int.parse(
                                            _mrpController.text.trim()),
                                        isavailable: isAvailable,
                                        imageFile: imageFile,
                                        itemID: widget.menuItemModel.itemID!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Please Modify some Values!"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                title: "Modify"),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
