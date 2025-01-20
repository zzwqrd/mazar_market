import 'package:flutter/material.dart';
import 'package:mazar_marke/common/widgets/custom_directionality_widget.dart';
import 'package:mazar_marke/utill/dimensions.dart';
import 'package:mazar_marke/utill/styles.dart';

class PriceItemWidget extends StatelessWidget {
  const PriceItemWidget(
      {Key? key, required this.title, required this.subTitle, this.style})
      : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: style ??
              poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).disabledColor)),
      CustomDirectionalityWidget(
          child: Text(
        subTitle,
        style: style ??
            poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
    ]);
  }
}
