import 'package:expenses_test_app/colors/colors.dart';
import 'package:expenses_test_app/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class InfoAccount extends StatefulWidget {
  const InfoAccount({
    super.key,
    required this.boxSafe,
    this.boxTransactions,
  });
  final Box? boxSafe;
  final Box? boxTransactions;

  @override
  State<InfoAccount> createState() => _InfoAccountState();
}

class _InfoAccountState extends State<InfoAccount> {
  // late final safeKeys = widget.boxSafe!.keys.toList();
  // late Map safe = widget.boxSafe!.get(safeKeys[0]);

  // Box? transactionss;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getTransactionsBox() async {
  //     late var transactionssInit = Hive.box("transactions_box");
  //     setState(() {
  //       transactionss = transactionssInit;
  //     });
  //   }

  //   getTransactionsBox();
  // }

  int totalBalance = 0;
  int totalExpenses = 0;
  int totalIncome = 0;
  @override
  Widget build(BuildContext context) {
    handleTotal() async {
      late final data = widget.boxTransactions!.keys.toList();
      late final totalBalanceSafe = widget.boxSafe!.keys.toList();
      // print("=========================================");
      // print(totalBalanceSafe);

      if (widget.boxSafe != null && totalBalanceSafe.isNotEmpty) {
        var safe = await widget.boxSafe!.get(0);
        print("=========================================");
        print(safe["balance"]);
        setState(() {
          totalBalance = safe["balance"];
        });
      }

      if (widget.boxTransactions != null && data.isNotEmpty) {
        for (var index in data) {
          late final Map transaction = widget.boxTransactions!.get(index);

          if (transaction["type_transaction"] == "income") {
            totalIncome += int.parse(transaction["value"]);
            // totalBalance += int.parse(transaction["value"]);
          } else {
            // totalBalance -= int.parse(transaction["value"]);
            totalExpenses += int.parse(transaction["value"]);
          }
        }
      }
    }

    handleTotal();
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
                    formatCaurrncy(totalBalance),
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                  // if (widget.boxTransactions != null)
                  //   ValueListenableBuilder(
                  //       valueListenable: widget.boxTransactions!.listenable(),
                  //       builder: (context, box, widget) {
                  //         handleTotal();
                  //         return Text(
                  //           formatCaurrncy(totalBalance),
                  //           style: const TextStyle(
                  //               fontSize: 35, fontWeight: FontWeight.w900),
                  //         );
                  //       }),
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
                  svg: "down.svg", type: "income", value: totalIncome),
              IncomeAndExpenses(
                  svg: "up.svg", type: "expenses", value: totalExpenses),
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
              GestureDetector(
                onTap: () {
                  Hive.box("transactions_box").clear();
                },
                child: Text(
                  type,
                  style: const TextStyle(fontSize: 13),
                ),
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
