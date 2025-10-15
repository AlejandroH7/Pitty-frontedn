class ApiService {
  ApiService({required this.baseUrl});

  final String baseUrl;

  Future<void> get(String endpoint) {
    throw UnimplementedError('ApiService.get is not implemented.');
  }

  Future<void> post(String endpoint, Map<String, dynamic> body) {
    throw UnimplementedError('ApiService.post is not implemented.');
  }
}
