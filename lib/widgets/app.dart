import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/router.dart';
import '../config/theme.dart';
import '../providers/graphql.dart';

class AppWidget extends HookWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => AppRouter.createRouter(), []);

    return Consumer(
      builder: (context, ref, child) {
        final client = ref.watch(graphQLClientProvider);
        
        return GraphQLProvider(
          client: ValueNotifier(client),
          child: MaterialApp.router(
            title: 'Sociocube',
            theme: ThemeConfig.theme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
} 