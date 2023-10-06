

import '../entities/place.dart';

abstract class PlaceRepository {

  Future<List<Place>> getPlaces ();

  Future<Place> getPlaceById (String id);

}