import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static const String routeName = '/info';
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informacje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Nabożeństwo pierwszych sobót', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              'Nabożeństwo wynagradzające pierwszych sobót miesiąca zostało przekazane przez Matkę Bożą w Fatimie (1917) i potwierdzone w objawieniu siostry Łucji z 1925 roku. Polega na praktykowaniu przez pięć kolejnych pierwszych sobót czterech warunków: spowiedzi świętej, przyjęcia Komunii świętej, odmówienia jednej części Różańca oraz 15-minutowego rozmyślania nad tajemnicami różańcowymi – wszystko w intencji wynagradzającej Niepokalanemu Sercu Maryi.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Pięć zniewag wobec Niepokalanego Serca Maryi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('1) Przeciw Niepokalanemu Poczęciu'),
            Text('2) Przeciw Dziewictwu Maryi'),
            Text('3) Przeciw Bożemu Macierzyństwu, z jednoczesną odmową uznania Jej za Matkę ludzi'),
            Text('4) Wprowadzanie w serca dzieci obojętności, pogardy, a nawet nienawiści do Maryi'),
            Text('5) Znieważanie świętych wizerunków Maryi'),
            SizedBox(height: 16),
            Text('Modlitwy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('O mój Jezu, przebacz nam nasze grzechy, zachowaj nas od ognia piekielnego, zaprowadź wszystkie dusze do nieba i dopomóż szczególnie tym, którzy najbardziej potrzebują Twojego miłosierdzia.'),
            SizedBox(height: 16),
            Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Czy można odprawić nabożeństwo w niedzielę za zgodą kapłana? – Tak, z ważnej przyczyny i za zgodą kapłana możliwe jest przeniesienie praktyki na niedzielę.'),
          ],
        ),
      ),
    );
  }
}