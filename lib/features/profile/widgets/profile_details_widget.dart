import 'package:flutter/material.dart';
import 'package:mazar_marke/common/widgets/custom_loader_widget.dart';
import 'package:mazar_marke/features/profile/providers/profile_provider.dart';
import 'package:mazar_marke/helper/responsive_helper.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/styles.dart';
import 'package:provider/provider.dart';

class ProfileDetailsWidget extends StatelessWidget {
  const ProfileDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return profileProvider.isLoading
          ? CustomLoaderWidget(color: Theme.of(context).primaryColor)
          : Center(
              child: Container(
                width: Dimensions.webScreenWidth * 0.7,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  getTranslated('name', context),
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.6)),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                                const Divider(),
                              ])
                        : Center(
                            child: Text(
                            '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}',
                            style: poppinsMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge),
                          )),
                    const SizedBox(height: 30),

                    // for first name section
                    Text(
                      getTranslated('mobile_number', context),
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).hintColor.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      profileProvider.userInfoModel!.phone ?? '',
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                    ),
                    const Divider(),

                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Text(
                      getTranslated('email', context),
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).hintColor.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      profileProvider.userInfoModel?.email ?? '',
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                    ),
                    const Divider(),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  ],
                ),
              ),
            );
    });
  }
}
