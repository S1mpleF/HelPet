import 'package:google_maps_flutter/google_maps_flutter.dart';

class VeterinaryInf{
  static String name = '';
  static String phoneNumber = '';
  static String image = '';
  static String iban = '';
  static LatLng location = LatLng(0, 0);
  static bool permission = false;
}

class VeterinaryLoad{
  String name;
  String phoneNumber;
  String image;
  LatLng location;

  VeterinaryLoad(this.name, this.phoneNumber, this.image, this.location);
}