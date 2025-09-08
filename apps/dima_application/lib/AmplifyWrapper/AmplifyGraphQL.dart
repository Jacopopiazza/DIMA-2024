import 'package:amplify_flutter/amplify_flutter.dart';

class AmplifyGraphQL {
  // Define your GraphQL queries and mutations here

  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) {
    safePrint("[AmplifyGraphQL] Executing query via proxy class...");
    return Amplify.API.query(request: request);
  }

  GraphQLOperation<T> mutate<T>({required GraphQLRequest<T> request}) {
    return Amplify.API.mutate(request: request);
  }

  Stream<GraphQLResponse<T>> subscribe<T>(GraphQLRequest<T> request,
      {void Function()? onEstablished}) {
    return Amplify.API.subscribe(request);
  }
}
