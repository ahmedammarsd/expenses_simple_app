import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/widgets/info_account.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
      ),
      body: const Column(
        children: [
          InfoAccount(),
        ],
      ),
    );
  }
}
