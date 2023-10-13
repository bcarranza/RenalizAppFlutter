
import 'package:dio/dio.dart';
import 'package:renalizapp/config/constants/environment.dart';
import 'package:renalizapp/features/places/domain/datasources/places_datasource.dart';
import 'package:renalizapp/features/places/domain/entities/place.dart';

import '../mappers/place_mapper.dart';


class PlacesDatasourceImpl extends PlacesDataSource {

  late final Dio dio;

  PlacesDatasourceImpl() : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    )
  );




@override
Future<Place> getPlaceById(String uid) async {
  try {
    final Map<String, dynamic> requestBody = {
      'uid': uid,
    };

    final response = await dio.post('getLugaresAtencionbyUID', data: requestBody);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;
      final Map<String, dynamic> lugarData = responseData['lugar'];

      // ignore: unnecessary_null_comparison
      if (lugarData != null) {
        return PlaceMapper.jsonToEntity(lugarData);
      } else {
        throw Exception('No se encontraron datos de lugar en la respuesta.');
      }
    } else {
      throw Exception('La solicitud falló con el código de estado: ${response.statusCode}');
    }
  } catch (e) {
   
    throw e; // Vuelve a lanzar la excepción para manejarla más adelante si es necesario.
  }
}

@override
Future<List<Place>> getPlaces() async {
  try {
    final response = await dio.get('getLugaresAtencion');
    final List<Place> places = [];

    if (response.statusCode == 200) {
      final data = response.data;
      if (data != null && data['lugares'] is List) {
        final lugares = data['lugares'] as List<dynamic>;
        for (var placeData in lugares) {
          
          places.add(PlaceMapper.jsonToEntity(placeData));
        }
      } else {
        
      }
    } else {
      
    }

    return places;
  } catch (e) {
    rethrow; // Rethrow the exception to handle it further if needed.
  }
}


}