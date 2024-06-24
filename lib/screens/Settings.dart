import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/widgets/items_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode =
      AutovalidateMode.always; // to Work Validation like OnChange
  TextEditingController nameUserController = TextEditingController();

// ====== Get Box Name =============
  final nameBox = Hive.box("name_user");
// ====== Get Box Name =============

  updateName(String newName) async {
    await nameBox.put("name", newName);
  }

  handleClearData() {
    Hive.box("transactions_box").clear();
    var box = Hive.box("safe_box");
    box.put("balance", 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 13),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ItemSettings(
              icon: const Icon(Icons.title),
              title: "Change The Name",
              onTap: () {
                showDialog(
                    context: context, builder: (context) => updateNameUser());
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ItemSettings(
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade500,
              ),
              title: "Clear Transactions Data",
              onTap: () {
                showDialog(context: context, builder: (context) => clearData());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget updateNameUser() {
    return AlertDialog(
      title: Text(
        "Change Name",
        style: TextStyle(color: kBlack),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(color: kBlackThree.withOpacity(0.8)),
          controller: nameUserController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Name is Required";
            } else if (value.length <= 2) {
              return "Name is Not Valid";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "Name",
            border: const OutlineInputBorder(),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: kBlack)),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      backgroundColor: Colors.green.shade500),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateName(nameUserController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Update",
                  )),
            ),
          ],
        )
      ],
    );
  }

  Widget clearData() {
    return AlertDialog(
      title: Text(
        "Clear Data",
        style: TextStyle(color: kBlack),
      ),
      content: Text(
        "Are You Sure To Delete Or Clear All Data ?",
        style: TextStyle(
          color: kBlack,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      backgroundColor: Colors.red.shade500),
                  onPressed: () {
                    handleClearData();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Confirm Delete",
                  )),
            ),
          ],
        )
      ],
    );
  }
}
