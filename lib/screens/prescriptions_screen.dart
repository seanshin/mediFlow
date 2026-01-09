import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/prescription.dart';
import '../services/hive_service.dart';
import 'add_prescription_screen.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  List<Prescription> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  void _loadPrescriptions() {
    setState(() {
      _prescriptions = HiveService.getAllPrescriptions();
      _prescriptions.sort((a, b) => b.prescribedDate.compareTo(a.prescribedDate));
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'antibiotic':
        return const Color(0xFFE91E63); // Pink
      case 'painkiller':
        return const Color(0xFF9C27B0); // Purple
      case 'vitamin':
        return const Color(0xFFFF9800); // Orange
      case 'allergy':
        return const Color(0xFF26C6DA); // Teal
      default:
        return const Color(0xFF66BB6A); // Green
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'antibiotic':
        return FontAwesomeIcons.syringe;
      case 'painkiller':
        return FontAwesomeIcons.capsules;
      case 'vitamin':
        return FontAwesomeIcons.pills;
      case 'allergy':
        return FontAwesomeIcons.vials;
      default:
        return FontAwesomeIcons.prescriptionBottleMedical;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '처방전',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: _prescriptions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.prescriptionBottleMedical,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '등록된 처방전이 없습니다',
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
                itemCount: _prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = _prescriptions[index];
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
                            _getCategoryColor(prescription.category)
                                .withValues(alpha: 0.05),
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
                                    color: _getCategoryColor(prescription.category),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    _getCategoryIcon(prescription.category),
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
                                        prescription.medicineName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        prescription.dosage,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (prescription.isActive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '복용중',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              FontAwesomeIcons.clockRotateLeft,
                              '복용 횟수',
                              prescription.frequency,
                              Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              FontAwesomeIcons.calendar,
                              '복용 기간',
                              '${prescription.duration}일',
                              Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              FontAwesomeIcons.hospital,
                              '병원',
                              prescription.hospitalName,
                              Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              FontAwesomeIcons.userDoctor,
                              '처방의',
                              prescription.doctorName,
                              Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              FontAwesomeIcons.calendarDay,
                              '처방일',
                              DateFormat('yyyy년 MM월 dd일')
                                  .format(prescription.prescribedDate),
                              Colors.grey,
                            ),
                            if (prescription.instructions.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circleInfo,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        prescription.instructions,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
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
              builder: (context) => const AddPrescriptionScreen(),
            ),
          );
          _loadPrescriptions();
        },
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text('처방전 추가'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
