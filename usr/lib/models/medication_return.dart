import 'package:flutter/material.dart';

class MedicationReturn {
  final String id;
  final String drugName;
  final String ward;
  final int expectedQuantity;
  final int returnedQuantity;
  final String? staffNurseName;
  final String? remarks;
  final DateTime timestamp;

  MedicationReturn({
    required this.id,
    required this.drugName,
    required this.ward,
    required this.expectedQuantity,
    required this.returnedQuantity,
    this.staffNurseName,
    this.remarks,
    required this.timestamp,
  });
}

class ReturnState extends ChangeNotifier {
  final List<MedicationReturn> _returns = [];

  List<MedicationReturn> get returns => List.unmodifiable(_returns);

  void addReturn(MedicationReturn ret) {
    _returns.add(ret);
    notifyListeners();
  }
}
