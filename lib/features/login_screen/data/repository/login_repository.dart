import 'package:estimation_dynamics/core/constants/api_end_points.dart';
import 'package:estimation_dynamics/core/network/network_api_services.dart';

class LoginRepository{
  final _apiClient = NetworkApiService();

  Future<dynamic> fetchApiCall(var body, var header)async{
    return await _apiClient.postApi(ApiEndPoints.BASE_URL, body, header);
  }
}