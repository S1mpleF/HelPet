import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/models/veterinary.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class AddCampaignScreen extends StatefulWidget {
  const AddCampaignScreen({Key? key}) : super(key: key);

  @override
  State<AddCampaignScreen> createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  @override
  Widget build(BuildContext context) {
    if (VeterinaryInf.permission) {
      return const AddCampaign();
    } else {
      return const TakePermission();
    }
  }
}

class AddCampaign extends StatefulWidget {
  const AddCampaign({Key? key}) : super(key: key);

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  final _editingControllerContent = TextEditingController();
  final _editingControllerHeader = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Ekle'),
        backgroundColor: colorsSmoothDarkGrey,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kampanya Başlığı'),
                  controller: _editingControllerHeader,
                  maxLength: 50,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kampanya İçeriği'),
                  controller: _editingControllerContent,
                  maxLines: 4,
                  minLines: 4,
                  maxLength: 150,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorsSmoothDarkGrey)),
                    onPressed: () async {
                      //Veritabanına Kampanya İlanı Yükleniyor
                      await FirebaseFirestore.instance
                          .collection('campaigns')
                          .add({
                        'title': _editingControllerHeader.text,
                        'content': _editingControllerContent.text,
                        'ownerVeterinaryName': VeterinaryInf.name,
                        'ownerVeterinaryID':
                            FirebaseAuth.instance.currentUser!.uid,
                            'iban': VeterinaryInf.iban,
                            'phone': VeterinaryInf.phoneNumber,
                      }).then((value) {
                        setState(() async{
                          _editingControllerContent.clear();
                          _editingControllerHeader.clear();
                          await FirebaseFirestore.instance.collection('veterinarians').doc(FirebaseAuth.instance.currentUser!.uid).update({
                            'permission': false,
                          }).then((value) {
                            VeterinaryInf.permission = false;
                            Navigator.pop(context);
                          });
                          Fluttertoast.showToast(
                            msg: 'Kampanya İlanınız Oluşturuldu',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        });
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                            msg: error.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    },
                    child: const Text('Kampanya Ekle'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TakePermission extends StatefulWidget {
  const TakePermission({Key? key}) : super(key: key);

  @override
  State<TakePermission> createState() => _TakePermissionState();
}

class _TakePermissionState extends State<TakePermission> {
  File? image;
  String imageURL =
      'Bu işlemi yapabilmek için kampanya yetkisine ihtiyacınız vardır.';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final temporaryImage = File(image.path);
      Navigator.pop(context);
      setState(() {
        this.image = temporaryImage;
        imageURL = temporaryImage.path;
        print(temporaryImage.path);
      });
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final temporaryImage = File(image.path);
      Navigator.pop(context);
      setState(() {
        this.image = temporaryImage;
        imageURL = temporaryImage.path;
        print(temporaryImage.path);
      });
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Yetkilendirme'),
        backgroundColor: colorsSmoothDarkGrey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                VeterinaryInf.name,
                style: GoogleFonts.manrope(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Text(
                imageURL,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Camera'),
                                    onTap: pickImageCamera,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text('Gallery'),
                                    onTap: pickImage,
                                  ),
                                ],
                              ));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorsSubOrange)),
                    child: const Text('Belge Fotoğrafı'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (image == null) {
                        Fluttertoast.showToast(
                            msg: 'Lütfen Belgenizi Seçiniz',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        //Veritabanına Belge Bilgileri Yükleniyor
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference ref = storage
                            .ref()
                            .child(image!.path + DateTime.now().toString());
                        await ref.putFile(image!);
                        String url = await ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('permissions')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'id': FirebaseAuth.instance.currentUser!.uid,
                          'veterinaryName': VeterinaryInf.name,
                          'permissionDocument': url,
                        }).then((value) {
                          Fluttertoast.showToast(
                            msg: 'Belgeniz Başarıyla Yüklendi - ONAY BEKLENIYOR',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0);
                        });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorsSmoothDarkGrey)),
                    child: const Text('Belgeyi Yükle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
