import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactLauncherButton extends StatelessWidget {
  final String contact;
  final String? label;
  final IconData? icon;

  const ContactLauncherButton({
    super.key,
    required this.contact,
    this.label,
    this.icon,
  });

  Future<void> _launchContact(BuildContext context) async {
    Uri uri;

    if (contact.contains('@')) {
      uri = Uri(
        scheme: 'mailto',
        path: contact,
        query: Uri.encodeFull('subject=Contact&body=Bonjour'),
      );
    } else {
      uri = Uri(scheme: 'tel', path: contact);
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirmation'),
            content: Text(
              contact.contains('@')
                  ? 'Voulez-vous envoyer un email à $contact ?'
                  : 'Voulez-vous appeler le numéro $contact ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Confirmer'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Impossible d'ouvrir $contact")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: Colors.green,
      ),
      onPressed: () => _launchContact(context),
      icon: Icon(
        icon ?? (contact.contains('@') ? Icons.email : Icons.phone),
        color: Theme.of(context).colorScheme.secondary,
      ),
      label: Text(
        label ?? (contact.contains('@') ? 'Envoyer Email' : 'Appeler'),
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
