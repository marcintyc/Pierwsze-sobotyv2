import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/devotion_storage.dart';
import '../utils/first_saturdays.dart';

class ConditionsScreen extends StatefulWidget {
  static const String routeName = '/conditions';
  const ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> with SingleTickerProviderStateMixin {
  final DevotionStorage _storage = DevotionStorage();
  late DateTime _targetDate;
  Map<String, bool> _conditions = {
    'confession': false,
    'communion': false,
    'rosary': false,
    'meditation': false,
  };

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _targetDate = nextFirstSaturdayFrom(DateTime.now());
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _load();
  }

  Future<void> _load() async {
    final String key = DateFormat('yyyy-MM-dd').format(_targetDate);
    final Map<String, bool> loaded = await _storage.loadConditionsForDate(key);
    setState(() {
      _conditions = loaded;
    });
    _updateAnimation();
  }

  Future<void> _toggle(String key, bool value) async {
    setState(() {
      _conditions[key] = value;
    });
    final String dateIso = formatDateISO(_targetDate);
    await _storage.saveConditionsForDate(dateIso, _conditions);
    _updateAnimation();
    if (_isAllDone) {
      await _storage.setSaturdayCompleted(dateIso, true);
    }
  }

  bool get _isAllDone => _conditions.values.every((v) => v);

  void _updateAnimation() {
    if (_isAllDone) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warunki nabożeństwa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _targetDate,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 2),
                helpText: 'Wybierz pierwszą sobotę',
              );
              if (picked != null) {
                final DateTime fs = firstSaturdayOfMonth(picked.year, picked.month);
                setState(() => _targetDate = fs);
                _load();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ' + formatDateLongPl(_targetDate),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _ConditionCard(
              title: 'Spowiedź święta (z intencją wynagradzającą)',
              icon: Icons.add_road, // symbolic
              value: _conditions['confession'] ?? false,
              onChanged: (v) => _toggle('confession', v ?? false),
            ),
            _ConditionCard(
              title: 'Komunia święta',
              icon: Icons.church,
              value: _conditions['communion'] ?? false,
              onChanged: (v) => _toggle('communion', v ?? false),
            ),
            _ConditionCard(
              title: 'Jedna część Różańca (pięć tajemnic)',
              icon: Icons.brightness_5,
              value: _conditions['rosary'] ?? false,
              onChanged: (v) => _toggle('rosary', v ?? false),
            ),
            _ConditionCard(
              title: '15-minutowe rozmyślanie nad tajemnicami różańcowymi',
              icon: Icons.favorite_border,
              value: _conditions['meditation'] ?? false,
              onChanged: (v) => _toggle('meditation', v ?? false),
            ),
            const SizedBox(height: 24),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.15).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _isAllDone ? 1 : 0.2,
                  child: Icon(
                    Icons.favorite,
                    size: 72,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_isAllDone)
              Center(
                child: Text(
                  'Dziękujemy! Wszystkie warunki zostały spełnione.',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Center(
                child: Text(
                  'Zaznacz wszystkie warunki, aby ukończyć tę sobotę.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ConditionCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: onChanged,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}