import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/models/admin.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MissingScreen extends StatefulWidget {
  const MissingScreen({Key? key}) : super(key: key);

  @override
  State<MissingScreen> createState() => _MissingScreenState();
}

class _MissingScreenState extends State<MissingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsSmoothDarkGrey,
        title: const Text('Kayıp İhbarları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          //Veritabanından Kayıp İhbarları Çekiliyor
          stream: FirebaseFirestore.instance.collection('missing').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorsSubLightOrange,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Image.network(
                              docs[index].get('image'),
                              loadingBuilder:
                                  ((context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 160,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: colorsSmoothDarkGrey,
                                    ),
                                  ),
                                );
                              }),
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          const SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            docs[index].get('title'),
                            style: GoogleFonts.manrope(
                                fontSize: 19.0, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 60.0,
                            margin: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              child: Text(
                                docs[index].get('content'),
                                style: GoogleFonts.manrope(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: 
                              [
                                const SizedBox(width: 10.0,),
                                const Icon(LineIcons.user),
                                const SizedBox(width: 5.0,),
                                Text(
                                docs[index].get('ownerNameAndSurname'),
                                style: GoogleFonts.manrope(
                                    fontSize: 17.0,),
                              ),
                            ],
                          ),
                          Row(
                            children: 
                              [
                                const SizedBox(width: 10.0,),
                                const Icon(LineIcons.phone),
                                const SizedBox(width: 5.0,),
                                Text(
                                docs[index].get('ownerPhoneNumber'),
                                style: GoogleFonts.manrope(
                                    fontSize: 17.0,),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0,),
                          (AdminInf.nameAndSurname != '') ? Container(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('missing')
                                      .doc(docs[index].id)
                                      .delete();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      colorsMainOrange),
                                ),
                                child: Row(
                                  children: [
                                    Text('İhbarı Sil'),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.close))
                                  ],
                                ),
                              ),
                            ) : SizedBox(),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [colorsMainOrange],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
