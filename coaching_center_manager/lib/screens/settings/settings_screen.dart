import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/theme_provider.dart';
import 'logout_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerColor = AppDynamicColors.headerBg(context);
    final cardColor = AppDynamicColors.cardBg(context);
    final headerTextColor = AppDynamicColors.headerText(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: headerTextColor),
                ),
                const SizedBox(width: 16),
                Text(
                  'Setting',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: headerTextColor,
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
                      color: cardColor,
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
                        Icon(Icons.nightlight_round, color: primaryTextColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: primaryTextColor,
                                ),
                              ),
                              Text(
                                'Switch to dark theme',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryTextColor,
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
                        color: cardColor,
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
                          Icon(Icons.chevron_right, color: secondaryTextColor),
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
                        Text(
                          'COACHING CENTER',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: primaryTextColor,
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
