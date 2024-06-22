import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/models/transition_model.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:expenses_test_app/widgets/add_transaction.dart';
import 'package:expenses_test_app/widgets/card_transaction.dart';
import 'package:expenses_test_app/widgets/info_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? controller;
  bool seeAll = false;
  TextEditingController dateController = TextEditingController();

  closeBottomSheet() {
    controller?.close();
    setState(() {
      controller = null;
    });
  }

  handleToggleSeeAll() {
    setState(() {
      seeAll = !seeAll;
    });
    if (!seeAll) {
      dateController.clear();
    }
  }

// box hive - to Store the money
  Box? safe;
  // box hive - To Store date in it
  Box? transactions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Create Balance or Safe box
    Future.delayed(Duration.zero, () async {
      final balance = await Hive.openBox("safe_box");
      final valBalnace = balance.get("balance");
      if (valBalnace == null) {
        balance.put("balance", 0);
      }
      setState(() {
        safe = balance;
      });
    });

    // Create Transaction Box

    Hive.openBox("transactions_box").then((box) => {
          setState(() {
            transactions = box;
          })
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
          if (!seeAll)
            InfoAccount(
              boxSafe: safe,
              boxTransactions: transactions,
            ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transactions",
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: handleToggleSeeAll,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                        color: kBlack, borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "See ${seeAll ? "Today Only" : "All"}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (seeAll)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              child: TextFormField(
                style: TextStyle(color: kBlackThree.withOpacity(0.8)),
                controller: dateController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Sorry, The Date is Required";
                  } else if (DateTime.parse(value).compareTo(
                          DateTime.parse(formatDate(DateTime.now()))) >
                      0) {
                    return "Sorry, Can Not Select Date In Future";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: "Date",
                    hintText: DateTime.now().toString(),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlack)),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: kBlack,
                    )),
                onTap: () {
                  _selectDate();
                },
                readOnly: true,
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 10,
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
          // final transactionsKeys = box.keys.toList();
          final transactionsAll = box.values.toList();
          final transactionsFilterDate = box.values.where((element) {
            // print(element["date"]);
            // return element;

            return DateTime.parse(element["date"])
                    .compareTo(DateTime.parse(formatDate(DateTime.now()))) ==
                0;
          }).toList();
          final transactionsFilterSelectedDate = dateController.text.isEmpty
              ? transactionsFilterDate
              : box.values.where((element) {
                  //print(element["date"]);
                  // return element;

                  return DateTime.parse(element["date"])
                          .compareTo(DateTime.parse(dateController.text)) ==
                      0;
                }).toList();
          // print(transactionsFilterDate);
          final transactions = dateController.text.isEmpty && seeAll
              ? transactionsAll
              : dateController.text.isEmpty && !seeAll
                  ? transactionsFilterDate
                  : transactionsFilterSelectedDate;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              //late final Map transaction = box.get(transactionsKeys[index]);
              //if ( DateTime.parse(formatDate(transaction["date"])).compareTo(formatDate(DateTime.now()) == 0) )

              return Column(
                children: [
                  // if (DateTime.parse(transactions[index - (index == 0 ? 0 : 1)]
                  //             ["date"])
                  //         .compareTo(
                  //             DateTime.parse(transactions[index]["date"])) ==
                  //     1)
                  //   Text(
                  //     transactions[index]["date"],
                  //     style: TextStyle(color: kBlack),
                  //   ),
                  //====================== With List ==========================
                  CardTransaction(
                    typeTransaction:
                        transactions[index]["type_transaction"] == "expense"
                            ? TypeTranscation.expense
                            : TypeTranscation.income,
                    title: transactions[index]["title"],
                    value: int.parse(transactions[index]["value"]),
                    date: DateTime.parse(transactions[index]["date"]),
                    description: transactions[index]["note"],
                  ),

                  //========================= With MAP ===========================================
                  // CardTransaction(
                  //   typeTransaction:
                  //       transaction["type_transaction"] == "expense"
                  //           ? TypeTranscation.expense
                  //           : TypeTranscation.income,
                  //   title: transaction["title"],
                  //   value: int.parse(transaction["value"]),
                  //   date: DateTime.parse(transaction["date"]),
                  //   description: transaction["note"],
                  // ),
                ],
              );
            },
          );
        });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );
    if (picked != null) {
      setState(() {
        // print("=============================================================");
        // print(formatDate(picked));
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}

// CardTransaction(
//               typeTransaction: TypeTranscation.income,
//               title: "Test",
//               description: "test description",
//               value: 2000,
//               date: DateTime.now(),
//             ),
