import 'package:flutter/material.dart';

/// Normalize nomor telepon ke format internasional
String normalizePhone(String phone) {
  phone = phone.replaceAll(RegExp(r'[^\d]'), ''); // hanya angka

  if (phone.startsWith('0')) {
    return '62${phone.substring(1)}';
  } else if (phone.startsWith('62')) {
    return phone;
  } else {
    return '62$phone';
  }
}

/// Mask nomor telepon untuk display
String maskPhone(String phone) {
  if (phone.length < 4) return phone;
  final visible = phone.substring(0, 4);
  final hidden = '*' * (phone.length - 8);
  final lastDigits = phone.substring(phone.length - 4);
  return '$visible$hidden$lastDigits';
}

/// Show error dialog
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('❌ Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Show success dialog
void showSuccessDialog(
  BuildContext context,
  String title,
  String message, {
  VoidCallback? onOk,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('✅ $title'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onOk?.call();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
