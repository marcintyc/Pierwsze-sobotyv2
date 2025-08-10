import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DevotionStorage {
  static const String _completedSaturdaysKey = 'completed_saturdays';

  Future<Map<String, bool>> loadConditionsForDate(String dateIso) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('conditions_' + dateIso);
    if (jsonString == null) {
      return {
        'confession': false,
        'communion': false,
        'rosary': false,
        'meditation': false,
      };
    }
    final Map<String, dynamic> map = json.decode(jsonString) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as bool));
  }

  Future<void> saveConditionsForDate(String dateIso, Map<String, bool> conditions) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conditions_' + dateIso, json.encode(conditions));
  }

  Future<Set<String>> getCompletedSaturdays() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList(_completedSaturdaysKey) ?? <String>[];
    return items.toSet();
  }

  Future<void> setSaturdayCompleted(String dateIso, bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> current = await getCompletedSaturdays();
    if (completed) {
      current.add(dateIso);
    } else {
      current.remove(dateIso);
    }
    await prefs.setStringList(_completedSaturdaysKey, current.toList()..sort());
  }
}