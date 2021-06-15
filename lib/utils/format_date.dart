import 'package:intl/intl.dart';

//this converts the dates to show as labels for the X axis
//in the graph.
String formatDate(String formattedString) {
  DateTime date = DateTime.parse(formattedString);
  String formatted = DateFormat('MM/dd').format(date).toString();
  return formatted;
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
