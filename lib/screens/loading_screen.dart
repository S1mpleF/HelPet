import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpet/models/admin.dart';
import 'package:helpet/models/user.dart';
import 'package:helpet/models/veterinary.dart';
import 'package:helpet/screens/home_screens/admin_home_screen.dart';
import 'package:helpet/screens/home_screens/user_home_screen.dart';
import 'package:helpet/screens/home_screens/veterinary_home_screen.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatefulWidget {
  String userID;
  LoadingScreen(this.userID, {Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    buildLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsSmoothDarkGrey,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width/2,
          child: const LoadingIndicator(
              indicatorType: Indicator.ballRotate,
              colors: [colorsMainOrange],
            ),
        ),
      ),
    );
  }

  void buildLogIn() {
    //Veritabanından Gerekli Kişisel Bilgiler Çekiliyor
    AdminInf.nameAndSurname = '';
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .get()
        .then((value) {
      if (value.exists) {
        UserInf.name = value.get('nameAndSurname');
        UserInf.phone = value.get('phoneNumber');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => const UserHomePage(),
            ), (route) => false);
      } else {
        FirebaseFirestore.instance
            .collection('admins')
            .doc(widget.userID)
            .get()
            .then((value) {
          if (value.exists) {
            AdminInf.nameAndSurname = value.get('nameAndSurname');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => const AdminHomeScreen(),
            ), (route) => false);
          } else {
            FirebaseFirestore.instance
                .collection('veterinarians')
                .doc(widget.userID)
                .get()
                .then((value) {
              if (value.exists) {
                VeterinaryInf.name = value.get('name');
                VeterinaryInf.phoneNumber = value.get('phoneNumber');
                VeterinaryInf.iban = value.get('iban');
                VeterinaryInf.permission = value.get('permission');
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const VeterinaryHomeScreen()), (route) => false);
              }
            }).onError((error, stackTrace) {
              print(error);
            });
          }
        }).onError((error, stackTrace) {
          print(error);
        });
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
