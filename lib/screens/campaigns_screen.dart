import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/models/admin.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({Key? key}) : super(key: key);

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanyalar'),
        backgroundColor: colorsSmoothDarkGrey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          //Veritabanından Kampanya Bilgileri Çekiliyor
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('campaigns').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = snapshot.data!.docs;
                return ListView.separated(
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: colorsSubLightOrange,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${docs[index].get('title')}",
                                style: GoogleFonts.manrope(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${docs[index].get('content')}",
                              style: GoogleFonts.manrope(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                const Icon(LineIcons.phone),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "${docs[index].get('phone')}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(LineIcons.moneyCheck),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "${docs[index].get('iban')}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(LineIcons.hospital),
                                Text(
                                  "${docs[index].get('ownerVeterinaryName')}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            (AdminInf.nameAndSurname != '') ? Container(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('campaigns')
                                      .doc(docs[index].id)
                                      .delete();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      colorsMainOrange),
                                ),
                                child: Row(
                                  children: [
                                    Text('Kampanyayı Sil'),
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
                    }),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: docs.length);
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
      ),
    );
  }
}
