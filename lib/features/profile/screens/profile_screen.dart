import 'package:flutter/material.dart';
import 'package:mazar_marke/common/enums/footer_type_enum.dart';
import 'package:mazar_marke/common/widgets/footer_web_widget.dart';
import 'package:mazar_marke/common/widgets/not_login_widget.dart';
import 'package:mazar_marke/common/widgets/web_app_bar_widget.dart';
import 'package:mazar_marke/features/auth/providers/auth_provider.dart';
import 'package:mazar_marke/features/profile/providers/profile_provider.dart';
import 'package:mazar_marke/features/profile/widgets/profile_details_widget.dart';
import 'package:mazar_marke/features/profile/widgets/profile_header_widget.dart';
import 'package:mazar_marke/features/splash/providers/splash_provider.dart';
import 'package:mazar_marke/helper/responsive_helper.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/images.dart';
import 'package:mazar_marke/utill/styles.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : AppBar(
              backgroundColor: Theme.of(context).cardColor,
              leading: IconButton(
                  icon: Image.asset(Images.moreIcon,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    splashProvider.setPageIndex(0);
                    Navigator.of(context).pop();
                  }),
              title: Text(getTranslated('profile', context),
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  )),
            ),
      body: SafeArea(
        child: _isLoggedIn
            ? Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                return const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: CustomScrollView(slivers: [
                      SliverToBoxAdapter(child: ProfileHeaderWidget()),
                      SliverToBoxAdapter(child: ProfileDetailsWidget()),
                      FooterWebWidget(footerType: FooterType.sliver),
                    ]));
              })
            : const NotLoggedInWidget(),
      ),
    );
  }
}
