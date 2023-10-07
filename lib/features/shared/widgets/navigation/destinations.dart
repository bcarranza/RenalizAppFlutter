import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.home_outlined, 'Inicio'),
  Destination(FontAwesomeIcons.flask, 'Examen'),
  Destination(Icons.local_hospital_outlined, 'Centros'),
];
