import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';


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
            subtitle: const Text('v.1.0'),

            onTap: () {
             
            },
          ),

          ListTile(
            title: const Text('Terminos y condiciones de uso'),
            subtitle: const Text('Presiona aqui para ver los terminos de nuestra aplicación.'),
            onTap: () {
              const url = 'https://docs.google.com/document/d/1TpnPiCPdDabXOpsBQQtz0raNPYWau-Q0oI8GM7r9byQ/edit?usp=sharing';
              launch(url);
            },
          ),

         
        ],
      ),
    );
  }
}
