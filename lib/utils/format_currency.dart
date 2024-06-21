import 'package:intl/intl.dart';

String formatCaurrncy(var value) {
  return NumberFormat("#,##0.00", "en_US").format(value);
}

// DateTime now = DateTime.now();
// String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
