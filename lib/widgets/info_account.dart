import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class InfoAccount extends StatefulWidget {
  const InfoAccount(
      {super.key,
      required this.boxSafe,
      required this.totalBalance,
      required this.totalExpenses,
      required this.totalIncome});
  final Box? boxSafe;
  final int totalBalance;
  final int totalExpenses;
  final int totalIncome;

  @override
  State<InfoAccount> createState() => _InfoAccountState();
}

class _InfoAccountState extends State<InfoAccount> {
  final format = NumberFormat("#,##0.00", "en_US");

  late final safeKeys = widget.boxSafe!.keys.toList();
  late Map safe = widget.boxSafe!.get(safeKeys[0]);
  @override
  Widget build(BuildContext context) {
    //   print("==============================================================")
    // print(safeKeys);
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kBlack,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  "Total Balance",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCaurrncy(widget.totalBalance),
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                  const Text("SDG")
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            color: kWhite.withOpacity(0.2),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IncomeAndExpenses(
                  svg: "down.svg", type: "income", value: widget.totalIncome),
              IncomeAndExpenses(
                  svg: "up.svg", type: "expenses", value: widget.totalExpenses),
            ],
          ),
        ],
      ),
    );
  }
}

class IncomeAndExpenses extends StatelessWidget {
  const IncomeAndExpenses({
    super.key,
    required this.svg,
    required this.type,
    required this.value,
  });
  final String svg;
  final String type;
  final int value;
  @override
  Widget build(BuildContext context) {
    final format = NumberFormat("#,##0.00", "en_US");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
              color: kWhiteThree.withOpacity(.3),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/$svg",
                width: 11,
                height: 11,
                color: kWhite,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                type,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        Text(
          format.format(value),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  //   Widget _buildUISafe(safe) {
  //   if (safe == null) {
  //     return const CircularProgressIndicator();
  //   }
  //   return ValueListenableBuilder(
  //       valueListenable: safe!.listenable(),
  //       builder: (context, box, widget) {
  //         Map safeBox = safe.put
  //       });
  // }
}
