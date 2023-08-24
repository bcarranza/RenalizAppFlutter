import 'package:flutter/material.dart';

import '../destinations.dart';

class DisappearingNavigationDrawer extends StatelessWidget {
  const DisappearingNavigationDrawer({
    Key? key, // Use 'Key?' instead of 'super.key'
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
  }) : super(key: key);

  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: const Center(
              child: Text(
                'Renalizapp',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: destinations.map((d) {
                final isSelected = destinations.indexOf(d) == selectedIndex;
                return ListTile(
                  leading: Icon(d.icon),
                  title: Text(d.label),
                  selected: isSelected,
                  onTap: () {
                    if (onDestinationSelected != null) {
                      onDestinationSelected!(destinations.indexOf(d));
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
