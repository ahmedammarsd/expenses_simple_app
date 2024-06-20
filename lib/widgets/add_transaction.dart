import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  //============================
  int currentBalance = 0;
  getCurrentBalance() {
    late final totalBalanceSafe = widget.safe!.keys.toList();

    if (widget.safe != null) {
      var safe = widget.safe?.get(0);
      // currentBalance = safe["balance"];
      print(
          "========================current balance==========================");
      print(currentBalance);
      setState(() {
        currentBalance = int.parse(safe["balance"]);
      });
    }
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
                          return "Sorry, The Value is Smoller Than 0 ";
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
                                "title": titleController.text,
                                "value": valueController.text,
                                "date": dateController.text,
                                "type_transaction": typeTrans[selectedType],
                                "note": descriptionController.text,
                              });
                              if (typeTrans[selectedType] == "income") {
                                await widget.safe?.put(0, {
                                  "balance": (currentBalance +
                                      double.parse(valueController.text))
                                });
                                print("========================");
                                print(widget.safe!.get(0));
                                //print(val);
                                // print("========================");
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
