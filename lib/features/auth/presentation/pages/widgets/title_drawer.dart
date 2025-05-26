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
      padding: const EdgeInsets.all(4),
      child: ListTile(
        leading: Icon(
          size: 26,
          iconData,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_circle_right_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () {},
      ),
    );
  }
}
