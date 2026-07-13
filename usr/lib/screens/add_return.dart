import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/medication_return.dart';

class AddReturnScreen extends StatefulWidget {
  const AddReturnScreen({super.key});

  @override
  State<AddReturnScreen> createState() => _AddReturnScreenState();
}

class _AddReturnScreenState extends State<AddReturnScreen> {
  final _formKey = GlobalKey<FormState>();
  final _drugNameController = TextEditingController();
  final _wardController = TextEditingController();
  final _expectedQtyController = TextEditingController();
  final _returnedQtyController = TextEditingController();
  final _snNameController = TextEditingController();
  final _remarksController = TextEditingController();
  bool _pushToFloor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Medication Return'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please ensure correct quantities are entered to avoid variances during stock take.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _drugNameController,
                decoration: const InputDecoration(labelText: 'Drug Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(labelText: 'Ward', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expectedQtyController,
                      decoration: const InputDecoration(labelText: 'Expected Qty', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _returnedQtyController,
                      decoration: const InputDecoration(labelText: 'Returned Qty', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Push to floor?'),
                value: _pushToFloor,
                onChanged: (val) => setState(() => _pushToFloor = val),
              ),
              if (_pushToFloor) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _snNameController,
                  decoration: const InputDecoration(labelText: 'Staff Nurse (SN) Name', border: OutlineInputBorder()),
                  validator: (value) => _pushToFloor && (value == null || value.isEmpty) ? 'SN Name required for floor pushes' : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Required if variance exists)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  final expected = int.tryParse(_expectedQtyController.text) ?? 0;
                  final returned = int.tryParse(_returnedQtyController.text) ?? 0;
                  if (expected != returned && (value == null || value.isEmpty)) {
                    return 'Remarks are mandatory when quantities differ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = MedicationReturn(
                        id: const Uuid().v4(),
                        drugName: _drugNameController.text,
                        ward: _wardController.text,
                        expectedQuantity: int.parse(_expectedQtyController.text),
                        returnedQuantity: int.parse(_returnedQtyController.text),
                        staffNurseName: _pushToFloor ? _snNameController.text : null,
                        remarks: _remarksController.text,
                        timestamp: DateTime.now(),
                      );
                      Navigator.pop(context, item);
                    }
                  },
                  child: const Text('Save Return Record'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
