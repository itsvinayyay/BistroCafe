import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_states.dart';
import 'package:food_cafe/cubits/user_role_cubits/check_store_timings_cubit/check_timings_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/check_store_timings_cubit/check_timings_states.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/screens/user_screens/custom_cards/cart_screen_food_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_alert_dialog_box.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String personID;
  late CheckTimingsCubit _checkTimingsCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initializeCubits() {
    personID =
        checkLoginStateForUser(context: context, screenName: 'Cart Screen');
    _checkTimingsCubit = BlocProvider.of(context);
  }

  @override
  void initState() {
    initializeCubits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartLocalState = context.watch<CartLocalState>();

    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: BlocConsumer<CheckTimingsCubit, CheckTimingsStates>(
        listener: (context, state) {
          if (state is CheckTimingsErrorState) {
            showDialog(
                context: context,
                builder: (_) => CustomErrorAlertDialogBox(
                      heading: state.heading,
                      subHeading: state.subHeading,
                    ));
          } else if (state is CheckTimingsLoadedState) {
            Navigator.pushNamed(context, Routes.billingScreen);
          }
        },
        builder: (context, state) {
          if (state is CheckTimingsLoadingState) {
            return CircularProgressIndicator(
              color: theme.colorScheme.tertiary,
            );
          }
          return customButton(
              context: context,
              theme: theme,
              onPressed: () async {
                await checkConnectivity(
                    context: context,
                    onConnected: () async {
                      if (context.read<CartLocalState>().state.isNotEmpty) {
                        await _checkTimingsCubit.initiateTimeCheck(
                            storeID: 'SMVDU101');
                        if (context.mounted) {
                          await context
                              .read<CartLocalState>()
                              .syncLocalState(personID: personID);
                        }
                      } else {
                        showSnackBar(
                            context: context, error: 'Nothing to Checkout!');
                      }
                    });
              },
              title: 'Proceed');
        },
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Order details",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CartDisplayCubit, CartDisplay>(
                    builder: (context, state) {
                  if (state is CartItemLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is CartItemErrorState) {
                    return Text(state.message);
                  } else if (state is CartItemLoadedState &&
                      state.cartList.isEmpty) {
                    return const CustomEmptyError(
                        message: 'Your Cart is Empty Add Items to CheckOut!');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.cartList.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.cartList[index];
                        final quantity = cartLocalState.state[cartItem.itemID];
                        return cartFoodCard(
                          theme: theme,
                          context: context,
                          item: cartItem,
                          decreaseQuantity: () {
                            cartLocalState.removeItemsfromLocal(
                                personID: personID, itemID: cartItem.itemID!);
                          },
                          increaseQuantity: () {
                            cartLocalState.addItemsToLocal(
                                itemID: cartItem.itemID!, personID: personID);
                          },
                          onDismissed: (direction) {
                            cartLocalState.deleteItemfromCart(
                                personID: personID, itemID: cartItem.itemID!);
                          },
                          itemQuantity: quantity ?? 0,
                        );
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
