import 'package:flutter/material.dart';
import 'package:mazar_marke/common/widgets/custom_app_bar_widget.dart';
import 'package:mazar_marke/features/order/domain/models/order_details_model.dart';
import 'package:mazar_marke/features/order/domain/models/order_model.dart';
import 'package:mazar_marke/features/review/providers/review_provider.dart';
import 'package:mazar_marke/features/review/widgets/deliver_man_review_widget.dart';
import 'package:mazar_marke/features/review/widgets/product_review_widget.dart';
import 'package:mazar_marke/helper/responsive_helper.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/web_app_bar_widget.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan? deliveryMan;
  const RateReviewScreen(
      {Key? key, required this.orderDetailsList, required this.deliveryMan})
      : super(key: key);

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: widget.deliveryMan == null ? 1 : 2,
        initialIndex: 0,
        vsync: this);
    Provider.of<ReviewProvider>(context, listen: false)
        .initRatingData(widget.orderDetailsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
              : CustomAppBarWidget(
                  title: getTranslated('rate_review', context)))
          as PreferredSizeWidget?,
      body: Column(children: [
        Center(
            child: Container(
          width: Dimensions.webScreenWidth,
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).textTheme.bodyLarge!.color,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            unselectedLabelStyle: poppinsRegular.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.6),
                fontSize: Dimensions.fontSizeSmall),
            labelStyle:
                poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            tabs: [
              Tab(
                  text: getTranslated(
                      widget.orderDetailsList.length > 1 ? 'items' : 'item',
                      context)),
              if (widget.deliveryMan != null)
                Tab(text: getTranslated('delivery_man', context)),
            ],
          ),
        )),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
            if (widget.deliveryMan != null)
              DeliveryManReviewWidget(
                deliveryMan: widget.deliveryMan,
                orderID: widget.orderDetailsList[0].orderId.toString(),
              ),
          ],
        )),
      ]),
    );
  }
}
