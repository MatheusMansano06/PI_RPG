import '../core/network/api_client.dart';
import '../models/ambiente_model.dart';

class AmbienteService {
  AmbienteService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AmbienteModel>> buscarAmbientes() async {
    final data = await _apiClient.get('/ambientes');
    final items = _extractList(data);

    return items
        .whereType<Map>()
        .map((item) => AmbienteModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map) {
      final ambientes = data['ambientes'];
      if (ambientes is List) {
        return ambientes;
      }
    }
    return const [];
  }
}
