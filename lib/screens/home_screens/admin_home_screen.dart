import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpet/models/admin.dart';
import 'package:helpet/models/veterinary.dart';
import 'package:helpet/screens/campaigns_screen.dart';
import 'package:helpet/screens/login_screen.dart';
import 'package:helpet/screens/missing_screen.dart';
import 'package:helpet/screens/permission_screen.dart';
import 'package:helpet/services/polyline_service.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(38.3855, 27.1747),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController _newGoogleMapController;

  int indexVeterinary = -1;

  var _markers = <Marker>{};
  Set<Polyline> _polylines = {};
  var listVeterinary = <VeterinaryLoad>[];

  late BitmapDescriptor veterinaryMarker;

  setVeterinaryMarker() async {
    veterinaryMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(5.0, 5.0),
        ),
        'images/veterinaryLocationx128.png');
  }

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    setVeterinaryMarker();
    getVeterinariansLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsSmoothDarkGrey,
        centerTitle: true,
        title: Text('Hoşgeldin, ${AdminInf.nameAndSurname}'),
      ),
      drawer: buildDrawerList(),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              padding: (indexVeterinary != -1)
                  ? const EdgeInsets.only(bottom: 350)
                  : EdgeInsets.zero,
              onTap: (value) {
                setState(() {
                  _polylines.clear();
                  indexVeterinary = -1;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                _newGoogleMapController = controller;
                locatePosition();
              },
              polylines: _polylines,
              markers: _markers,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              left: 0,
              right: 0,
              bottom: (indexVeterinary != -1) ? 0 : -500,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorsFillColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  height: 350,
                  child: Column(
                    children: [
                      (indexVeterinary == -1 ||
                              listVeterinary[indexVeterinary].image == '')
                          ? Image.asset('images/hospital.png')
                          : ClipRRect(
                              child: Image.network(
                                listVeterinary[indexVeterinary].image,
                                loadingBuilder:
                                    ((context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    child: const Center(
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.pacman,
                                        colors: [colorsSmoothDarkGrey],
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(32.0),
                                  topLeft: Radius.circular(32.0)),
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(LineIcons.medicalClinic),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            (indexVeterinary == -1)
                                ? ''
                                : listVeterinary[indexVeterinary].name,
                            style: GoogleFonts.manrope(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(LineIcons.phone),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            (indexVeterinary == -1)
                                ? ''
                                : listVeterinary[indexVeterinary].phoneNumber,
                            style: GoogleFonts.manrope(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13.0,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        child: MaterialButton(
                          onPressed: () async {
                            Position position =
                                await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high);
                            LatLng latLngPosition =
                                LatLng(position.latitude, position.longitude);
                            Polyline polyline =
                                await PolylineService.drawPolyline(
                                    latLngPosition,
                                    listVeterinary[indexVeterinary].location);
                            setState(() {
                              _polylines.clear();
                              _polylines.add(polyline);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                FontAwesomeIcons.waveSquare,
                                color: colorsFillColor,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'ROTA OLUŞTUR',
                                style: TextStyle(
                                    color: colorsFillColor, fontSize: 17.0),
                              ),
                            ],
                          ),
                          color: colorsSubOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getVeterinariansLoc() {
    //Veritabanından Veteriner Bilgileri Çekiliyor
    FirebaseFirestore.instance.collection('veterinarians').get().then((value) {
      var docs = value.docs;
      for (var i = 0; i < docs.length; i++) {
        var indexDoc = docs[i];
        setState(() {
          listVeterinary.add(
            VeterinaryLoad(
                indexDoc.get('name'),
                indexDoc.get('phoneNumber'),
                indexDoc.get('image'),
                LatLng(indexDoc.get('location').latitude,
                    indexDoc.get('location').longitude)),
          );
          _markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              onTap: () {
                setState(() {
                  indexVeterinary = i;
                });
                _newGoogleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: listVeterinary[i].location,
                  zoom: 14,
                )));
              },
              icon: veterinaryMarker,
              infoWindow: InfoWindow(title: indexDoc.get('name')),
              position: LatLng(indexDoc.get('location').latitude,
                  indexDoc.get('location').longitude),
            ),
          );
        });
      }
    });
  }

  Drawer buildDrawerList() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              color: colorsMainOrange,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: colorsFillColor,
                    ),
                    child: Center(
                        child: Image.asset(
                      "images/pet.png",
                      width: 90,
                      height: 90,
                    )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "HelPet",
                        style: GoogleFonts.manrope(
                          color: colorsFillColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        "Onlar da arkadaşımız",
                        style: GoogleFonts.manrope(
                          color: colorsFillColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Kayıp İhbarları'),
            leading: const Icon(LineIcons.paw),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MissingScreen(),
                  ));
            },
          ),
          ListTile(
            title: const Text('Kampanyalar'),
            leading: Image.asset(
              'images/campaignClean.png',
              width: 30,
              height: 30,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CampaignScreen()));
            },
          ),
          ListTile(
            title: const Text('Yetki İstekleri'),
            leading: const Icon(LineIcons.userLock),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PermissionScreen()));
            },
          ),
          ListTile(
            title: const Text('Çıkış Yap'),
            leading: const Icon(FontAwesomeIcons.arrowRightFromBracket),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
