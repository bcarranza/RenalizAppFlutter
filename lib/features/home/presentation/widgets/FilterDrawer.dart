import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Filtar Por',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Text("Autores",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
          Divider(),
          ListTile(
            leading: Icon(Icons.filter),
            title: Text('Filtro 1'),
            onTap: () {
              // Agrega aquí la lógica para el filtro 1
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.filter),
            title: Text('Filtro 2'),
            onTap: () {
              // Agrega aquí la lógica para el filtro 2
              Navigator.pop(context);
            },
          ),
          // Agrega más elementos del menú aquí según tus necesidades
        ],
      ),
    );
  }
}
