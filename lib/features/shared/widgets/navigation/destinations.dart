import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa url_launcher para abrir WhatsApp

class Destination {
  const Destination(this.icon, this.label, {this.isWhatsApp = false});
  final IconData icon;
  final String label;
  final bool isWhatsApp;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.home_outlined, 'Inicio'),
  Destination(FontAwesomeIcons.flask, 'Examen'),
  Destination(Icons.local_hospital_outlined, 'Centros'),
  Destination(FontAwesomeIcons.whatsapp, 'WhatsApp', isWhatsApp: true),
];
