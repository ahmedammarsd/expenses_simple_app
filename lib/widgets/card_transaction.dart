import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardTransaction extends StatelessWidget {
  const CardTransaction({
    super.key,
    required this.typeTransaction,
    required this.title,
    this.description = "",
    required this.value,
    required this.date,
    required this.onDoubleTap,
    required this.onTap,
  });
  final TypeTranscation typeTransaction;
  final String title;
  final String? description;
  final int value;
  final DateTime date;
  final void Function() onTap;
  final void Function() onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: kBlackThree.withOpacity(0.1)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kWhiteThree.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5)),
                    child: SvgPicture.asset(
                      typeTransaction == TypeTranscation.expense
                          ? "assets/icons/up.svg"
                          : "assets/icons/down.svg",
                      width: 20,
                      height: 20,
                      color: typeTransaction == TypeTranscation.expense
                          ? Colors.red.shade500
                          : Colors.green.shade500,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: kBlackTwo.withOpacity(0.8),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //value
                Text(
                  typeTransaction == TypeTranscation.expense
                      ? "- ${formatCaurrncy(value)}"
                      : "+ ${formatCaurrncy(value)}",
                  style: TextStyle(
                    color: typeTransaction == TypeTranscation.expense
                        ? Colors.red.shade500
                        : Colors.green.shade500,
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                //date
                Text(
                  formatDate(date),
                  style: TextStyle(
                      fontSize: 11, color: kBlackTwo.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum TypeTranscation {
  income,
  expense;
}
