import 'package:flutter/material.dart';
import 'package:mazar_marke/common/enums/footer_type_enum.dart';
import 'package:mazar_marke/common/widgets/app_bar_base_widget.dart';
import 'package:mazar_marke/common/widgets/footer_web_widget.dart';
import 'package:mazar_marke/common/widgets/no_data_widget.dart';
import 'package:mazar_marke/common/widgets/not_login_widget.dart';
import 'package:mazar_marke/common/widgets/product_widget.dart';
import 'package:mazar_marke/common/widgets/web_app_bar_widget.dart';
import 'package:mazar_marke/features/auth/providers/auth_provider.dart';
import 'package:mazar_marke/features/wishlist/providers/wishlist_provider.dart';
import 'package:mazar_marke/helper/responsive_helper.dart';
import 'package:mazar_marke/localization/app_localization.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/images.dart';
import 'package:mazar_marke/utill/styles.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
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
      body: _isLoggedIn
          ? Consumer<WishListProvider>(
              builder: (context, wishlistProvider, child) {
                if (wishlistProvider.isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)));
                }
                return wishlistProvider.wishList != null
                    ? wishlistProvider.wishList!.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .getWishListProduct();
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CustomScrollView(slivers: [
                              SliverToBoxAdapter(
                                  child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                      vertical: Dimensions.paddingSizeDefault),
                                  child: SizedBox(
                                      width: Dimensions.webScreenWidth,
                                      child: Column(children: [
                                        ResponsiveHelper.isDesktop(context)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .paddingSizeExtraLarge),
                                                child: Text("favourite_list".tr,
                                                    style: poppinsSemiBold
                                                        .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge)),
                                              )
                                            : const SizedBox(),
                                        GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 13
                                                          : 10,
                                                  mainAxisSpacing:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 13
                                                          : 10,
                                                  childAspectRatio:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? (1 / 1.41)
                                                          : (1 / 1.6),
                                                  crossAxisCount:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 5
                                                          : ResponsiveHelper
                                                                  .isTab(
                                                                      context)
                                                              ? 2
                                                              : 2),
                                          itemCount:
                                              wishlistProvider.wishList!.length,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ProductWidget(
                                                product: wishlistProvider
                                                    .wishList![index],
                                                isGrid: true,
                                                isCenter: true);
                                          },
                                        ),
                                      ])),
                                ),
                              )),
                              const FooterWebWidget(
                                  footerType: FooterType.sliver),
                            ]),
                          )
                        : NoDataWidget(
                            title: getTranslated('not_product_found', context),
                            image: Images.favouriteNoDataImage)
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
              },
            )
          : const NotLoggedInWidget(),
    );
  }
}
