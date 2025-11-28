import '../../../core/constants/api_end_points.dart';
import '../../../core/network/network_api_services.dart';

class RecallRepository{
  final _apiClient = NetworkApiService();

  Future<dynamic> recallEstimation(var body, var header) async{
    return await _apiClient.postApi(ApiEndPoints.BASE_URL, body, header);
  }
}