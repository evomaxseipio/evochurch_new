// lib/src/shared/providers/api_client_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/http_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

