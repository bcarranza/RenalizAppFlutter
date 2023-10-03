

import 'package:renalizapp/features/places/domain/domain.dart';

class PlacesRepositoryImpl extends PlaceRepository {


  final PlacesDataSource dataSource;

  PlacesRepositoryImpl(this.dataSource);


  @override

 Future<Place> getPlaceById (String id){
    return dataSource.getPlaceById(id);
 }
 
  @override
  Future<List<Place>> getPlaces() {
    return dataSource.getPlaces();
  }

}

