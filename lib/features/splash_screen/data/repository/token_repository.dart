import 'package:estimation_dynamics/core/constants/api_end_points.dart';
import 'package:estimation_dynamics/core/network/network_api_services.dart';

class TokenRepository {
  final _apiClient = NetworkApiService();

  Future<dynamic> fetchTokenData(var data) async {
    return await _apiClient.fetchTokenApi(ApiEndPoints.authEndpoints.fetchToken, data);
  }
}
