import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/main.dart';

import '../../providers/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {

    final themeNotifier = context.read<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Habilitar el modo oscuro'),
            trailing: Switch(
              value: themeNotifier.isDarkMode, 
              onChanged: (bool newValue) {
                setState(() {
                  themeNotifier.toggleDarkMode();
                });
              },
            ),
          ),
           ListTile(
            title: const Text('Número de Versión'),
            subtitle: const Text('Versión 0.4 Open Beta'),
            onTap: () {
             
            },
          ),
         
        ],
      ),
    );
  }
}
