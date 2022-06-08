import 'package:dio/dio.dart';
import 'package:graphql/client.dart';

import '../../core/constants/constants.dart';

class GraphQLAPI {
  final authLink = AuthLink(
    getToken: () async => 'Bearer \$YOUR_PERSONAL_ACCESS_TOKEN',
  ).concat(HttpLink(Constants.stagingUrl));

  GraphQLClient getGraphQLClient() {
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
