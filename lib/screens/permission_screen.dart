import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/screens/permissionDocument_screen.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //Veritabanından Yetki İstekleri Çekiliyor
      stream: FirebaseFirestore.instance.collection('permissions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Veteriner İzin Belgeleri"),
                backgroundColor: colorsSmoothDarkGrey,
              ),
              body: Center(
                child: Text(
                  'Herhangi Bir Veteriner İzin Belgesi Bulunamadı',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 30.0,
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Veteriner İzin Belgeleri"),
                backgroundColor: colorsSmoothDarkGrey,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: colorsMainOrange,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(LineIcons.fileContract),
                                      Text(
                                        docs[index].get('veterinaryName'),
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('veterinarians')
                                              .doc(docs[index].id)
                                              .update({
                                            'permission': true,
                                          }).then((value) async {
                                            await FirebaseFirestore.instance
                                                .collection('permissions')
                                                .doc(docs[index].id)
                                                .delete();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Veteriner İzin Belgesi Onaylandı',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                fontSize: 16.0);
                                          }).onError((error, stackTrace) {
                                            Fluttertoast.showToast(
                                                msg: error.toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    colorsSmoothDarkGrey)),
                                        child: Row(
                                          children: const [
                                            Icon(FontAwesomeIcons.check),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text('Onayla'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('permissions')
                                              .doc(docs[index].id)
                                              .delete()
                                              .then((value) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'İzin Belgesi İsteği Silindi',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    colorsSmoothDarkGrey)),
                                        child: Row(
                                          children: const [
                                            Icon(FontAwesomeIcons.xmark),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text('Sil'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PermissionDocumentScreen(
                                                    docs[index].get(
                                                        'permissionDocument'),
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      size: 28,
                                    ),
                                    color: colorsSmoothDarkGrey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: docs.length),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            backgroundColor: colorsSmoothDarkGrey,
            body: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 2,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballRotate,
                  colors: [colorsMainOrange],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
