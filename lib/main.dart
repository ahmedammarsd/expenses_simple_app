import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/home.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // ============== Config Hive ==============
  WidgetsFlutterBinding.ensureInitialized();
  // it return a path to directory where aplication may place data that is user generated
  final documentsDir = await getApplicationDocumentsDirectory();
  Hive.init(documentsDir.path);

  // ============== Config Hive ==============

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: kWhite,
            ), //to Change the primary color of text
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade500,
        ),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
