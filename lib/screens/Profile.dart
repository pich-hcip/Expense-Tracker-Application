import 'package:flutter/material.dart';

import 'edit_profile.dart';
import 'login.dart';
import '../services/api_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const Color primaryBlue = Color(0xFF2458C6);
  static const Color textColor = Color(0xFF17213D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FD),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 19,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Edit profile',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const EditProfilePage(),
                      ),
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 25,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ================= PROFILE CARD =================
              Container(
                width: double.infinity,
                height: 98,
                padding: const EdgeInsets.symmetric(horizontal: 17),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3A55D8),
                      Color(0xFF18285E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const ClipOval(
                        child: Image(
                          image: AssetImage('assets/images/profile.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment(0, -0.2),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Name + Email
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ApiService.instance.currentUserName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            ApiService.instance.currentUserEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFD9E1FF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ================= MENU =================
              _menuItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () {},
              ),

              _divider(),

              _menuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () {},
              ),

              _divider(),

              _menuItem(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                onTap: () {},
              ),

              _divider(),

              _menuItem(
                icon: Icons.language,
                title: 'Currency',
                trailingText: 'USD (\$)',
                onTap: () {},
              ),

              _divider(),

              _menuItem(
                icon: Icons.notifications_none,
                title: 'Notification Settings',
                onTap: () {},
              ),

              _divider(),

              _menuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),

              const SizedBox(height: 42),

              // ================= SIGN OUT =================
              _menuItem(
                icon: Icons.logout,
                title: 'Sign Out',
                isLogout: true,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // MENU ITEM
  // =========================================================
  static Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 47,
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: isLogout
                  ? const Color(0xFFFF4D4D)
                  : primaryBlue,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isLogout
                      ? const Color(0xFFFF4D4D)
                      : textColor,
                ),
              ),
            ),

            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 12,
                  color: primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(width: 13),

            const Icon(
              Icons.chevron_right,
              size: 21,
              color: Color(0xFF65728A),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================
  static Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 37,
        right: 0,
      ),
      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Color(0xFFF0F2F5),
      ),
    );
  }

  // =========================================================
  // LOGOUT DIALOG
  // =========================================================
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _logout(context),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _logout(BuildContext dialogContext) async {
    final navigator = Navigator.of(dialogContext, rootNavigator: true);
    try {
      await ApiService.instance.logout();
      if (!dialogContext.mounted) return;
      navigator.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (_) {
      if (!dialogContext.mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('Could not sign out. Please try again.')),
      );
    }
  }
}
