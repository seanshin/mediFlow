import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appointments_screen.dart';
import 'prescriptions_screen.dart';
import 'medical_records_screen.dart';
import 'insurance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AppointmentsScreen(),
    const PrescriptionsScreen(),
    const MedicalRecordsScreen(),
    const InsuranceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarCheck),
              label: '예약',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.prescriptionBottleMedical),
              label: '처방전',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.fileMedical),
              label: '의료기록',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shieldHeart),
              label: '보험',
            ),
          ],
        ),
      ),
    );
  }
}
