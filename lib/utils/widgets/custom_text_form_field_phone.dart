import 'package:flutter/material.dart';

class CustomTextFormFieldPhone extends StatelessWidget {
  const CustomTextFormFieldPhone({
    super.key,
    required TextEditingController phoneNumberController,
  }) : _phoneNumberController = phoneNumberController;

  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: const InputDecoration(
        labelText: 'Numéro de téléphone*',
        border: OutlineInputBorder(),
        prefixText: '+',
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) return 'Ce champ est obligatoire';
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Entrez un numéro valide';
        }
        return null;
      },
    );
  }
}
