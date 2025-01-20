import 'package:mazar_marke/common/models/api_response_model.dart';
import 'package:mazar_marke/utill/app_constants.dart';

import '../../../../remote/dio/dio_client.dart';
import '../../../../remote/exception/api_error_handler.dart';

class NotificationRepo {
  final DioClient? dioClient;

  NotificationRepo({required this.dioClient});

  Future<ApiResponseModel> getNotificationList() async {
    try {
      final response = await dioClient!.get(AppConstants.notificationUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
