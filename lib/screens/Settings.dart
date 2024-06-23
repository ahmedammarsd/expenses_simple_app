import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/widgets/items_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

TextEditingController nameUser = TextEditingController();

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget updateNameUser() {
    return AlertDialog(
      content: TextField(
        style: TextStyle(color: kBlackThree.withOpacity(0.8)),
        controller: nameUser,
        decoration: InputDecoration(
          labelText: "Name",
          border: const OutlineInputBorder(),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kBlack)),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      backgroundColor: Colors.green.shade500),
                  onPressed: () {
                    Navigator.of(context).pop();
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
}
