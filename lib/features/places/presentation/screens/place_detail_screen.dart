import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/place.dart';
import '../../infraestructure/datasources/place_datasource_impl.dart';
import '../../infraestructure/repositories/places_repostory_impl.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String? uid;

  const PlaceDetailScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlacesRepositoryImpl placesRepository =
        PlacesRepositoryImpl(PlacesDatasourceImpl());

    final isMobile = MediaQuery.of(context).size.width < 450;
    Color mainColor = Theme.of(context).primaryColor;

    return FutureBuilder<Place>(
      future: placesRepository.getPlaceById(uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available.'));
        } else {
          final place = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Informacion sobre el centro",
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24, 
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: isMobile ? 150 : 200, 
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(place.photoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(isMobile ? 8.0 : 16.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.nombre,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24, 
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 16),
                        Text(
                          place.descripcion,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18, 
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 16), 
                        Row(
                          children: [
                             Icon(
                              Icons.location_on,
                              color:  mainColor,
                            ),
                            SizedBox(width: isMobile ? 4 : 8),
                            Text(
                              'Dirección: ${place.direccion}',
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 18, 
                                 color:  mainColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 8 : 16), // Ajuste de separación vertical adaptativo
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: mainColor,
                            ),
                            SizedBox(width: isMobile ? 4 : 8), // Ajuste de espaciado horizontal adaptativo
                            Text(
                              'Teléfono: ',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18, // Tamaño de fuente adaptativo
                                 color:  mainColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launch("tel://${place.telefono}");
                              },
                              child: Text(
                                '${place.telefono}',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 18, // Tamaño de fuente adaptativo
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 8 : 16), 
                        Row(
                          children: [
                             Icon(
                              Icons.map,
                              color: mainColor,
                            ),
                            SizedBox(width: isMobile ? 4 : 8), 
                            Text(
                              'Coordenadas: ${place.latitud.toStringAsFixed(6)}, ${place.longitud.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18, // Tamaño de fuente adaptativo
                                color:  mainColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(place.latitud, place.longitud);
              },
              child: const Icon(Icons.pin_drop),
            ),
          );
        }
      },
    );
  }
}
