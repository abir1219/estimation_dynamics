import 'package:estimation_dynamics/core/network/network_api_services.dart';

import '../../../../core/constants/api_end_points.dart';

class EstimationRepository{
  final _apiClient = NetworkApiService();

  Future<dynamic> generateEstimateNo(var body, var header) async{
    return await _apiClient.postApi(ApiEndPoints.BASE_URL, body, header);
  }

  Future<dynamic> fetchSalesmanList(var body, var header) async{
    return await _apiClient.postApi(ApiEndPoints.BASE_URL, body, header);
  }
}