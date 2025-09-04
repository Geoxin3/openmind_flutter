import 'package:flutter/material.dart';

class BoldDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color bgColor; // Dominant background color
  final VoidCallback onSubmit;
  final VoidCallback onClose;

  const BoldDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.bgColor,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: bgColor, // Solid background color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Icon(icon, size: 60, color: Colors.yellow.shade600,),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white, // White box for readability
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                content,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(text: "No", color: Colors.red, onTap: () => _close(context)),
                _buildButton(text: "Yes", color: Colors.green, onTap: () => _submit(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onTap,
          child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
    onClose();
  }

  void _submit(BuildContext context) {
    Navigator.pop(context);
    onSubmit();
  }

  static void show(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color bgColor, // Customizable dominant background color
    required VoidCallback onSubmit,
    required VoidCallback onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BoldDialog(
        title: title,
        content: content,
        icon: icon,
        bgColor: bgColor,
        onSubmit: onSubmit,
        onClose: onClose,
      ),
    );
  }
}
