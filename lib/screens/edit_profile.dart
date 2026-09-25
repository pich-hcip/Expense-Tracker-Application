import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../widgets/user_avatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthdayController;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  static const _primaryBlue = Color(0xFF2458C6);
  static const _textColor = Color(0xFF17213D);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ApiService.instance.currentUserName,
    );
    _emailController = TextEditingController(
      text: ApiService.instance.currentUserEmail,
    );
    _phoneController = TextEditingController(
      text: ApiService.instance.currentUserPhone,
    );
    _birthdayController = TextEditingController(
      text: _formatBirthDate(ApiService.instance.currentUserBirthDate),
    );

    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ApiService.instance.getProfile();
      if (mounted && profile.isNotEmpty) {
        setState(() {
          _nameController.text = ApiService.instance.currentUserName;
          _emailController.text = ApiService.instance.currentUserEmail;
          _phoneController.text = ApiService.instance.currentUserPhone;
          _birthdayController.text = _formatBirthDate(
            ApiService.instance.currentUserBirthDate,
          );
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                  children: [
                    _EditHeader(onBack: () => Navigator.maybePop(context)),
                    const SizedBox(height: 28),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          UserAvatar(
                            name: _nameController.text.isNotEmpty
                                ? _nameController.text
                                : ApiService.instance.currentUserName,
                            avatarUrl: ApiService.instance.currentUserAvatar,
                            size: 96,
                            fontSize: 34,
                            border: Border.all(
                              color: const Color(0xFFE7ECF7),
                              width: 3,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: 2,
                            child: Material(
                              color: _primaryBlue,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: _changePhoto,
                                customBorder: const CircleBorder(),
                                child: const SizedBox(
                                  width: 31,
                                  height: 31,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 29),
                    _ProfileField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 17),
                    _ProfileField(
                      label: 'Email Address',
                      controller: _emailController,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Enter your email address';
                        if (!email.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 17),
                    _ProfileField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 17),
                    _ProfileField(
                      label: 'Date of Birth',
                      controller: _birthdayController,
                      icon: Icons.calendar_month_outlined,
                      readOnly: true,
                      onTap: _selectBirthday,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePhoto() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _pickImage();
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Choose photo from device'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (ApiService.instance.currentUserAvatar?.isNotEmpty ==
                  true) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _setAvatar('');
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove current photo'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (bytes.length > 2 * 1024 * 1024) {
        throw const ApiException('Please choose an image smaller than 2 MB.');
      }

      final mimeType =
          image.mimeType ??
          (image.name.toLowerCase().endsWith('.png')
              ? 'image/png'
              : 'image/jpeg');
      final dataUrl = 'data:$mimeType;base64,${base64Encode(bytes)}';
      await _setAvatar(dataUrl);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not select this image.')),
        );
      }
    }
  }

  Future<void> _setAvatar(String avatarUrl) async {
    setState(() => _isLoading = true);
    try {
      await ApiService.instance.updateAvatar(avatarUrl: avatarUrl);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully!')),
        );
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update avatar. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectBirthday() async {
    final currentBirthDate = ApiService.instance.currentUserBirthDate;
    final selected = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(currentBirthDate ?? '') ?? DateTime(1996, 1, 16),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected == null || !mounted) return;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    _birthdayController.text =
        '${selected.day} ${months[selected.month - 1]} ${selected.year}';
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await ApiService.instance.updateProfile(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: _parseBirthDate(_birthdayController.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.maybePop(context, true);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  static String _formatBirthDate(String? value) {
    final date = DateTime.tryParse(value ?? '');
    if (date == null) return '';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String? _parseBirthDate(String value) {
    final parts = value.trim().split(' ');
    if (parts.length != 3) return null;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final day = int.tryParse(parts[0]);
    final month = months.indexOf(parts[1]) + 1;
    final year = int.tryParse(parts[2]);
    if (day == null || month == 0 || year == null) return null;
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: const Color(0xFFF4F7FD),
          borderRadius: BorderRadius.circular(11),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(11),
            child: const SizedBox(
              width: 37,
              height: 37,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 19,
                color: _EditProfilePageState._primaryBlue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _EditProfilePageState._textColor,
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4F5870),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: Color(0xFF17213D), fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2458C6), size: 20),
            filled: true,
            fillColor: const Color(0xFFFAFBFD),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                color: Color(0xFF2458C6),
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFFF4D4D)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                color: Color(0xFFFF4D4D),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
