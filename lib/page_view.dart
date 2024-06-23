import 'package:expenses_test_app/screens/Settings.dart';
import 'package:expenses_test_app/screens/home.dart';

import 'package:flutter/material.dart';

class PageVieww extends StatelessWidget {
  const PageVieww({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          HomePage(),
          Settings(),
        ],
      ),
    );
  }
}
