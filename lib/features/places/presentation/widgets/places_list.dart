import 'package:flutter/material.dart';
import '../../domain/entities/place.dart';
import '../../infraestructure/datasources/place_datasource_impl.dart';
import '../../infraestructure/repositories/places_repostory_impl.dart';
import 'place_card.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  final PlacesRepositoryImpl _placesRepository = PlacesRepositoryImpl(PlacesDatasourceImpl());
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _placesRepository.getPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final places = snapshot.data ?? [];
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return PlaceCard(place: places[index]);
            },
          );
        }
      },
    );
  }
}
