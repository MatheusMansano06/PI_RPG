import '../core/network/api_client.dart';

class LocationCheckService {
  LocationCheckService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> verificarLocalizacao({
    required double latitude,
    required double longitude,
  }) async {
    final data = await _apiClient.post('/location/check', {
      'latitude': latitude,
      'longitude': longitude,
    });

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'resultado': data?.toString() ?? 'Sem resposta'};
  }
}
