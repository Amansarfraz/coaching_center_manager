import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'logout_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(color: Color(0xFF86BFE2)),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Setting',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.nightlight_round,
                          color: Color(0xFF16305C),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Switch to dark theme',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          activeColor: const Color(0xFF2F80ED),
                          onChanged: (value) =>
                              themeProvider.toggleDarkMode(value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LogoutScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEB5757).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: Color(0xFFEB5757)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFFEB5757),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'COACHING CENTER',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: Color(0xFF16305C),
                          ),
                        ),
                        const Text(
                          'Manage.Teach.Inspire',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFF2994A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
