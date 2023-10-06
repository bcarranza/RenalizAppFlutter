import '../../domain/entities/place.dart';

class PlaceMapper {
  static Place jsonToEntity(Map<String, dynamic> json) {
    return Place(
      nombre: json['Nombre'] as String,
      descripcion: json['Descripcion'] as String,
      direccion: json['Direccion'] as String,
      telefono: json['Telefono'], // Convert to string
      latitud: (json['Coordenadas']['_latitude'] as double).toDouble(),
      longitud: (json['Coordenadas']['_longitude'] as double).toDouble(),
      photoUrl: json['photoUrl'] as String,
      uid: json['UID'] as String,
    );
  }
}
