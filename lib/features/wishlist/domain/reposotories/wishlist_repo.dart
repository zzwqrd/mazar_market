import 'package:mazar_marke/common/models/api_response_model.dart';
import 'package:mazar_marke/utill/app_constants.dart';

import '../../../../remote/dio/dio_client.dart';
import '../../../../remote/exception/api_error_handler.dart';

class WishListRepo {
  final DioClient? dioClient;

  WishListRepo({required this.dioClient});

  Future<ApiResponseModel> getWishList() async {
    try {
      final response = await dioClient!.get(AppConstants.wishListUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> addWishList(List<int?> productID) async {
    try {
      final response = await dioClient!
          .post(AppConstants.wishListUri, data: {'product_ids': productID});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> removeWishList(List<int?> productID) async {
    try {
      final response = await dioClient!.delete(AppConstants.wishListUri,
          data: {'product_ids': productID, '_method': 'delete'});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
