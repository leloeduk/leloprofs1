import 'package:flutter/material.dart';

class TitleDrawer extends StatelessWidget {
  final String title;
  final IconData iconData;

  final void Function()? onTap;
  const TitleDrawer({
    super.key,
    required this.iconData,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        trailing: Icon(Icons.arrow_circle_right_outlined),
        onTap: () {},
      ),
    );
  }
}
