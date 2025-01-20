import 'package:flutter/material.dart';
import 'package:mazar_marke/features/wallet_and_loyalty/domain/models/wallet_filter_model.dart';
import 'package:mazar_marke/localization/language_constraints.dart';
import 'package:mazar_marke/main.dart';
import 'package:mazar_marke/utill/styles.dart';

class WalletHelper {
  static List<PopupMenuEntry> getPopupMenuList(
      {required List<WalletFilterModel> walletFilterList,
      required String? type}) {
    List<PopupMenuEntry> entryList = [];

    for (int i = 0; i < walletFilterList.length; i++) {
      entryList.add(PopupMenuItem<int>(
          value: i,
          child: Text(
            getTranslated(walletFilterList[i].title!, Get.context!),
            style: poppinsMedium.copyWith(
              color: walletFilterList[i].value == type
                  ? Theme.of(Get.context!).textTheme.bodyMedium!.color
                  : Theme.of(Get.context!).disabledColor,
            ),
          )));
    }
    return entryList;
  }
}
