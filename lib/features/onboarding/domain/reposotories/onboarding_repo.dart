import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mazar_marke/common/models/api_response_model.dart';
import 'package:mazar_marke/features/onboarding/domain/models/onboarding_model.dart';
import 'package:mazar_marke/localization/app_localization.dart';
import 'package:mazar_marke/utill/images.dart';

import '../../../../remote/dio/dio_client.dart';
import '../../../../remote/exception/api_error_handler.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponseModel> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoarding1, 'select_your_items_to_buy'.tr,
            'onboarding_1_text'.tr),
        OnBoardingModel(Images.onBoarding2,
            'order_item_from_your_shopping_bag'.tr, 'onboarding_2_text'.tr),
        OnBoardingModel(Images.onBoarding3,
            'our_system_delivery_item_to_you'.tr, 'onboarding_3_text'.tr),
      ];

      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: onBoardingList,
          statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
