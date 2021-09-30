import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:smash_app/constants/theme.dart';
import 'package:smash_app/pages/home.dart';
import 'package:smash_app/pages/login.dart';
import 'package:smash_app/services/db.dart';
import 'package:smash_app/services/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool debugMode = true;
  if (debugMode) Paint.enableDithering = true;

  final database = await SmashAppDatabase().intializedDB();

  ValueNotifier<GraphQLClient> client = initializeClient();

  runApp(
    GraphQLProvider(
      client: client,
      child: ProviderScope(
        child: MyApp(),
        overrides: [
          dbProvider.overrideWithValue(database),
        ],
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smash App',
      theme: appTheme(context),
      home: Login(),
    );
  }
}

ValueNotifier<GraphQLClient> initializeClient() {
  final HttpLink httpLink = HttpLink('https://api.smash.gg/gql/alpha');

  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer 97f95303965bc5182e03797f7943332c',
  );

  final Link link = authLink.concat(httpLink);

  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ),
  );
  return client;
}
