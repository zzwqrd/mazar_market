import 'package:mazar_marke/common/models/api_response_model.dart';
import 'package:mazar_marke/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../remote/dio/dio_client.dart';
import '../../../../remote/exception/api_error_handler.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponseModel> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(AppConstants.countryCode, 'US');
    }
    if (!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(AppConstants.languageCode, 'en');
    }
    if (!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    if (!sharedPreferences!.containsKey(AppConstants.onBoardingSkip)) {
      return sharedPreferences!.setBool(AppConstants.onBoardingSkip, false);
    }

    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  void disableIntro() {
    sharedPreferences!.setBool(AppConstants.onBoardingSkip, false);
  }

  bool showIntro() {
    return sharedPreferences!.getBool(AppConstants.onBoardingSkip) ?? true;
  }

  Future<ApiResponseModel> getOfflinePaymentMethod() async {
    try {
      final response = await dioClient!.get(AppConstants.offlinePaymentMethod);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
