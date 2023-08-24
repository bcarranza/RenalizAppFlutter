import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.messenger_outline_rounded, 'Chat'),
  Destination(Icons.home_outlined, 'Inicio'),
  Destination(FontAwesomeIcons.flask, 'Examen'),
];