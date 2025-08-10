import 'package:intl/intl.dart';

DateTime firstSaturdayOfMonth(int year, int month) {
  final DateTime firstDay = DateTime(year, month, 1);
  final int weekday = firstDay.weekday; // Mon=1 ... Sun=7
  final int daysToSaturday = (DateTime.saturday - weekday + 7) % 7;
  return DateTime(year, month, 1 + daysToSaturday);
}

List<DateTime> firstSaturdaysOfYear(int year) {
  return List<DateTime>.generate(12, (index) => firstSaturdayOfMonth(year, index + 1));
}

String formatDateISO(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String formatDateLongPl(DateTime date) => DateFormat('d MMMM y, EEEE', 'pl_PL').format(date);

DateTime nextFirstSaturdayFrom(DateTime from) {
  final DateTime currentMonth = DateTime(from.year, from.month, 1);
  final DateTime fsThisMonth = firstSaturdayOfMonth(currentMonth.year, currentMonth.month);
  if (!from.isAfter(fsThisMonth)) return fsThisMonth;
  final DateTime nextMonth = DateTime(from.year, from.month + 1, 1);
  return firstSaturdayOfMonth(nextMonth.year, nextMonth.month);
}