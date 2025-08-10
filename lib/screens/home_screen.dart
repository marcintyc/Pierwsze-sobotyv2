import 'package:flutter/material.dart';
import 'conditions_screen.dart';
import 'progress_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pierwsze Soboty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Witamy w aplikacji poświęconej nabożeństwu pierwszych sobót miesiąca.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Na prośbę Matki Bożej Fatimskiej: "Tym, którzy przez pięć miesięcy w pierwsze soboty odprawią nabożeństwa, w stanie łaski i w intencji wynagradzającej Jej Niepokalanemu Sercu, wyjednam łaski potrzebne do zbawienia."',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.favorite_outline),
              label: const Text('Rozpocznij nabożeństwo'),
              onPressed: () => Navigator.pushNamed(context, ConditionsScreen.routeName),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Kalendarz postępu'),
              onPressed: () => Navigator.pushNamed(context, ProgressScreen.routeName),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Informacje'),
              onPressed: () => Navigator.pushNamed(context, InfoScreen.routeName),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Aplikacja działa w pełni offline',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}