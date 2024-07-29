import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:expenses_test_app/colors/colors.dart';

import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:expenses_test_app/widgets/add_transaction.dart';
import 'package:expenses_test_app/widgets/card_transaction.dart';
import 'package:expenses_test_app/widgets/info_account.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  Box? name;
// box hive - to Store the money
  Box? safe;
  // box hive - To Store date in it
  Box? transactions;

  // box hive - ID
  Box? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Create Name Box
    Future.delayed(Duration.zero, () async {
      final nameBox = await Hive.openBox("name_user");
      final getName = nameBox.get("name");
      if (getName == null) {
        nameBox.put("name", "no nameee");
      }
      setState(() {
        name = nameBox;
      });
    });

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

    // Create Id Box
    Future.delayed(Duration.zero, () async {
      final idBox = await Hive.openBox("id");
      final getId = idBox.get("id");
      if (getId == null) {
        idBox.put("id", 1);
      }
      setState(() {
        id = idBox;
      });
    });
  }

  double currentBalance = 0;
  getCurrentBalance() async {
    var getBlan = await safe!.get("balance");
    setState(() {
      currentBalance = getBlan;
    });
  }

  handleDeleteTransaction(int index, String type, int value) async {
    // final gitIndexTransactionById = await box
    //                                       .values
    //                                       .toList()
    //                                       .indexWhere((element) =>
    //                                           element["id"] ==
    //                                           transactions[index]["id"]);
    //                                   print(gitIndexTransactionById);
    final gitIndexTransactionById = await transactions!.values
        .toList()
        .indexWhere((element) => element["id"] == index);

    await getCurrentBalance();
    await transactions!.deleteAt(gitIndexTransactionById);

    if (type == "income") {
      await safe?.put("balance", (currentBalance - value));
    } else {
      await safe?.put("balance", (currentBalance + value));
    }
  }

  // Future<bool> requestPermissions() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     var result = await Permission.storage.request();
  //     return result.isGranted;
  //   }
  //   return true;
  // }

  String? csvFile;
  final transactionsArrayForConvertCsv = [
    ["Title", "Value", "Date", "Type Transaction", "description"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: kBlack,
        title: welcomeUser(),
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
          // if (!seeAll)
          AnimatedScale(
            scale: seeAll ? 0 : 1,
            duration: const Duration(milliseconds: 1000),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInBack,
              switchOutCurve: Curves.easeInOut,
              child: !seeAll
                  ? InfoAccount(
                      boxSafe: safe,
                      boxTransactions: transactions,
                    )
                  : null,
            ),
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
            height: 5,
          ),
          if (seeAll && dateController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                dateController.clear();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: kBlackThree.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Clear Date",
                        style: TextStyle(color: kBlack),
                      ),
                    ),
                  ],
                ),
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
          // print(transactionsKeys);
          final transactionsAll = box.values.toList();

          // print(transactionsAll.indexOf((element) =>
          //     DateTime.parse(element["date"])
          //         .compareTo(DateTime.parse(formatDate(DateTime.now()))) ==
          //     0));
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
          transactionsArrayForConvertCsv.removeRange(
              1, transactionsArrayForConvertCsv.length);
          for (int i = 0; i < transactions.length; i++) {
            /// ============== Add to Csv file ===================
            transactionsArrayForConvertCsv.add([
              transactions[i]["title"],
              transactions[i]["value"],
              transactions[i]["date"],
              transactions[i]["type_transaction"],
              transactions[i]["note"]
            ]);

            /// ============== Add to Csv file ===================
          }

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    // late final Map transaction = box.get(transactionsKeys[index]);

                    // print(transaction);
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
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Information Transaction",
                                      style: TextStyle(
                                          color: kBlack,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    content: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Title: ${transactions[index]["title"]}",
                                            style: TextStyle(
                                                color: kBlack,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Date: ${transactions[index]["date"]}",
                                            style: TextStyle(
                                                color: kBlack,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  transactions[index][
                                                              "type_transaction"] ==
                                                          "expense"
                                                      ? "assets/icons/up.svg"
                                                      : "assets/icons/down.svg",
                                                  width: 20,
                                                  height: 20,
                                                  color: transactions[index][
                                                              "type_transaction"] ==
                                                          "expense"
                                                      ? Colors.red.shade500
                                                      : Colors.green.shade500,
                                                ),
                                                // Text(
                                                //   "${transactions[index]["type_transaction"]}",
                                                //   style: TextStyle(
                                                //       color: kBlack),
                                                // ),
                                                Text(
                                                  formatCaurrncy(int.parse(
                                                      transactions[index]
                                                          ["value"])),
                                                  style: TextStyle(
                                                    color: transactions[index][
                                                                "type_transaction"] ==
                                                            "expense"
                                                        ? Colors.red.shade500
                                                        : Colors.green.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Description: ${transactions[index]["note"]}",
                                            style: TextStyle(color: kBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            backgroundColor:
                                                Colors.red.shade500),
                                        child: Text("Back"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          onDoubleTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Delete Transaction",
                                      style: TextStyle(color: kBlack),
                                    ),
                                    content: Text(
                                      "Are You Sure want to delete : ${transactions[index]["title"]} ?",
                                      style: TextStyle(color: kBlack),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              backgroundColor:
                                                  Colors.red.shade500),
                                          onPressed: () async {
                                            // final gitIndexTransactionById = await box
                                            //     .values
                                            //     .toList()
                                            //     .indexWhere((element) =>
                                            //         element["id"] ==
                                            //         transactions[index]["id"]);
                                            // print(gitIndexTransactionById);
                                            handleDeleteTransaction(
                                                transactions[index]["id"],
                                                transactions[index]
                                                    ["type_transaction"],
                                                int.parse(transactions[index]
                                                    ["value"]));
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Delete",
                                          ))
                                    ],
                                  );
                                });
                          },
                          typeTransaction: transactions[index]
                                      ["type_transaction"] ==
                                  "expense"
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
                ),
              ),
              if (seeAll)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            //  print("===========loading==========");

                            try {
                              String csv = const ListToCsvConverter()
                                  .convert(transactionsArrayForConvertCsv);
                              Uint8List bytes =
                                  Uint8List.fromList(utf8.encode(csv));

                              var path =
                                  "/storage/emulated/0/Download/expenses-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.csv";
                              var file = File(path);
                              file.writeAsBytes(bytes);
                              // // Get the directory to save the file
                              // final directory =
                              //     await getExternalStorageDirectory();
                              // final path = directory?.path ?? '';
                              // final filePath = '$path/sample_data.csv';

                              // // Write CSV data to file
                              // final file = File(filePath);
                              // await file.writeAsString(csv);

                              // print('CSV file saved at $filePath');

                              // ========== Not Working ===============
                              //This will download the file on the device.
                              // await FileSaver.instance.saveFile(
                              //   name:
                              //       'file_test', // you can give the CSV file name here.
                              //   bytes: bytes,
                              //   ext: 'csv',
                              //   mimeType: MimeType.csv,
                              // );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Download Successfully"),
                                backgroundColor: Colors.green.shade500,
                                padding: const EdgeInsets.all(20),
                              ));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Sorry,Error in Download -Please Call To Developer"),
                                backgroundColor: Colors.red.shade500,
                                padding: const EdgeInsets.all(20),
                              ));
                              print(e);
                            }
                            //  print("===========loading Finish==========");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kBlack,
                              padding: const EdgeInsets.all(15)),
                          child: Text("Export & Download To Csv")),
                    ),
                  ],
                ),
              SizedBox(
                height: 80,
              ),
            ],
          );
        });
  }

  Widget welcomeUser() {
    if (name == null) {
      return CircularProgressIndicator(
        color: kWhite,
      );
    }
    return ValueListenableBuilder(
        valueListenable: name!.listenable(),
        builder: (context, box, widget) {
          String nameUser = box.get("name");
          return Text(
            "Welcome, $nameUser",
            style: const TextStyle(fontSize: 13),
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
