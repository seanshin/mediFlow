import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/medical_record.dart';
import '../services/hive_service.dart';
import 'add_medical_record_screen.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  List<MedicalRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _records = HiveService.getAllMedicalRecords();
      _records.sort((a, b) => b.recordDate.compareTo(a.recordDate));
    });
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'diagnosis':
        return const Color(0xFF2196F3); // Blue
      case 'test_result':
        return const Color(0xFF26C6DA); // Teal
      case 'surgery':
        return const Color(0xFFE91E63); // Pink
      case 'vaccination':
        return const Color(0xFF66BB6A); // Green
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'diagnosis':
        return FontAwesomeIcons.stethoscope;
      case 'test_result':
        return FontAwesomeIcons.flask;
      case 'surgery':
        return FontAwesomeIcons.userNurse;
      case 'vaccination':
        return FontAwesomeIcons.syringe;
      default:
        return FontAwesomeIcons.fileMedical;
    }
  }

  String _getTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'diagnosis':
        return '진단';
      case 'test_result':
        return '검사 결과';
      case 'surgery':
        return '수술';
      case 'vaccination':
        return '예방접종';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '의료 기록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: _records.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.folderOpen,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '등록된 의료 기록이 없습니다',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            _getTypeColor(record.type).withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(record.type),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    _getTypeIcon(record.type),
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _getTypeText(record.type),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getTypeColor(record.type),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.hospital,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(record.hospitalName),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.userDoctor,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(record.doctorName),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(DateFormat('yyyy년 MM월 dd일')
                                    .format(record.recordDate)),
                              ],
                            ),
                            if (record.diagnosis.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.fileWaveform,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '진단',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(record.diagnosis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (record.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                record.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicalRecordScreen(),
            ),
          );
          _loadRecords();
        },
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text('기록 추가'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
