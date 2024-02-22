import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_states.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_modify_menuitem_cubit.dart/modify_menuitem_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_modify_menuitem_cubit.dart/modify_menuitem_state.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';

import 'package:food_cafe/data/models/store_menu_item_model.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/add_menu_item_screens/store_add_menu_item_screen.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';
import 'package:food_cafe/widgets/headings.dart';
import 'package:food_cafe/widgets/store_pick_image_button.dart';
import 'package:food_cafe/widgets/store_picked_image_preview.dart';

class ModifyMenuItemScreen extends StatefulWidget {
  final StoreMenuItemModel menuItemModel;
  const ModifyMenuItemScreen({super.key, required this.menuItemModel});

  @override
  State<ModifyMenuItemScreen> createState() => _ModifyMenuItemScreenState();
}

class _ModifyMenuItemScreenState extends State<ModifyMenuItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _itemnameController;
  late TextEditingController _mrpController;
  bool isModified = false;

  File? imageFile;

  late String imageUrl;
  late String storeID;

  late AddImageCubit _addImageCubit;
  late CategoryCubit _categoryCubit;
  late AvailableCubit _availableCubit;
  late ModifyMenuItemCubit _modify_menuItemCubit;

  void _initializeCubits() {
    _modify_menuItemCubit = BlocProvider.of<ModifyMenuItemCubit>(context);
    _addImageCubit = BlocProvider.of<AddImageCubit>(context);
    _categoryCubit = BlocProvider.of<CategoryCubit>(context);
    _availableCubit = BlocProvider.of<AvailableCubit>(context);
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Modify Menu Item Screen')
        .value;
  }

  void _initializeElements() {
    _itemnameController =
        TextEditingController(text: widget.menuItemModel.itemName);
    _mrpController =
        TextEditingController(text: widget.menuItemModel.mrp.toString());
    imageUrl = widget.menuItemModel.imageUrl!;
  }

  @override
  void initState() {
    super.initState();
    _initializeElements();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _availableCubit.close();
    _categoryCubit.close();
    _addImageCubit.close();
    _modify_menuItemCubit.close();
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
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Modify Menu Item",
                  style: theme.textTheme.titleLarge,
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
                  style: theme.textTheme.bodySmall!.copyWith(height: 1.25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      storeSubHeading(theme: theme, heading: 'Item Name'),
                      const SizedBox(
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return kMenuItemNameNullError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              storeSubHeading(theme: theme, heading: 'MRP'),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 160.w,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return kMenuItemMRPNullError;
                                    }
                                    return null;
                                  },
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
                              storeSubHeading(
                                  theme: theme, heading: 'Category'),
                              const SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<CategoryCubit, String>(
                                builder: (context, state) {
                                  return Container(
                                    // height: 50,
                                    width: 160.w,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18.w, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: DropdownButton<String>(
                                      dropdownColor:
                                          theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(20),
                                      value: state,
                                      onChanged: (String? newValue) {
                                        isModified = true;
                                        _categoryCubit
                                            .toggleCategory(newValue!);
                                      },
                                      items: categories
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      storeSubHeading(theme: theme, heading: 'Availibility'),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<AvailableCubit, bool>(
                          builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            isModified = true;
                            bool newvalue = state == true ? false : true;
                            _availableCubit.toggleAvailibility(newvalue);
                          },
                          child: Container(
                            width: 150.w,
                            padding: const EdgeInsets.symmetric(
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
                      const SizedBox(
                        height: 20,
                      ),
                      storeSubHeading(theme: theme, heading: 'Item Image'),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocConsumer<AddImageCubit, AddImage>(
                        listener: (context, state) {
                          if (state is ImageErrorState) {
                            showSnackBar(
                                context: context, error: state.error);
                          }
                        },
                        builder: (context, state) {
                          if (state is ImageLoadingState) {
                            return const CircularProgressIndicator();
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
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: imageUrl,
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 85.h,
                                          margin: const EdgeInsets.only(
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Icon(Icons.error),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  downloadProgress.progress,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                storePickImageButton(
                                    onTap: () {
                                      isModified = true;
                                      _addImageCubit.pickImage();
                                    },
                                    theme: theme,
                                    toChangeImage: true),
                              ],
                            );
                          } else if (state is ImageLoadedState) {
                            imageFile = state.image;
                            return Row(
                              children: [
                                storePickedImageView(
                                    pickedImage: state.image),
                                const SizedBox(
                                  width: 10,
                                ),
                                storePickImageButton(
                                    onTap: () {
                                      isModified = true;
                                      _addImageCubit.pickImage();
                                    },
                                    theme: theme,
                                    toChangeImage: true),
                              ],
                            );
                          }
                          return const Text("Waiting!");
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      BlocConsumer<ModifyMenuItemCubit, ModifyMenuItemStates>(
                        listener: (context, state) {
                          if (state is ModifyMenuItemLoadedState) {
                            Navigator.pushReplacementNamed(
                                context, Routes.store_ItemAdded);
                          }
                        },
                        builder: (context, state) {
                          if (state is ModifyMenuItemLoadingState) {
                            return const CustomCircularProgress();
                          } else if (state is ModifyMenuItemErrorState) {
                            return Center(
                              child: Text(state.error),
                            );
                          }
                          return Center(
                            child: customButton(
                                context: context,
                                theme: theme,
                                onPressed: () async {
                                  if (isModified) {
                                    if (_formKey.currentState!.validate()) {
                                      await checkConnectivity(
                                          context: context,
                                          onConnected: () {
                                            _modify_menuItemCubit
                                                .uploadModifiedMenuItem(
                                                    storeID: storeID,
                                                    itemName:
                                                        _itemnameController.text
                                                            .trim(),
                                                    category: _categoryCubit
                                                        .state,
                                                    mrp: int.parse(
                                                        _mrpController.text
                                                            .trim()),
                                                    isavailable:
                                                        _availableCubit.state,
                                                    imageFile: imageFile,
                                                    itemID: widget
                                                        .menuItemModel.itemID!);
                                          });
                                    }
                                  } else {
                                    showSnackBar(
                                        context: context,
                                        error: 'Please Modify some Values.');
                                  }
                                },
                                title: 'Modify'),
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
