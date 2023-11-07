import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coffee {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;
  Double latitud;
  Double longitud;

  Coffee(
      {this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.locationCoords,
      this.latitud,
      this.longitud});
}

final List<Coffee> coffeeShops = [
  Coffee(
      shopName: 'Se vende pan del nico',
      address: 'soto mayor con manuel rodroguez',
      description: 'pan muy rico',
      locationCoords: LatLng(-35.8456, -71.5969),
      thumbNail:
          'https://s1.eestatic.com/2015/03/24/cocinillas/Cocinillas_20507999_115826465_1706x960.jpg'),
  Coffee(
      shopName: 'cafecito y tecito',
      address: 'en toa la esquina',
      description: 'se pueden tomar un rico te o un rico cafe',
      locationCoords: LatLng(-35.8462, -71.5973),
      thumbNail:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1280px-A_small_cup_of_coffee.JPG'),
  Coffee(
      shopName: 'ropa de la mama del seba',
      address: 'cerca de la plaza',
      description: 'ropa americana recien importada',
      locationCoords: LatLng(-35.8451, -71.5989),
      thumbNail:
          'https://economiasustentable.com/wp-content/uploads/2020/01/ropa-825x510.png'),
];
