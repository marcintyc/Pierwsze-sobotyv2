import 'package:flutter/material.dart';

import '../services/devotion_storage.dart';
import '../services/notification_service.dart';
import '../utils/first_saturdays.dart';

class ProgressScreen extends StatefulWidget {
  static const String routeName = '/progress';
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final DevotionStorage _storage = DevotionStorage();
  Set<String> _completed = <String>{};
  late final List<DateTime> _yearSaturdays;

  @override
  void initState() {
    super.initState();
    _yearSaturdays = firstSaturdaysOfYear(DateTime.now().year);
    _load();
    NotificationService.instance.initialize();
  }

  Future<void> _load() async {
    final Set<String> c = await _storage.getCompletedSaturdays();
    setState(() => _completed = c);
  }

  int get _count => _completed.length.clamp(0, 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendarz i postęp'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Ukończono $_count/5 sobót', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: _count / 5,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final bool filled = i < _count;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: filled ? Theme.of(context).colorScheme.secondary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: Icon(
                  Icons.favorite,
                  color: filled ? Colors.white : Theme.of(context).colorScheme.primary,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text('Pierwsze soboty bieżącego roku', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._yearSaturdays.map((date) {
            final String key = formatDateISO(date);
            final bool done = _completed.contains(key);
            return Card(
              child: ListTile(
                leading: Icon(
                  done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: done ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
                title: Text(formatDateLongPl(date)),
                subtitle: Text(done ? 'Ukończono' : 'Dotknij, aby odznaczyć ukończenie'),
                trailing: Switch(
                  value: done,
                  onChanged: (value) async {
                    await _storage.setSaturdayCompleted(key, value);
                    _load();
                  },
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Włącz przypomnienia o pierwszej sobocie'),
            onPressed: () async {
              await NotificationService.instance.scheduleMonthlyFirstSaturdayReminder();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Zaplanowano przypomnienia na pierwsze soboty.')),
              );
            },
          ),
        ],
      ),
    );
  }
}