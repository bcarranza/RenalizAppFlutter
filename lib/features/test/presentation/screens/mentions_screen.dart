import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EquipoPage extends StatefulWidget {
  final GoRouter appRouter;

  EquipoPage({required this.appRouter});

  @override
  _EquipoPageState createState() => _EquipoPageState();
}

class Empleado {
  String nombre;
  String cargo;
  String foto;
  String correo;
  String telefono;
  String descripcion;

  Empleado({
    required this.nombre,
    required this.cargo,
    required this.foto,
    required this.correo,
    required this.telefono,
    required this.descripcion,
  });
}

class _EquipoPageState extends State<EquipoPage> {
  List<Empleado> empleados = [];

  int _currentIndex = 0;
  List<String> listaDeIds = [
    'FJPkMhS8cHbERBsfVMV0',
  ];

  _EquipoPageState() {
    // Aquí puedes agregar el ciclo para cargar los datos de los empleados
    for (String empleadoId in listaDeIds) {
      obtenerEmpleadoPorId(empleadoId);
    }
  }

  Future<void> obtenerEmpleadoPorId(String empleadoId) async {
    final Uri url = Uri.parse(dotenv.env['API_URL']! + 'getMentions');

    final body = {
      "id": empleadoId,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        empleados.add(
          Empleado(
            nombre: data['name'].toString(),
            cargo: data['Role'].toString(),
            foto: data['foto'].toString(),
            correo: data['email'].toString(),
            telefono: data['Number_phone'].toString(),
            descripcion: data['description'].toString(),
          ),
        );
      });
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error al obtener datos del empleado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Menciones honoríficas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/test");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            CarouselSlider(
              items: empleados.map((empleado) {
                return _buildEmpleadoCard(empleado);
              }).toList(),
              options: CarouselOptions(
                height: 550,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpleadoCard(Empleado empleado) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: _buildFrontCard(empleado),
      back: _buildBackCard(empleado),
    );
  }

  Widget _buildFrontCard(Empleado empleado) {
    final double imageHeight = 300.0;
    final double cardHeight = imageHeight + 100.0;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
            height: 350,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(empleado.foto),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  empleado.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  empleado.cargo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Empleado empleado) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "INFORMACIÓN ADICIONAL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Correo electrónico:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  empleado.correo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Teléfono:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  empleado.telefono,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "DESCRIPCIÓN:",
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 25,
            ),
          ),
          Text(
            empleado.descripcion,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
