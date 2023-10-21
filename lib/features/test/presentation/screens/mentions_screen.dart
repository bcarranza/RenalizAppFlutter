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
  String foto;
  String descripcion;

  Empleado({
    required this.nombre,
    required this.foto,
    required this.descripcion,
  });
}

class _EquipoPageState extends State<EquipoPage> {
  List<Empleado> empleados = [];

  _EquipoPageState() {
    // Aquí puedes cargar los datos de las colecciones en lugar de IDs
    cargarEmpleados();
  }

  Future<void> cargarEmpleados() async {
    final Uri url = Uri.parse(dotenv.env['API_URL']! + 'getMentions');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        // Si los datos son una lista, podemos procesar cada elemento
        for (var item in data) {
          final empleado = Empleado(
            nombre: item['name'].toString(),
            foto: item['foto'].toString(),
            descripcion: item['description']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", ""),
          );
          empleados.add(empleado);
        }
        setState(() {});
      } else {
        print('Error: los datos no son una lista');
      }
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error al obtener datos de empleados');
    }
  }

  List<Widget> _buildDescripcion(
      List<String> descripcionItems, double screenWidth) {
    // Calcula el tamaño de fuente en función del ancho de la pantalla
    double fontSize =
        screenWidth * 0.04; // Puedes ajustar el factor según tus preferencias

    return descripcionItems.map((item) {
      return Row(
        children: [
          Icon(Icons.check_circle, size: 18),
          SizedBox(width: 8),
          Text(
            item,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 4, 68, 204)],
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
            context.go('/');
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
                  // setState(() {
                  //   _currentIndex = index;
                  // });
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
      elevation: 0, // Esto elimina la sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          // Agrega este bloque para el borde
          color: const Color.fromARGB(255, 0, 0, 0), // Color del borde
          width: 2.0, // Ancho del borde
        ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Empleado empleado) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
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
                      fontSize: 18, // Tamaño de letra aumentado a 28
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: _buildDescripcion(
                  empleado.descripcion.split(', '), screenWidth),
            ),
          ],
        ),
      ),
    );
  }
}
