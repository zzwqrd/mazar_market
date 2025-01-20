import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mazar_marke/common/models/api_response_model.dart';
import 'package:mazar_marke/common/models/language_model.dart';
import 'package:mazar_marke/utill/app_constants.dart';

import '../../remote/dio/dio_client.dart';
import '../../remote/exception/api_error_handler.dart';

class LanguageRepo {
  final DioClient? dioClient;

  LanguageRepo({required this.dioClient});

  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }

  Future<ApiResponseModel> changeLanguageApi(
      {required String? languageCode}) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.changeLanguage,
        data: {'language_code': languageCode},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
