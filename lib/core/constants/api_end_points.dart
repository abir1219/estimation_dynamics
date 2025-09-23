import 'package:estimation_dynamics/core/constants/app_constants.dart';
import 'package:estimation_dynamics/core/utils/constant_variable.dart';

class ApiEndPoints {
  // static const LOGIN_BASE_URL = "http://cloud24k.com/api/";

  /*static final CLIENT_SOCKE_URL = "ws://12.0.1.4:8085/ws/online-users/?device_id";
  static final TEST_SOCKE_URL = "ws://192.168.1.189:8001/ws/online-users/?device_id";

  static final SOCKET_BASE_URL = CLIENT_SOCKE_URL;*/


  // static final TEST_URL =
  //     // "http://crownestapi.cloud24k.com/api/estimations/";
  //     // "http://192.168.1.177:8000/api/estimations/"; // Saibal Local
  //     "http://192.168.1.189:8001/api/estimations/"; // Azam Local
  // static final CLIENT_URL =
  //     "https://login.microsoftonline.com/09cd7d48-0a57-4448-9761-d642d23cf037/oauth2/token";
  // static final BASE_URL =
  //     CLIENT_URL;
  // static const BASE_URL = "https://scu6bep8f7414799839-rs.su.retail.dynamics.com/Commerce/RestApiV1/ExecuteGenericOperation";
  static final String BASE_URL = ConstantVariable.retailServerURL;

  static _ApiEndPoints authEndpoints = _ApiEndPoints();
}

class _ApiEndPoints {
  final String fetchToken = "https://login.microsoftonline.com/${AppConstants.TENANT_ID}/oauth2/token";
}
