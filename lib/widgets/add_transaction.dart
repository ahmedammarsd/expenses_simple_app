import 'package:expenses_test_app/colors/colors.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction(
      {super.key, required this.updateControllerInHomeToClose});
  final void Function() updateControllerInHomeToClose;

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
  // ==================================

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
                      height: 10,
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
                          return "Sorry The Value is Required";
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
                          return "Sorry The Date is Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Date",
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
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
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
