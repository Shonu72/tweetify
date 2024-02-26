import 'package:flutter/material.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/auth/view/login_view.dart';
import 'package:tweetify/features/auth/view/signup_view.dart';
import 'package:tweetify/features/home/views/home_views.dart';
import 'package:tweetify/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tweetify',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) => user != null ? HomeView() : LoginView(),
            loading: () => const LoadingPage(),
            error: (e, s) => ErrorPage(errorText: e.toString()),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}
