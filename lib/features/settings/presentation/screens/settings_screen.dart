import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
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
              value: isDarkModeEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  isDarkModeEnabled = newValue;
                  
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
