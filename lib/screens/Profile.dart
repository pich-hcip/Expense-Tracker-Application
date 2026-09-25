import 'package:flutter/material.dart';

import 'edit_profile.dart';
import 'login.dart';
import '../services/api_service.dart';
import '../widgets/user_avatar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const Color primaryBlue = Color(0xFF2458C6);
  static const Color textColor = Color(0xFF17213D);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      await ApiService.instance.getProfile();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const EditProfilePage(),
      ),
    );
    if (updated == true && mounted) {
      await _loadProfile();
      if (mounted) setState(() {});
    }
  }

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
                    onPressed: _openEditProfile,
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
                    // Dynamic Profile Avatar
                    UserAvatar(
                      name: ApiService.instance.currentUserName,
                      avatarUrl: ApiService.instance.currentUserAvatar,
                      size: 62,
                      border: Border.all(
                        color: const Color(0x59FFFFFF),
                        width: 2.5,
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
                onTap: _openEditProfile,
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
                trailingText: '${ApiService.instance.currentCurrency} (\$)',
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
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(width: 6),

            if (!isLogout)
              const Icon(
                Icons.chevron_right,
                size: 21,
                color: Color(0xFF8B98B2),
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
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF3F4F6),
    );
  }

  // =========================================================
  // LOGOUT DIALOG
  // =========================================================
  static void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF8B98B2)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await ApiService.instance.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFFF4D4D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
