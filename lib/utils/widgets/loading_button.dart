import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String label;
  final Color color;
  final Future<void> Function()? onValidated;

  const LoadingButton({
    super.key,
    required this.label,
    this.color = Colors.red,
    this.onValidated,
  });

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Veuillez patienter...",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    _showLoadingDialog(context);
    if (onValidated != null) {
      await onValidated!();
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    Navigator.of(context).pop(); // ferme le dialog après l'attente
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleTap(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
