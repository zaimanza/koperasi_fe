import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_object/pages/start_page.dart';
import 'package:test_object/providers/store_provider.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(storeProvider).initState();

    return MaterialApp(
      title: 'Kedai Siswa Uitm Dungun',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
