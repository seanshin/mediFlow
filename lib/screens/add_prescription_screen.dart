import 'package:flutter/material.dart';
import '../models/prescription.dart';
import '../services/hive_service.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _instructionsController = TextEditingController();
  
  String _selectedCategory = 'general';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('처방전 추가'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _medicineNameController,
              decoration: const InputDecoration(
                labelText: '약물명',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '약물명을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: '용량 (예: 500mg)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '용량을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _frequencyController,
              decoration: const InputDecoration(
                labelText: '복용 횟수 (예: 하루 3회)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '복용 횟수를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: '복용 기간 (일)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? '복용 기간을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: '약물 분류',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('일반')),
                DropdownMenuItem(value: 'antibiotic', child: Text('항생제')),
                DropdownMenuItem(value: 'painkiller', child: Text('진통제')),
                DropdownMenuItem(value: 'vitamin', child: Text('비타민')),
                DropdownMenuItem(value: 'allergy', child: Text('알레르기약')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hospitalNameController,
              decoration: const InputDecoration(
                labelText: '병원명',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '병원명을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _doctorNameController,
              decoration: const InputDecoration(
                labelText: '담당 의사',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '담당 의사를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: '복용 방법 및 주의사항',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('저장', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _savePrescription() async {
    if (_formKey.currentState?.validate() ?? false) {
      final prescription = Prescription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicineName: _medicineNameController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
        duration: int.parse(_durationController.text),
        hospitalName: _hospitalNameController.text,
        doctorName: _doctorNameController.text,
        prescribedDate: _selectedDate,
        instructions: _instructionsController.text,
        category: _selectedCategory,
        isActive: true,
      );

      await HiveService.addPrescription(prescription);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('처방전이 저장되었습니다')),
        );
        Navigator.pop(context);
      }
    }
  }
}
