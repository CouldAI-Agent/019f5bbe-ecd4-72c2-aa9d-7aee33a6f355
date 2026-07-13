import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(const MedicationReturnApp());
}

class MedicationReturnApp extends StatelessWidget {
  const MedicationReturnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Returns',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}
