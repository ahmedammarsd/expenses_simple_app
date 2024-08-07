import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction(
      {super.key,
      required this.updateControllerInHomeToClose,
      this.boxHive,
      this.safe});
  final void Function() updateControllerInHomeToClose;
  final Box? boxHive;
  final Box? safe;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  // ==================================
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode =
      AutovalidateMode.always; // to Work Validation like OnChange
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isExpenses = true;

  List typeTrans = ["income", "expense"];
  int selectedType = 1;

  // ==================================

  // ====== Get Box Name =============
  Box id = Hive.box("id");
  late int getId = id.get("id");

// ====== Get Box Name =============

  //============================
  double currentBalance = 0;
  getCurrentBalance() async {
    var safe = await widget.safe!.get("balance");
    // currentBalance = safe["balance"];
    // print("========================current balance==========================");
    // print(currentBalance);
    setState(() {
      currentBalance = safe;
    });
  }

  //============================

  toggleTypeTransaction(int value) {
    setState(() {
      //  isExpenses = value;
      selectedType = value;
      //print(typeTrans[value]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController.text = formatDate(DateTime.now());
    _selectDate();
    getCurrentBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: kBlack))),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Title",
                    //   style: TextStyle(fontSize: 16, color: kBlack),
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: TextStyle(color: kBlackThree.withOpacity(0.8)),
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Sorry The Title is Required";
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "The Title",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBlack)),
                          prefixIcon: Icon(
                            Icons.title_rounded,
                            color: kBlack,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(color: kBlackThree.withOpacity(0.8)),
                      controller: valueController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Sorry, The Value is Required";
                        } else if (double.parse(value) < 0) {
                          return "Sorry, The Value Can't be 0 or Smoller Than it";
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Value",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBlack)),
                          prefixIcon: Icon(
                            Icons.money,
                            color: kBlack,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
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
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        tabText("Income", 0),
                        const SizedBox(
                          width: 15,
                        ),
                        tabText("Expenses", 1),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(color: kBlackThree.withOpacity(0.8)),
                      controller: descriptionController,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "Sorry The Title is Required";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Note or Description",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBlack)),
                          prefixIcon: Icon(
                            Icons.note_rounded,
                            color: kBlack,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await widget.boxHive?.add({
                                "id": getId,
                                "title": titleController.text,
                                "value": valueController.text,
                                "date": dateController.text,
                                "type_transaction": typeTrans[selectedType],
                                "note": descriptionController.text,
                              });
                              if (typeTrans[selectedType] == "income") {
                                await widget.safe?.put(
                                    "balance",
                                    (currentBalance +
                                        int.parse(valueController.text)));
                                // print("========================");
                                // print(widget.safe!.get("balance"));
                                //print(val);
                                // print("========================");
                              } else {
                                await widget.safe?.put(
                                    "balance",
                                    (currentBalance -
                                        int.parse(valueController.text)));
                              }
                              // if (widget.safe == null) {
                              //   widget.safe!
                              //       .add({"safe", valueController.text});
                              // } else {
                              //   Map valueOfSafe = widget.safe!.get(0);
                              //   await widget.safe!.put(
                              //       "safe",
                              //       (double.parse(valueOfSafe["safe"]) +
                              //           double.parse(valueController.text)));
                              // }
                              widget.updateControllerInHomeToClose();
                              id.put("id", (getId + 1));

                              //Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kBlack,
                              padding: const EdgeInsets.all(15)),
                          child: const Text("Add Transaction"),
                        ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  Widget tabText(String text, index) {
    return InkWell(
      onTap: () {
        toggleTypeTransaction(index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: index == selectedType ? kBlack : kBlackThree.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: index == selectedType ? kWhite : kBlack,
          ),
        ),
      ),
    );
  }
}
