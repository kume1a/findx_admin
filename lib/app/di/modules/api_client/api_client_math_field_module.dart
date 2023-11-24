import 'package:findx_dart_client/app_client.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiClientMathFieldModule {
  @lazySingleton
  MathFieldRemoteRepository mathFieldRemoteRepository(GraphQLClient client) {
    return ApiMathFieldRemoteRepository(client);
  }
}
