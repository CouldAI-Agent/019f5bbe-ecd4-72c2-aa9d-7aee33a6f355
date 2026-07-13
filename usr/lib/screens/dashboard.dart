import 'package:flutter/material.dart';
import '../models/medication_return.dart';
import 'add_return.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<MedicationReturn> returns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Returns'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: returns.isEmpty
          ? const Center(child: Text('No returns recorded yet.'))
          : ListView.builder(
              itemCount: returns.length,
              itemBuilder: (context, index) {
                final item = returns[index];
                final hasVariance = item.expectedQuantity != item.returnedQuantity;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${item.drugName} - ${item.ward}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Returned: ${item.returnedQuantity} (Expected: ${item.expectedQuantity})'),
                        if (hasVariance)
                          Text('Variance Alert!', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        if (item.staffNurseName != null && item.staffNurseName!.isNotEmpty)
                          Text('SN: ${item.staffNurseName}'),
                        if (item.remarks != null && item.remarks!.isNotEmpty)
                          Text('Remarks: ${item.remarks}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReturnScreen()),
          );
          if (result != null && result is MedicationReturn) {
            setState(() {
              returns.insert(0, result);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Return'),
      ),
    );
  }
}
