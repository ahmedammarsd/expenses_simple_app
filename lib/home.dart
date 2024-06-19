import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/widgets/add_transaction.dart';
import 'package:expenses_test_app/widgets/card_transaction.dart';
import 'package:expenses_test_app/widgets/info_account.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? controller;

  closeBottomSheet() {
    controller?.close();
    setState(() {
      controller = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: kBlack,
        title: const Text(
          "Welcome, Snhoory",
          style: TextStyle(fontSize: 14),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller == null
            ? // open bottom Sheet
            {
                controller = _key.currentState!
                    .showBottomSheet((context) => AddTransaction(
                          updateControllerInHomeToClose: closeBottomSheet,
                        )),
                setState(() {})
              }
            : // close bottom Sheet
            {
                controller?.close(),
                setState(() {
                  controller = null;
                })
              },
        backgroundColor: kBlack,
        elevation: 0,
        child: Icon(controller == null ? Icons.add : Icons.close),
      ),
      body: Column(
        children: [
          const InfoAccount(),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(3),
            width: double.infinity,
            child: CardTransaction(
              typeTransaction: TypeTranscation.income,
              title: "Test",
              description: "test description",
              value: 2000,
              date: DateTime.now(),
            ),
          ),
        ],
      ),
    );
  }
}
