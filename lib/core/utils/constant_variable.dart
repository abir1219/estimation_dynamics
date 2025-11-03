class ConstantVariable {
  // Environment options
  static const String ENV_DEV = "DEV";
  static const String ENV_UAT = "UAT";
  static const String ENV_PROD = "PROD";

  // Set your current environment here
  static const String currentEnv = ENV_UAT;

  // ---- DEV Environment ----
  static const String _devClientId = "e7db77ef-e2a5-4aea-9257-3db5bcfb76d5";
  static const String _devClientSecret = "Js~8Q~9Sx39gnjrOCan.SIp4LdpKij1cY2-gicpu";
  static const String _devGrantType = "client_credentials";
  static const String _devResource = "api://f2482f98-b71f-4bb0-bca4-bcc397899116";
  static const String _devRetailServerURL =
      "https://dev-04-new5eeb706e7f629708devret.axcloud.dynamics.com/RetailServer/Commerce/RestApiV1/ExecuteGenericOperation";
  static const String _devOperatingUnitNumber = "087";
  static const String _devTenantId = "09cd7d48-0a57-4448-9761-d642d23cf037";
  static const String _devRefType = "11";

  // ---- UAT Environment ----
  static const String _uatClientId = "e7494539-4a0c-491b-9e19-3997ba512383";
  static const String _uatClientSecret = "C2h8Q~n.DwfrzSyOJNbaMqT41WDGpUjAHBstYdlT";
  static const String _uatGrantType = "client_credentials";
  static const String _uatResource = "api://f713e5ea-8045-472a-9095-9277d7418750";
  static const String _uatRetailServerURL =
      "https://scu6bep8f7414799839-rs.su.retail.dynamics.com/Commerce/RestApiV1/ExecuteGenericOperation";
  static const String _uatOperatingUnitNumber = "1003ST";
  static const String _uatTenantId = "09cd7d48-0a57-4448-9761-d642d23cf037";
  static const String _uatRefType = "11";

  // ---- PROD Environment ----
  static const String _prodClientId = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
  static const String _prodClientSecret = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy";
  static const String _prodGrantType = "client_credentials";
  static const String _prodResource = "api://prod-resource-id";
  static const String _prodRetailServerURL =
      "https://prod-retailserver.axcloud.dynamics.com/RetailServer/Commerce/RestApiV1/ExecuteGenericOperation";
  static const String _prodOperatingUnitNumber = "089";
  static const String _prodTenantId = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
  static const String _prodRefType = "11";

  // ---- Common getters (auto-switch by env) ----
  static String get clientId => _getEnvValue(_devClientId, _uatClientId, _prodClientId);
  static String get clientSecret => _getEnvValue(_devClientSecret, _uatClientSecret, _prodClientSecret);
  static String get grantType => _getEnvValue(_devGrantType, _uatGrantType, _prodGrantType);
  static String get resource => _getEnvValue(_devResource, _uatResource, _prodResource);
  static String get retailServerURL => _getEnvValue(_devRetailServerURL, _uatRetailServerURL, _prodRetailServerURL);
  static String get operatingUnitNumber => _getEnvValue(_devOperatingUnitNumber, _uatOperatingUnitNumber, _prodOperatingUnitNumber);
  static String get tenantId => _getEnvValue(_devTenantId, _uatTenantId, _prodTenantId);
  static String get refType => _getEnvValue(_devRefType, _uatRefType, _prodRefType);

  // ---- Helper Method ----
  static String _getEnvValue(String dev, String uat, String prod) {
    switch (currentEnv) {
      case ENV_UAT:
        return uat;
      case ENV_PROD:
        return prod;
      default:
        return dev;
    }
  }
}
