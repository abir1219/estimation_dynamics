import 'package:estimation_dynamics/core/network/network_api_services.dart';

import '../../../core/constants/api_end_points.dart';

class CustomerRepository {
  final _apiClient = NetworkApiService();

  Future<dynamic> fetchCustomer(var body, var header) async {
    return await _apiClient.postApi(ApiEndPoints.BASE_URL, body, header);
  }
}
