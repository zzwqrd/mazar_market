import 'package:flutter/material.dart';
import 'package:mazar_marke/common/providers/product_provider.dart';
import 'package:mazar_marke/common/widgets/custom_button_widget.dart';
import 'package:mazar_marke/features/order/domain/models/order_details_model.dart';
import 'package:mazar_marke/features/order/domain/models/order_model.dart';
import 'package:mazar_marke/features/order/providers/order_provider.dart';
import 'package:mazar_marke/features/order/widgets/order_cancel_widget.dart';
import 'package:mazar_marke/features/review/screens/rate_review_screen.dart';
import 'package:mazar_marke/helper/custom_snackbar_helper.dart';
import 'package:mazar_marke/helper/order_helper.dart';
import 'package:mazar_marke/helper/route_helper.dart';
import 'package:mazar_marke/localization/app_localization.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderDetailsButtonView extends StatelessWidget {
  final OrderModel? orderModel;
  final String? phoneNumber;
  const OrderDetailsButtonView(
      {Key? key, required this.orderModel, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      List<OrderDetailsModel> orderDetailsList =
          OrderHelper.getOrderDetailsList(
              orderList: orderProvider.orderDetails);

      return Column(children: [
        !orderProvider.showCancelled
            ? Center(
                child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: Row(children: [
                    orderProvider.trackModel!.orderStatus == 'pending'
                        ? Expanded(
                            child: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(1, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.1))),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => OrderCancelWidget(
                                          orderID: orderProvider.trackModel!.id
                                              .toString(),
                                          fromOrder: orderModel != null,
                                          callback: (String message,
                                              bool isSuccess, String orderID) {
                                            if (isSuccess) {
                                              productProvider.getAllProductList(
                                                  1, true);

                                              showCustomSnackBarHelper(
                                                  '$message ${'order_id'.tr}: $orderID',
                                                  isError: false);
                                            } else {
                                              showCustomSnackBarHelper(message);
                                            }
                                          },
                                        ));
                              },
                              child: Text('cancel_order'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.withOpacity(0.6),
                                        fontSize: Dimensions.fontSizeLarge,
                                      )),
                            ),
                          ))
                        : const SizedBox(),
                  ]),
                ),
              )
            : Container(
                width: Dimensions.webScreenWidth,
                height: 50,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('order_cancelled'.tr,
                    style: poppinsRegular.copyWith(
                        color: Theme.of(context).primaryColor)),
              ),
        (orderProvider.trackModel!.orderStatus == 'confirmed' ||
                orderProvider.trackModel!.orderStatus == 'processing' ||
                orderProvider.trackModel!.orderStatus == 'out_for_delivery')
            ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  buttonText: 'track_order'.tr,
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        RouteHelper.getOrderTrackingRoute(
                            orderProvider.trackModel!.id, phoneNumber));
                  },
                ),
              )
            : const SizedBox(),
        orderProvider.orderDetails != null &&
                orderDetailsList.isNotEmpty &&
                orderProvider.trackModel!.orderStatus == 'delivered'
            ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  buttonText: 'review'.tr,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RateReviewScreen(
                              orderDetailsList: orderDetailsList,
                              deliveryMan:
                                  orderProvider.trackModel!.deliveryMan,
                            )));
                  },
                ),
              )
            : const SizedBox(),
        if (orderProvider.trackModel!.deliveryMan != null &&
            (orderProvider.trackModel!.orderStatus == 'processing' ||
                orderProvider.trackModel!.orderStatus == 'out_for_delivery'))
          Center(
            child: Container(
              width: Dimensions.webScreenWidth,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButtonWidget(
                  buttonText: 'chat_with_delivery_man'.tr,
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        RouteHelper.getChatRoute(
                            orderModel: orderProvider.trackModel));
                  }),
            ),
          ),
      ]);
    });
  }
}
