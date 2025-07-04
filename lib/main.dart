import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://your-graphql-endpoint.com/graphql');
    
    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    return GraphQLProvider(
      client: ValueNotifier(client),
      child: MaterialApp(
        title: 'Sociocube Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 