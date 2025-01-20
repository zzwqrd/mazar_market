import 'package:flutter/material.dart';
import 'package:mazar_marke/common/providers/cart_provider.dart';
import 'package:mazar_marke/features/cart/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartProductListWidget extends StatelessWidget {
  const CartProductListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cartProvider.cartList.length,
        itemBuilder: (context, index) {
          return CartItemWidget(
            cart: cartProvider.cartList[index],
            index: index,
          );
        },
      );
    });
  }
}
