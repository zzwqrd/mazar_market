import 'package:flutter/material.dart';
import 'package:mazar_marke/common/providers/cart_provider.dart';
import 'package:mazar_marke/common/widgets/app_bar_base_widget.dart';
import 'package:mazar_marke/common/widgets/no_data_widget.dart';
import 'package:mazar_marke/common/widgets/web_app_bar_widget.dart';
import 'package:mazar_marke/features/cart/widgets/cart_button_widget.dart';
import 'package:mazar_marke/features/cart/widgets/cart_product_list_widget.dart';
import 'package:mazar_marke/features/coupon/providers/coupon_provider.dart';
import 'package:mazar_marke/features/order/providers/order_provider.dart';
import 'package:mazar_marke/features/splash/providers/splash_provider.dart';
import 'package:mazar_marke/helper/responsive_helper.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/images.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_details_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  @override
  void initState() {
    _couponController.clear();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null
          : (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
              : const AppBarBaseWidget()) as PreferredSizeWidget?,
      body: Consumer3<CartProvider, CouponProvider, OrderProvider>(
        builder: (context, cartProvider, couponProvider, orderProvider, child) {
          // Configurations
          final configModel =
              Provider.of<SplashProvider>(context, listen: false).configModel!;
          final bool isSelfPickupActive = configModel.selfPickup == 1;
          final bool kmWiseCharge = configModel.deliveryManagement!.status!;

          // Calculate Charges
          final double deliveryCharge = _getDeliveryChange(
            orderProvider.orderType,
            kmWiseCharge,
            configModel.deliveryCharge,
            couponProvider.coupon?.couponType,
          );

          double itemPrice = 0;
          double discount = 0;
          double tax = 0;

          for (var cartModel in cartProvider.cartList) {
            itemPrice += (cartModel.price! * cartModel.quantity!);
            discount += (cartModel.discount! * cartModel.quantity!);
            tax += (cartModel.tax! * cartModel.quantity!);
          }

          double subTotal =
              itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
          bool isFreeDelivery =
              subTotal >= configModel.freeDeliveryOverAmount! &&
                      configModel.freeDeliveryStatus! ||
                  couponProvider.coupon?.couponType == 'free_delivery';

          double total = subTotal -
              discount -
              couponProvider.discount! +
              (isFreeDelivery ? 0 : deliveryCharge);

          return cartProvider.cartList.isNotEmpty
              ? _buildCartUI(
                  context: context,
                  isDesktop: ResponsiveHelper.isDesktop(context),
                  cartProvider: cartProvider,
                  couponProvider: couponProvider,
                  orderProvider: orderProvider,
                  itemPrice: itemPrice,
                  discount: discount,
                  tax: tax,
                  subTotal: subTotal,
                  total: total,
                  deliveryCharge: deliveryCharge,
                  isFreeDelivery: isFreeDelivery,
                  isSelfPickupActive: isSelfPickupActive,
                  kmWiseCharge: kmWiseCharge,
                  configModel: configModel,
                )
              : NoDataWidget(
                  image: Images.favouriteNoDataImage,
                  title: getTranslated('empty_shopping_bag', context));
        },
      ),
    );
  }

  Widget _buildCartUI({
    required BuildContext context,
    required bool isDesktop,
    required CartProvider cartProvider,
    required CouponProvider couponProvider,
    required OrderProvider orderProvider,
    required double itemPrice,
    required double discount,
    required double tax,
    required double subTotal,
    required double total,
    required double deliveryCharge,
    required bool isFreeDelivery,
    required bool isSelfPickupActive,
    required bool kmWiseCharge,
    required configModel,
  }) {
    if (!isDesktop) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CartProductListWidget(),
                      CartDetailsWidget(
                        total: total,
                        isSelfPickupActive: isSelfPickupActive,
                        kmWiseCharge: kmWiseCharge,
                        isFreeDelivery: isFreeDelivery,
                        itemPrice: itemPrice,
                        tax: tax,
                        discount: discount,
                        deliveryCharge: deliveryCharge,
                        couponController: _couponController,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CartButtonWidget(
            subTotal: subTotal,
            configModel: configModel,
            itemPrice: itemPrice,
            total: total,
            isFreeDelivery: isFreeDelivery,
            deliveryCharge: deliveryCharge,
          ),
        ],
      );
    } else {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeLarge,
                            right: Dimensions.paddingSizeLarge,
                            top: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Dimensions.radiusSizeDefault)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.01),
                                  spreadRadius: 1,
                                  blurRadius: 1),
                            ],
                          ),
                          child: const CartProductListWidget(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CartDetailsWidget(
                              couponController: _couponController,
                              total: total,
                              isSelfPickupActive: isSelfPickupActive,
                              kmWiseCharge: kmWiseCharge,
                              isFreeDelivery: isFreeDelivery,
                              itemPrice: itemPrice,
                              tax: tax,
                              discount: discount,
                              deliveryCharge: deliveryCharge,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            CartButtonWidget(
                              subTotal: subTotal,
                              configModel: configModel,
                              itemPrice: itemPrice,
                              total: total,
                              isFreeDelivery: isFreeDelivery,
                              deliveryCharge: deliveryCharge,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  double _getDeliveryChange(String? orderType, bool kmWiseCharge,
      double? deliveryCharge, String? couponType) {
    if (orderType == 'delivery' && !kmWiseCharge) {
      return deliveryCharge ?? 0;
    }

    if (couponType == 'free_delivery') {
      return 0;
    }

    return 0;
  }
}

// import 'package:flutter/material.dart';
// import 'package:mazar_marke/common/enums/footer_type_enum.dart';
// import 'package:mazar_marke/common/providers/cart_provider.dart';
// import 'package:mazar_marke/common/widgets/app_bar_base_widget.dart';
// import 'package:mazar_marke/common/widgets/footer_web_widget.dart';
// import 'package:mazar_marke/common/widgets/no_data_widget.dart';
// import 'package:mazar_marke/common/widgets/web_app_bar_widget.dart';
// import 'package:mazar_marke/features/cart/widgets/cart_button_widget.dart';
// import 'package:mazar_marke/features/cart/widgets/cart_product_list_widget.dart';
// import 'package:mazar_marke/features/coupon/providers/coupon_provider.dart';
// import 'package:mazar_marke/features/order/providers/order_provider.dart';
// import 'package:mazar_marke/features/splash/providers/splash_provider.dart';
// import 'package:mazar_marke/helper/responsive_helper.dart';
// import 'package:mazar_marke/localization/language_constraints.dart';
// import 'package:mazar_marke/utill/dimensions.dart';
// import 'package:mazar_marke/utill/images.dart';
// import 'package:provider/provider.dart';
//
// import '../widgets/cart_details_widget.dart';
//
// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   final TextEditingController _couponController = TextEditingController();
//
//   @override
//   void initState() {
//     _couponController.clear();
//     Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
//     Provider.of<OrderProvider>(context, listen: false)
//         .setOrderType('delivery', notify: false);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final configModel =
//         Provider.of<SplashProvider>(context, listen: false).configModel!;
//     final OrderProvider orderProvider =
//         Provider.of<OrderProvider>(context, listen: false);
//
//     bool isSelfPickupActive = configModel.selfPickup == 1;
//     bool kmWiseCharge = configModel.deliveryManagement!.status!;
//
//     return Scaffold(
//       appBar: ResponsiveHelper.isMobilePhone()
//           ? null
//           : (ResponsiveHelper.isDesktop(context)
//               ? const PreferredSize(
//                   preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
//               : const AppBarBaseWidget()) as PreferredSizeWidget?,
//       body: Center(
//         child: Consumer<CouponProvider>(builder: (context, couponProvider, _) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//             return Consumer<CartProvider>(
//               builder: (context, cart, child) {
//                 double? deliveryCharge = _getDeliveryChange(
//                   orderProvider.orderType,
//                   kmWiseCharge,
//                   configModel.deliveryCharge,
//                   couponProvider.coupon?.couponType,
//                 );
//
//                 double itemPrice = 0;
//                 double discount = 0;
//                 double tax = 0;
//
//                 for (var cartModel in cart.cartList) {
//                   itemPrice =
//                       itemPrice + (cartModel.price! * cartModel.quantity!);
//                   discount =
//                       discount + (cartModel.discount! * cartModel.quantity!);
//                   tax = tax + (cartModel.tax! * cartModel.quantity!);
//                 }
//
//                 double subTotal =
//                     itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
//                 bool isFreeDelivery =
//                     subTotal >= configModel.freeDeliveryOverAmount! &&
//                             configModel.freeDeliveryStatus! ||
//                         couponProvider.coupon?.couponType == 'free_delivery';
//
//                 double total = subTotal -
//                     discount -
//                     Provider.of<CouponProvider>(context).discount! +
//                     (isFreeDelivery ? 0 : deliveryCharge);
//
//                 return cart.cartList.isNotEmpty
//                     ? !ResponsiveHelper.isDesktop(context)
//                         ? Column(children: [
//                             Expanded(
//                                 child: SingleChildScrollView(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: Dimensions.paddingSizeDefault,
//                                 vertical: Dimensions.paddingSizeSmall,
//                               ),
//                               child: Center(
//                                   child: SizedBox(
//                                 width: Dimensions.webScreenWidth,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // Product
//                                       const CartProductListWidget(),
//                                       //const SizedBox(height: Dimensions.paddingSizeDefault),
//
//                                       CartDetailsWidget(
//                                         couponController: _couponController,
//                                         total: total,
//                                         isSelfPickupActive: isSelfPickupActive,
//                                         kmWiseCharge: kmWiseCharge,
//                                         isFreeDelivery: isFreeDelivery,
//                                         itemPrice: itemPrice,
//                                         tax: tax,
//                                         discount: discount,
//                                         deliveryCharge: deliveryCharge,
//                                       ),
//                                       const SizedBox(height: 40),
//                                     ]),
//                               )),
//                             )),
//                             CartButtonWidget(
//                               subTotal: subTotal,
//                               configModel: configModel,
//                               itemPrice: itemPrice,
//                               total: total,
//                               isFreeDelivery: isFreeDelivery,
//                               deliveryCharge: deliveryCharge,
//                             ),
//                           ])
//                         : CustomScrollView(slivers: [
//                             SliverToBoxAdapter(
//                               child: Center(
//                                   child: SizedBox(
//                                       width: Dimensions.webScreenWidth,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical:
//                                                 Dimensions.paddingSizeLarge),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                                 flex: 6,
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                     left: Dimensions
//                                                         .paddingSizeLarge,
//                                                     right: Dimensions
//                                                         .paddingSizeLarge,
//                                                     top: Dimensions
//                                                         .paddingSizeLarge,
//                                                     bottom: Dimensions
//                                                         .paddingSizeSmall,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: Theme.of(context)
//                                                         .cardColor,
//                                                     borderRadius: const BorderRadius
//                                                         .all(
//                                                         Radius.circular(Dimensions
//                                                             .radiusSizeDefault)),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                           color: Colors.grey
//                                                               .withOpacity(
//                                                                   0.01),
//                                                           spreadRadius: 1,
//                                                           blurRadius: 1),
//                                                     ],
//                                                   ),
//                                                   child:
//                                                       const CartProductListWidget(),
//                                                 )),
//                                             const SizedBox(
//                                                 width: Dimensions
//                                                     .paddingSizeLarge),
//                                             Expanded(
//                                                 flex: 4,
//                                                 child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       CartDetailsWidget(
//                                                         couponController:
//                                                             _couponController,
//                                                         total: total,
//                                                         isSelfPickupActive:
//                                                             isSelfPickupActive,
//                                                         kmWiseCharge:
//                                                             kmWiseCharge,
//                                                         isFreeDelivery:
//                                                             isFreeDelivery,
//                                                         itemPrice: itemPrice,
//                                                         tax: tax,
//                                                         discount: discount,
//                                                         deliveryCharge:
//                                                             deliveryCharge,
//                                                       ),
//                                                       const SizedBox(
//                                                           height: Dimensions
//                                                               .paddingSizeLarge),
//                                                       CartButtonWidget(
//                                                         subTotal: subTotal,
//                                                         configModel:
//                                                             configModel,
//                                                         itemPrice: itemPrice,
//                                                         total: total,
//                                                         isFreeDelivery:
//                                                             isFreeDelivery,
//                                                         deliveryCharge:
//                                                             deliveryCharge,
//                                                       ),
//                                                     ]))
//                                           ],
//                                         ),
//                                       ))),
//                             ),
//                             const FooterWebWidget(
//                                 footerType: FooterType.sliver),
//                           ])
//                     : NoDataWidget(
//                         image: Images.favouriteNoDataImage,
//                         title: getTranslated('empty_shopping_bag', context));
//               },
//             );
//           });
//         }),
//       ),
//     );
//   }
//
//   double _getDeliveryChange(String? orderType, bool kmWiseCharge,
//       double? deliveryCharge, couponType) {
//     double deliveryAmount = 0;
//     if (orderType == 'delivery' && !kmWiseCharge) {
//       deliveryAmount = deliveryCharge ?? 0;
//     } else {
//       return deliveryAmount = 0;
//     }
//
//     if (couponType == 'free_delivery') {
//       return deliveryAmount = 0;
//     }
//
//     return deliveryAmount;
//   }
// }
