import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/insurance_provider.dart';
import '../services/hive_service.dart';
import 'add_insurance_screen.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  List<InsuranceProvider> _providers = [];

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    setState(() {
      _providers = HiveService.getAllInsuranceProviders();
      _providers.sort((a, b) => b.startDate.compareTo(a.startDate));
    });
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return const Color(0xFF26C6DA); // Teal
      case 'dental':
        return const Color(0xFF9C27B0); // Purple
      case 'vision':
        return const Color(0xFF2196F3); // Blue
      case 'life':
        return const Color(0xFFE91E63); // Pink
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return FontAwesomeIcons.heartPulse;
      case 'dental':
        return FontAwesomeIcons.tooth;
      case 'vision':
        return FontAwesomeIcons.eye;
      case 'life':
        return FontAwesomeIcons.umbrellaBeach;
      default:
        return FontAwesomeIcons.shieldHeart;
    }
  }

  String _getTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return '건강보험';
      case 'dental':
        return '치과보험';
      case 'vision':
        return '시력보험';
      case 'life':
        return '생명보험';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '보험 정보',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE1BEE7),
              Colors.white,
            ],
          ),
        ),
        child: _providers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.shieldHeart,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '등록된 보험 정보가 없습니다',
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
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  final provider = _providers[index];
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
                            _getTypeColor(provider.type).withValues(alpha: 0.05),
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
                                    color: _getTypeColor(provider.type),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    _getTypeIcon(provider.type),
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
                                        provider.providerName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _getTypeText(provider.type),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getTypeColor(provider.type),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (provider.isActive)
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
                                      '활성',
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
                              FontAwesomeIcons.idCard,
                              '증권번호',
                              provider.policyNumber,
                            ),
                            if (provider.membershipId.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                FontAwesomeIcons.hashtag,
                                '회원번호',
                                provider.membershipId,
                              ),
                            ],
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              FontAwesomeIcons.calendarCheck,
                              '가입일',
                              DateFormat('yyyy년 MM월 dd일').format(provider.startDate),
                            ),
                            if (provider.expiryDate != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                FontAwesomeIcons.calendarXmark,
                                '만료일',
                                DateFormat('yyyy년 MM월 dd일')
                                    .format(provider.expiryDate!),
                              ),
                            ],
                            if (provider.contactPhone.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                FontAwesomeIcons.phone,
                                '연락처',
                                provider.contactPhone,
                              ),
                            ],
                            if (provider.coverageDetails.isNotEmpty) ...[
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
                                      FontAwesomeIcons.fileLines,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '보장 내용',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            provider.coverageDetails,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
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
              builder: (context) => const AddInsuranceScreen(),
            ),
          );
          _loadProviders();
        },
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text('보험 추가'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: Colors.grey[600]),
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
