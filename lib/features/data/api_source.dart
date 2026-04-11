import 'package:dio/dio.dart';
import 'package:graphql/client.dart';

import '../../core/constants/constants.dart';
import '../../core/services/local_storage.dart';

class GraphQLAPI {
  GraphQLClient getGraphQLClient() {
    final authLink = AuthLink(
      getToken: () async {
        final token = await LocalStorage().getToken();
        return token != null ? 'Bearer $token' : null;
      },
    ).concat(HttpLink(Constants.stagingUrl));

    return GraphQLClient(
      cache: GraphQLCache(),
      link: authLink,
    );
  }
}

final api = Dio(
  BaseOptions(
    baseUrl: Constants.stagingUrl,
    contentType: "application/json",
  ),
);

Dio get dio {
  Dio dio = Dio();
  // set base url
  dio.options.baseUrl = Constants.stagingUrl;
  return dio;
}
