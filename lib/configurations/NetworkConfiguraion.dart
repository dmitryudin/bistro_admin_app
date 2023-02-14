class NetworkConfiguration {
  Map<String, String> _controllersTable = {
    'login': '/v1/auth/login',
    'register': '/v1/admin/create',
    'refresh_access_token': '/v1/auth/refresh_access_token',
    'get_admin_information': '/v1/admin/get_profile',
    'get_place_information': '/v1/place/get',
    'update_place_information': '/v1/place/update'
  };
  String basicUrl = 'http://localhost:8080';

  String getAddress(String key) {
    return basicUrl + _controllersTable[key]!;
  }
}
