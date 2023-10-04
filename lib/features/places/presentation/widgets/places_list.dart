import 'package:flutter/material.dart';
import 'place_card.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        
        PlaceCard(
          title: "Hospital Nacional",
          description: "Hospital de Jalapa al servicio del pueblo",
          photoUrl: "https://source.unsplash.com/random",
        ),
     
        PlaceCard(
          title: "IGGS Jalapa",
          description: "Iggs jalapa",
          photoUrl: "https://source.unsplash.com/random",
        ),
         
        PlaceCard(
          title: "UNAERC Jutiapa",
          description: "Unidad de dialisis",
          photoUrl: "https://source.unsplash.com/random",
        ),
      ],
    );
  }
}
