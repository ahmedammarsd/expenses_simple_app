import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/widgets/add_transaction.dart';
import 'package:expenses_test_app/widgets/card_transaction.dart';
import 'package:expenses_test_app/widgets/info_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

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

// box hive - to Store the money
  Box? safe;
  // box hive - To Store date in it
  Box? transactions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Hive.openBox("safe_box").then((box) => {
          setState(() {
            safe = box;
          })
        });

    Hive.openBox("transactions_box").then((box) => {
          setState(() {
            transactions = box;
          })
        });

    // initBoxs() async {
    //   var boxSafe = await Hive.openBox("safe_box");
    //   setState(() {
    //     safe = boxSafe;
    //   });

    //   var boxTransactions = await Hive.openBox("transactions_box");
    //   setState(() {
    //     transactions = boxTransactions;
    //   });
    // }
    // initBoxs();
    // initSafe();
  }

  // initSafe() async {
  //     if (safe == null) {
  //      await safe?.add({"balance": 0});
  //       print("============================");
  //     }
  //  else {
  //   print("=====================================");
  //   print(safe?.get(0)["balance"]);
  // }
  //await safe?.clear();
  //}

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
                          boxHive: transactions,
                          safe: safe,
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
          InfoAccount(
            boxSafe: safe,
            boxTransactions: transactions,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(3),
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 20,
                child: _buildUICardTransactions()),
          ),
        ],
      ),
    );
  }

  Widget _buildUICardTransactions() {
    if (transactions == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (transactions!.keys.toList().isEmpty) {
      return Center(
        child: Text(
          "No Transactios",
          style: TextStyle(color: kBlack),
        ),
      );
    }
    return ValueListenableBuilder(
        valueListenable: transactions!.listenable(),
        builder: (context, box, widget) {
          final transactionsKeys = box.keys.toList();

          return ListView.builder(
            itemCount: transactionsKeys.length,
            itemBuilder: (context, index) {
              Map transaction = transactions!.get(transactionsKeys[index]);

              return CardTransaction(
                typeTransaction: transaction["type_transaction"] == "expense"
                    ? TypeTranscation.expense
                    : TypeTranscation.income,
                title: transaction["title"],
                value: int.parse(transaction["value"]),
                date: DateTime.parse(transaction["date"]),
                description: transaction["note"],
              );
            },
          );
        });
  }
}


// CardTransaction(
//               typeTransaction: TypeTranscation.income,
//               title: "Test",
//               description: "test description",
//               value: 2000,
//               date: DateTime.now(),
//             ),