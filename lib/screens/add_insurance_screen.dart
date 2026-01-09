import 'package:flutter/material.dart';
import '../models/insurance_provider.dart';
import '../services/hive_service.dart';

class AddInsuranceScreen extends StatefulWidget {
  const AddInsuranceScreen({super.key});

  @override
  State<AddInsuranceScreen> createState() => _AddInsuranceScreenState();
}

class _AddInsuranceScreenState extends State<AddInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerNameController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _membershipIdController = TextEditingController();
  final _coverageDetailsController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedType = 'health';
  DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보험 정보 추가'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _providerNameController,
              decoration: const InputDecoration(
                labelText: '보험사명',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '보험사명을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: '보험 유형',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'health', child: Text('건강보험')),
                DropdownMenuItem(value: 'dental', child: Text('치과보험')),
                DropdownMenuItem(value: 'vision', child: Text('시력보험')),
                DropdownMenuItem(value: 'life', child: Text('생명보험')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _policyNumberController,
              decoration: const InputDecoration(
                labelText: '증권번호',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '증권번호를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _membershipIdController,
              decoration: const InputDecoration(
                labelText: '회원번호 (선택)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coverageDetailsController,
              decoration: const InputDecoration(
                labelText: '보장 내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactPhoneController,
              decoration: const InputDecoration(
                labelText: '연락처',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactEmailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: '메모',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveInsurance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
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

  void _saveInsurance() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = InsuranceProvider(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        providerName: _providerNameController.text,
        policyNumber: _policyNumberController.text,
        type: _selectedType,
        startDate: _startDate,
        coverageDetails: _coverageDetailsController.text,
        contactPhone: _contactPhoneController.text,
        contactEmail: _contactEmailController.text,
        membershipId: _membershipIdController.text,
        isActive: true,
        notes: _notesController.text,
      );

      await HiveService.addInsuranceProvider(provider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('보험 정보가 저장되었습니다')),
        );
        Navigator.pop(context);
      }
    }
  }
}
