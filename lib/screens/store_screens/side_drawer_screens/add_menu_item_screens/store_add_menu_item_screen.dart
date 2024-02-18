import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_states.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_states.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';
import 'package:food_cafe/widgets/headings.dart';
import 'package:food_cafe/widgets/store_pick_image_button.dart';
import 'package:food_cafe/widgets/store_picked_image_preview.dart';

class StoreAddMenuItemScreen extends StatefulWidget {
  const StoreAddMenuItemScreen({super.key});

  @override
  State<StoreAddMenuItemScreen> createState() => _StoreAddMenuItemScreenState();
}

class _StoreAddMenuItemScreenState extends State<StoreAddMenuItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();

  File? imageFile;

  late String storeID;
  late String personID;

  late AddImageCubit _addImageCubit;
  late CategoryCubit _categoryCubit;
  late AvailableCubit _availableCubit;
  late AddItemCubit _addItemCubit;

  void initializeCubits() {
    MapEntry<String, String> cafeOwnerDetails = checkLoginStateForCafeOwner(
        context: context, screenName: 'Add Menu Items Screen');
    personID = cafeOwnerDetails.key;
    storeID = cafeOwnerDetails.value;
    _addImageCubit = BlocProvider.of<AddImageCubit>(context);
    _categoryCubit = BlocProvider.of<CategoryCubit>(context);
    _availableCubit = BlocProvider.of<AvailableCubit>(context);
    _addItemCubit = BlocProvider.of<AddItemCubit>(context);
  }

  @override
  void initState() {
    super.initState();

    initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _addImageCubit.close();
    _addItemCubit.close();
    _availableCubit.close();
    _categoryCubit.close();
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
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Add Menu Item",
                  style: theme.textTheme.titleLarge,
                ),
                
                Text(
                  "The Item ID will be generated automatically relative to the previous Item ID.",
                  style: theme.textTheme.bodySmall!.copyWith(height: 1.25),
                ),
                const SizedBox(
                  height: 10,
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
                      storeSubHeading(theme: theme, heading: 'Add Image'),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<AddImageCubit, AddImage>(
                        listener: (context, state) {
                          if (state is ImageErrorState) {
                            showSnackBar(context: context, error: state.error);
                          }
                        },
                        builder: (context, state) {
                          if (state is ImageLoadingState) {
                            return const CircularProgressIndicator();
                          } else if (state is ImageLoadedState) {
                            imageFile = state.image;
                            return Row(
                              children: [
                                storePickedImageView(pickedImage: state.image),
                                const SizedBox(
                                  width: 10,
                                ),
                                storePickImageButton(
                                    toChangeImage: true,
                                    onTap: () {
                                      _addImageCubit.pickImage();
                                    },
                                    theme: theme),
                              ],
                            );
                          } else if (state is ImageInitialState ||
                              state is ImageErrorState) {
                            return storePickImageButton(
                                toChangeImage: false,
                                onTap: () {
                                  _addImageCubit.pickImage();
                                },
                                theme: theme);
                          }
                          return const Text("Waiting!");
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<AddItemCubit, AddItemState>(
                    builder: (context, state) {
                  if (state is AddItemLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is AddItemImageUploadedState) {
                    return const Text("Image Uploaded!");
                  }

                  return Center(
                      child: customButton(
                          context: context,
                          theme: theme,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (imageFile != null) {
                                await checkConnectivity(
                                    context: context,
                                    onConnected: () {
                                      _addItemCubit.uploadItemtoFireStore(
                                        storeID: storeID,
                                        name: _itemnameController.text.trim(),
                                        category: _categoryCubit.state,
                                        mrp: int.parse(
                                            _mrpController.text.trim()),
                                        isavailable: _availableCubit.state,
                                        imageFile: imageFile!,
                                      );
                                    });
                              } else {
                                showSnackBar(
                                    context: context,
                                    error: 'Please provide an Item Image.');
                              }
                            }
                          },
                          title: "Add Item"));
                }, listener: (context, state) {
                  if (state is AddItemImageUploadErrorState) {
                    showSnackBar(context: context, error: state.error);
                  } else if (state is AddItemErrorState) {
                    showSnackBar(context: context, error: state.error);
                  } else if (state is AddItemUploadedState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.store_ItemAdded, (route) => false);
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
  'Beverages',
  'Sides',
  'Specials'
];
