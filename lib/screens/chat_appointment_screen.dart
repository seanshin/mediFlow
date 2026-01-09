import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../services/hive_service.dart';

class ChatAppointmentScreen extends StatefulWidget {
  const ChatAppointmentScreen({super.key});

  @override
  State<ChatAppointmentScreen> createState() => _ChatAppointmentScreenState();
}

class _ChatAppointmentScreenState extends State<ChatAppointmentScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  int _currentStep = 0;
  
  String? _hospitalName;
  String? _department;
  String? _doctorName;
  DateTime? _appointmentDate;
  String? _appointmentTime;
  String? _purpose;

  @override
  void initState() {
    super.initState();
    _addBotMessage('안녕하세요! 병원 예약을 도와드리겠습니다. 어떤 병원을 예약하시나요?');
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    _addUserMessage(text);

    Future.delayed(const Duration(milliseconds: 500), () {
      _processUserInput(text);
    });
  }

  void _processUserInput(String text) {
    switch (_currentStep) {
      case 0: // Hospital name
        _hospitalName = text;
        _currentStep++;
        _addBotMessage('$_hospitalName을(를) 선택하셨습니다. 진료과를 알려주세요.');
        break;
      case 1: // Department
        _department = text;
        _currentStep++;
        _addBotMessage('$_department과를 선택하셨습니다. 의사 선생님 성함을 알려주세요.');
        break;
      case 2: // Doctor name
        _doctorName = text;
        _currentStep++;
        _addBotMessage('$_doctorName 선생님을 선택하셨습니다. 예약 날짜를 알려주세요. (예: 2024-01-15)');
        break;
      case 3: // Appointment date
        try {
          _appointmentDate = DateTime.parse(text);
          _currentStep++;
          _addBotMessage(
              '${DateFormat('yyyy년 MM월 dd일').format(_appointmentDate!)}을 선택하셨습니다. 예약 시간을 알려주세요. (예: 14:30)');
        } catch (e) {
          _addBotMessage('날짜 형식이 올바르지 않습니다. YYYY-MM-DD 형식으로 입력해주세요.');
        }
        break;
      case 4: // Appointment time
        _appointmentTime = text;
        _currentStep++;
        _addBotMessage('$_appointmentTime으로 예약하시겠습니까? 진료 목적을 간단히 알려주세요.');
        break;
      case 5: // Purpose
        _purpose = text;
        _saveAppointment();
        break;
    }
  }

  Future<void> _saveAppointment() async {
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hospitalName: _hospitalName!,
      department: _department!,
      doctorName: _doctorName!,
      appointmentDate: _appointmentDate!,
      appointmentTime: _appointmentTime!,
      purpose: _purpose!,
      status: 'scheduled',
      createdAt: DateTime.now(),
    );

    await HiveService.addAppointment(appointment);

    _addBotMessage(
      '✅ 예약이 완료되었습니다!\n\n'
      '병원: $_hospitalName\n'
      '진료과: $_department\n'
      '담당의: $_doctorName\n'
      '날짜: ${DateFormat('yyyy년 MM월 dd일').format(_appointmentDate!)}\n'
      '시간: $_appointmentTime\n'
      '진료목적: $_purpose\n\n'
      '감사합니다!',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약하기'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const FaIcon(
                FontAwesomeIcons.robot,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const FaIcon(
                FontAwesomeIcons.user,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.paperPlane,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
