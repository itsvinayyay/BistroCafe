import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_management_cubit/store_management_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_management_cubit/store_management_states.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/store_management_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class StoreManagementScreen extends StatefulWidget {
  const StoreManagementScreen({super.key});

  @override
  State<StoreManagementScreen> createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {
  late OpeningTimeCubit _openingTimeCubit;
  late ClosingTimeCubit _closingTimeCubit;
  late AvailibilityCubit _availibilityCubit;
  late ManagementCubit _managementCubit;
  bool isModified = false;
  bool openingTimeModified = false;
  bool closingTimeModified = false;
  bool availibilityModified = false;

  void _initializeCubits(Map<String, dynamic> management) {
    _openingTimeCubit = BlocProvider.of<OpeningTimeCubit>(context);
    _openingTimeCubit.updateTime(management['openingTime']!);
    _closingTimeCubit = BlocProvider.of<ClosingTimeCubit>(context);
    _closingTimeCubit.updateTime(management['closingTime']!);

    _availibilityCubit = BlocProvider.of<AvailibilityCubit>(context);
    _availibilityCubit.updateAvailability(management['isAvailable']);

    _managementCubit = BlocProvider.of<ManagementCubit>(context);
  }

  void initialiseManagementScreen() async {
    ManagementRepository managementRepository = ManagementRepository();
    Map<String, dynamic> management =
        await managementRepository.getTimings(storeID: 'SMVDU101');
    if (context.mounted) {
      _initializeCubits(management);
    }
  }

  @override
  void initState() {
    super.initState();
    initialiseManagementScreen();
  }

  @override
  void dispose() {
    
    super.dispose();
    _openingTimeCubit.close();
    _closingTimeCubit.close();
    _availibilityCubit.close();
    _managementCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBackButton(context, theme),
                  Text(
                    "Management",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "OPENING TIME",
                    style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<OpeningTimeCubit, TimeOfDay>(
                      builder: (context, state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: state);

                            if (pickedTime != null) {
                              isModified = true;
                              openingTimeModified = true;
                              _openingTimeCubit.updateTime(pickedTime);
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Text(
                                  state.hour.toString().padLeft(2, '0'),
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 35, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                ':',
                                style: TextStyle(
                                  color: theme.colorScheme.tertiary,
                                  fontSize:
                                      35, // Adjust the font size as needed
                                  fontWeight: FontWeight
                                      .bold, // Optional: Adjust the font weight
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Text(
                                  state.minute.toString().padLeft(2, '0'),
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 35, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          state.period == DayPeriod.am ? 'AM' : 'PM',
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "CLOSING TIME",
                    style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<ClosingTimeCubit, TimeOfDay>(
                      builder: (context, state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: state);

                            if (pickedTime != null) {
                              isModified = true;
                              closingTimeModified = true;
                              _closingTimeCubit.updateTime(pickedTime);
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Text(
                                  state.hour.toString().padLeft(2, '0'),
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 35, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                ':',
                                style: TextStyle(
                                  color: theme.colorScheme.tertiary,
                                  fontSize:
                                      35, // Adjust the font size as needed
                                  fontWeight: FontWeight
                                      .bold, // Optional: Adjust the font weight
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Text(
                                  state.minute.toString().padLeft(2, '0'),
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 35, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          state.period == DayPeriod.am ? 'AM' : 'PM',
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AVAILABLE TODAY?",
                        style:
                            theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                      ),
                      BlocBuilder<AvailibilityCubit, bool>(
                          builder: (context, state) {
                        return SizedBox(
                          height: 20.h,
                          width: 40.w,
                          child: Switch(
                            value: state,
                            onChanged: (value) {
                              isModified = true;
                              availibilityModified = true;
                              _availibilityCubit.updateAvailability(value);
                            },
                            activeTrackColor:
                                const Color.fromRGBO(108, 117, 125, 0.12),
                            inactiveTrackColor:
                                const Color.fromRGBO(108, 117, 125, 0.12),
                            inactiveThumbColor: theme.colorScheme.primary,
                            activeColor: theme.colorScheme.secondary,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 0,
                      ),
                    ],
                  ),
                ],
              ),
              BlocConsumer<ManagementCubit, ManagementStates>(
                  listener: (context, state) {
                if (state is ManagementErrorState) {
                  showSnackBar(context: context, error: state.error);
                } else if (state is ManagementLoadedState) {
                  Navigator.pushReplacementNamed(
                      context, Routes.store_managementUpdated);
                }
              }, builder: (context, state) {
                if (state is ManagementLoadingState) {
                  return const CustomCircularProgress();
                } else if (state is ManagementLoadedState) {
                  return const Text('Management Details Updated!');
                }
                return customButton(
                    context: context,
                    theme: theme,
                    onPressed: () async {
                      if (isModified) {
                        double openingTime = toDouble(_openingTimeCubit.state);
                        double closingTime = toDouble(_closingTimeCubit.state);
                        if (openingTime < closingTime) {
                          await checkConnectivity(
                              context: context,
                              onConnected: () {
                                _managementCubit.initiateDetailsChange(
                                    storeID: 'SMVDU101',
                                    openingTime: _openingTimeCubit.state,
                                    closingTime: _closingTimeCubit.state,
                                    availibility: _availibilityCubit.state,
                                    openingTimeModified: openingTimeModified,
                                    closingTimeModified: closingTimeModified,
                                    availibilityModified: availibilityModified);
                              });
                        } else {
                          showSnackBar(
                              context: context,
                              error: 'Opening Time exceeds Closing Time!');
                        }
                      } else {
                        showSnackBar(
                            context: context,
                            error: 'Please Modify the Details First');
                      }
                    },
                    title: 'Save Changes');
              })
            ],
          ),
        ),
      ),
    );
  }
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
