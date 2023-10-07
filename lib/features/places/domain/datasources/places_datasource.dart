

import '../entities/place.dart';

abstract class PlacesDataSource {

  Future<List<Place>> getPlaces ();

  Future<Place> getPlaceById (String id);

}