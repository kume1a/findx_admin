import 'package:findx_dart_client/app_client.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiClientMathSubFieldModule {
  @lazySingleton
  MathSubFieldRemoteRepository mathSubFieldRemoteRepository(GraphQLClient client) {
    return ApiMathSubFieldRemoteRepository(client);
  }
}
