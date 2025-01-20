import '../../remote/dio/dio_client.dart';
import '../../remote/exception/api_error_handler.dart';
import '../../utill/app_constants.dart';
import '../models/api_response_model.dart';

class NewsLetterRepo {
  final DioClient? dioClient;

  NewsLetterRepo({required this.dioClient});

  Future<ApiResponseModel> addToNewsLetter(String email) async {
    try {
      final response = await dioClient!
          .post(AppConstants.emailSubscribeUri, data: {'email': email});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
