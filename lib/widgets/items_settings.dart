import 'package:expenses_test_app/colors/colors.dart';
import 'package:flutter/material.dart';

class ItemSettings extends StatelessWidget {
  const ItemSettings(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  final Icon icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: kWhiteTwo.withOpacity(0.3),
          border: Border(
            bottom: BorderSide(
              color: kBlack.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: kBlack,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
