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
          "Hospital Nacional",
          "Hospital de Jalapa al servicio del pueblo",
          "https://scontent.fgua3-3.fna.fbcdn.net/v/t1.6435-9/66689314_2798277160202203_7092391882294034432_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=730e14&_nc_ohc=Nk1IGWtKnBwAX9SqZQA&_nc_ht=scontent.fgua3-3.fna&oh=00_AfDzgzS2U2qBSO3xQ8vtgwTME6zV-vOYHNp0BHYiXjyUDA&oe=65442423",
        ),
        PlaceCard(
          "IGGS Jalapa",
          "Iggs jalapa",
          "https://www.prensalibre.com/wp-content/uploads/2018/12/74852070-b32f-4e78-8ef3-fde74f88bf18.jpg?quality=52&w=600&h=400&crop=1",
        ),
        PlaceCard(
          "UNAERC Jutiapa",
          "Unidad de dialisis",
          "https://scontent.fgua9-1.fna.fbcdn.net/v/t39.30808-6/306783697_5135327929904448_1349554888886518418_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=49d041&_nc_ohc=lMMV8cn7PogAX_lYqYK&_nc_ht=scontent.fgua9-1.fna&oh=00_AfDhiKOp8mQv1QZjPZi058uQxj2LN9GSXbYv6py2Y3TBkQ&oe=652243FD",
        ),
      ],
    );
  }
}
