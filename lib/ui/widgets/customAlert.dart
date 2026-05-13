import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info }

class BixAlert extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final bool showCancel;

  const BixAlert({
    super.key,
    required this.title,
    required this.message,
    this.type = AlertType.info,
    this.confirmText,
    this.onConfirm,
    this.showCancel = false,
  });

  /// Fungsi utama untuk menampilkan alert
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.info,
    String? confirmText,
    VoidCallback? onConfirm,
    bool showCancel = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BixAlert(
        title: title,
        message: message,
        type: type,
        confirmText: confirmText,
        onConfirm: onConfirm,
        showCancel: showCancel,
      ),
    );
  }

  // Helper methods untuk penggunaan cepat
  static void success(BuildContext context, String message, {String? title, VoidCallback? onConfirm}) {
    show(
      context: context, 
      title: title ?? 'Berhasil', 
      message: message, 
      type: AlertType.success, 
      onConfirm: onConfirm,
      confirmText: 'Selesai',
    );
  }

  static void error(BuildContext context, String message, {String? title}) {
    show(
      context: context, 
      title: title ?? 'Gagal', 
      message: message, 
      type: AlertType.error,
      confirmText: 'Coba Lagi',
    );
  }

  static void warning(BuildContext context, String message, {String? title, String? confirmText, VoidCallback? onConfirm, bool showCancel = true}) {
    show(
      context: context, 
      title: title ?? 'Peringatan', 
      message: message, 
      type: AlertType.warning,
      confirmText: confirmText ?? 'Ya, Lanjutkan',
      onConfirm: onConfirm,
      showCancel: showCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor;
    IconData icon;

    switch (type) {
      case AlertType.success:
        primaryColor = const Color(0xFF22C55E);
        icon = Icons.check_circle_outline;
        break;
      case AlertType.error:
        primaryColor = const Color(0xFFD32F2F);
        icon = Icons.error_outline;
        break;
      case AlertType.warning:
        primaryColor = const Color(0xFFF59E0B);
        icon = Icons.warning_amber_rounded;
        break;
      case AlertType.info:
      default:
        primaryColor = const Color(0xFF1A237E); // Menggunakan kNavyMid style
        icon = Icons.info_outline;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Header
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 48),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Actions
            Row(
              children: [
                if (showCancel)
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (showCancel) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onConfirm != null) onConfirm!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText ?? 'Tutup',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
