import 'package:flutter/material.dart';
import '../models/medical_record.dart';
import '../services/hive_service.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  const AddMedicalRecordScreen({super.key});

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  
  String _selectedType = 'diagnosis';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('의료 기록 추가'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '제목을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: '기록 유형',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'diagnosis', child: Text('진단')),
                DropdownMenuItem(value: 'test_result', child: Text('검사 결과')),
                DropdownMenuItem(value: 'surgery', child: Text('수술')),
                DropdownMenuItem(value: 'vaccination', child: Text('예방접종')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
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
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: '진단명',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _treatmentController,
              decoration: const InputDecoration(
                labelText: '치료 내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '상세 설명',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
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

  void _saveRecord() async {
    if (_formKey.currentState?.validate() ?? false) {
      final record = MedicalRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        type: _selectedType,
        hospitalName: _hospitalNameController.text,
        doctorName: _doctorNameController.text,
        recordDate: _selectedDate,
        description: _descriptionController.text,
        diagnosis: _diagnosisController.text,
        treatment: _treatmentController.text,
      );

      await HiveService.addMedicalRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('의료 기록이 저장되었습니다')),
        );
        Navigator.pop(context);
      }
    }
  }
}
