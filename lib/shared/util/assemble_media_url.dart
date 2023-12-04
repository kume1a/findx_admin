import '../../app/app_environment.dart';

String assembleResourceUrl(String? path) {
  return path != null ? '${AppEnvironment.apiUrl}/$path' : '';
}
