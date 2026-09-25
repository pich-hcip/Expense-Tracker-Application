import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 50,
    this.fontSize,
    this.border,
  });

  final String name;
  final String? avatarUrl;
  final double size;
  final double? fontSize;
  final BoxBorder? border;

  static const List<List<Color>> _gradientPalettes = [
    [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    [Color(0xFFEC4899), Color(0xFFBE185D)],
    [Color(0xFF10B981), Color(0xFF047857)],
    [Color(0xFFF59E0B), Color(0xFFB45309)],
    [Color(0xFF06B6D4), Color(0xFF0E7490)],
    [Color(0xFF6366F1), Color(0xFF4338CA)],
  ];

  static List<Color> _getGradientForName(String text) {
    if (text.isEmpty) return _gradientPalettes.first;
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final index = hash.abs() % _gradientPalettes.length;
    return _gradientPalettes[index];
  }

  static String getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return 'U';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(name);
    final calculatedFontSize = fontSize ?? (size * 0.38);
    final colors = _getGradientForName(name);

    final normalizedUrl = avatarUrl?.trim() ?? '';
    final hasNetworkImage =
        normalizedUrl.startsWith('http://') ||
        normalizedUrl.startsWith('https://');
    final memoryImage = _decodeDataUrl(normalizedUrl);
    final hasImage = hasNetworkImage || memoryImage != null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        gradient: hasImage
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
      ),
      child: ClipOval(
        child: memoryImage != null
            ? Image.memory(
                memoryImage,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitials(initials, calculatedFontSize, colors),
              )
            : hasNetworkImage
            ? Image.network(
                normalizedUrl,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitials(initials, calculatedFontSize, colors),
              )
            : _buildInitials(initials, calculatedFontSize, colors),
      ),
    );
  }

  Uint8List? _decodeDataUrl(String value) {
    if (!value.startsWith('data:image/') || !value.contains(';base64,')) {
      return null;
    }
    try {
      return base64Decode(value.substring(value.indexOf(',') + 1));
    } on FormatException {
      return null;
    }
  }

  Widget _buildInitials(String text, double fSize, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
