import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';

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
  String biografia; // Agrega el campo de biografía

  Empleado({
    required this.nombre,
    required this.cargo,
    required this.foto,
    this.correo = "",
    this.telefono = "",
    this.biografia = "", // Inicializa la biografía como una cadena vacía
  });
}

class _EquipoPageState extends State<EquipoPage> {
  final List<Empleado> empleados = [
    Empleado(
        nombre: "Juan Pérez",
        cargo: "Desarrollador",
        foto: "assets/renalizapp_icon.png",
        correo: "juan@hotmail.com",
        telefono: "1561531",
        biografia: "Juan Pérez es un desarrollador con experiencia en..."),
    Empleado(
        nombre: "María García",
        cargo: "Diseñadora",
        foto: "assets/renalizapp_icon.png",
        correo: "maria@hotmail.com",
        telefono: "5548531",
        biografia: "María García es una diseñadora creativa con un..."),
    Empleado(
        nombre: "Pedro Rodríguez",
        cargo: "Administrador",
        foto: "assets/renalizapp_icon.png",
        correo: "pedro@hotmail.com",
        telefono: "5561451",
        biografia: "Pedro Rodríguez es un administrador con experiencia en..."),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.purple
              ], // Cambia los colores del gradiente
              begin: Alignment.topLeft, // Cambia el inicio del gradiente
              end: Alignment.bottomRight, // Cambia el final del gradiente
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Menciones honoríficas",
                style: TextStyle(
                  color: Colors.white, // Cambia el color del texto
                  fontSize: 24, // Aumenta el tamaño del texto
                  fontWeight: FontWeight.bold, // Hace que el texto sea negrita
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la ruta específica
            context.go("/test"); // Reemplaza '/test' con la ruta que desees.
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
                height: 550, // Altura fija para las tarjetas
                viewportFraction:
                    0.85, // Fracción de la pantalla que ocupa cada tarjeta
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
      direction:
          FlipDirection.HORIZONTAL, // Puedes ajustar la dirección de volteo
      front: _buildFrontCard(empleado),
      back: _buildBackCard(empleado),
    );
  }

  Widget _buildFrontCard(Empleado empleado) {
    final double imageHeight = 300.0; // Altura fija para la imagen
    final double cardHeight = imageHeight + 100.0; // Ajusta según tu diseño

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          // Imagen del empleado
          Container(
            height: 350, // Establece la altura fija para la imagen
            width: 400, // Establece el ancho fijo para la imagen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(empleado.foto),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
          ),
          // Nombre y puesto con estilo
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.blue, // Cambia el color de fondo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  empleado.nombre,
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 24, // Aumenta el tamaño del texto
                    fontWeight:
                        FontWeight.bold, // Hace que el texto sea negrita
                  ),
                ),
                SizedBox(height: 8), // Espacio entre el nombre y el puesto
                Text(
                  empleado.cargo,
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 20, // Aumenta el tamaño del texto
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
          // Reverso de la tarjeta
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.blue, // Cambia el color de fondo
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "INFORMACIÓN ADICIONAL",
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 24, // Aumenta el tamaño del texto
                    fontWeight:
                        FontWeight.bold, // Hace que el texto sea negrita
                  ),
                ),
                SizedBox(
                    height: 16), // Espacio entre el encabezado y la información
                Text(
                  "Correo electrónico:",
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 20, // Aumenta el tamaño del texto
                  ),
                ),
                Text(
                  empleado.correo,
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 18, // Aumenta el tamaño del texto
                  ),
                ),
                SizedBox(height: 12), // Espacio entre el correo y el teléfono
                Text(
                  "Teléfono:",
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 20, // Aumenta el tamaño del texto
                  ),
                ),
                Text(
                  empleado.telefono,
                  style: TextStyle(
                    color: Colors.white, // Cambia el color del texto
                    fontSize: 18, // Aumenta el tamaño del texto
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espacio entre el teléfono y la biografía
          Text(
            "BIOGRAFÍA:",
            style: TextStyle(
              color: const Color.fromARGB(
                  255, 0, 0, 0), // Cambia el color del texto
              fontSize: 25, // Aumenta el tamaño del texto
            ),
          ),
          Text(
            empleado.biografia,
            style: TextStyle(
              color: const Color.fromARGB(
                  255, 0, 0, 0), // Cambia el color del texto
              fontSize: 18, // Aumenta el tamaño del texto
            ),
          ),
        ],
      ),
    );
  }
}
