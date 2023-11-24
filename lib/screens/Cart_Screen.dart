import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/cart_cubit/cartDisplay_cubit.dart';
import 'package:food_cafe/cubits/cart_cubit/cartLocalState_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String entryNo;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // late Map<String, dynamic> localState;

  @override
  void initState() {
    entryNo = context.read<LoginCubit>().getEntryNo();
    context.read<CartDisplayCubit>().startListening(entryNo);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // context.read<CartLocalState>().syncLocalState(entryNo);
    context.read<CartDisplayCubit>().close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(14),
        child: TextButton(
          onPressed: () async {
            if (context.read<CartLocalState>().state.isNotEmpty) {
              await context.read<CartLocalState>().syncLocalState(entryNo);
              Navigator.pushNamed(context, Routes.billingScreen);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nothing to Checkout!")));
            }
          },
          child: Text(
            "Place My Order",
            style: theme.textTheme.labelLarge,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Order details",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<CartDisplayCubit, List<Cart_FoodCard_Model>>(
                    builder: (context, list) {
                  final cartLocalState = context.watch<CartLocalState>();
                  return SizedBox(
                    //TODO: Check without giving the height constraint!, like done in MenuItems Screen
                    height: 700,
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final cartItem = list[index];
                          final quantity =
                              cartLocalState.state[cartItem.itemID];
                          print(
                              'Item ID: ${cartItem.itemID}, Quantity: $quantity');
                          return Cart_FoodCard(
                            theme: theme,
                            context: _scaffoldKey.currentContext!,
                            item: cartItem,
                            decreaseQuantity: () {
                              cartLocalState.removeItemsfromLocal(
                                  entryNo, cartItem.itemID!);
                            },
                            increaseQuantity: () {
                              cartLocalState.addItemsToLocal(
                                  cartItem.itemID!, entryNo);
                            },
                            onDismissed: (direction) {
                              cartLocalState.deleteItemfromCart(
                                  entryNo, cartItem.itemID!);
                            },
                            itemQuantity: quantity!,
                          );
                        }),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Dismissible Cart_FoodCard({
    required ThemeData theme,
    required BuildContext context,
    required Cart_FoodCard_Model item,
    required VoidCallback decreaseQuantity,
    required VoidCallback increaseQuantity,
    required void Function(DismissDirection)? onDismissed,
    required int itemQuantity,
  }) {
    return Dismissible(
      onDismissed: onDismissed,
      key: Key(item.itemID!),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.restore_from_trash,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 11.w),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 62.h,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        "https://www.vegrecipesofindia.com/wp-content/uploads/2022/12/garlic-naan-3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.name!,
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      item.itemID!,
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      "\₹ ${item.mrp}",
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: decreaseQuantity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 26.h,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(Icons.remove),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  itemQuantity.toString(),
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(
                  width: 16.w,
                ),
                InkWell(
                  onTap: increaseQuantity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 26.h,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(
                        Icons.add,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
