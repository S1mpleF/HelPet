import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/models/user.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddMissing extends StatefulWidget {
  const AddMissing({Key? key}) : super(key: key);

  @override
  State<AddMissing> createState() => _AddMissingState();
}

class _AddMissingState extends State<AddMissing> {
  final _editingControllerContent = TextEditingController();
  final _editingControllerHeader = TextEditingController();

  File? image;
  String imageURL = '';

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
        title: const Text('Kayıp İhbarı Ekle'),
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
                      hintText: 'Kayıp İhbar Başlığı'),
                  controller: _editingControllerHeader,
                  maxLength: 50,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Kayıp İçeriği'),
                  controller: _editingControllerContent,
                  maxLines: 4,
                  minLines: 4,
                  maxLength: 150,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  imageURL,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 20.0,
                  ),
                ),
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
                  child: const Text('Evcil Hayvan Fotoğrafı'),
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
                      //Veritabanına Kayıp İhbarı Yükleniyor
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference ref = storage
                          .ref()
                          .child(image!.path + DateTime.now().toString());
                      await ref.putFile(image!);
                      String url = await ref.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection('missing')
                          .add({
                            'image': url,
                        'title': _editingControllerHeader.text,
                        'content': _editingControllerContent.text,
                        'ownerNameAndSurname': UserInf.name,
                        'ownerPhoneNumber': UserInf.phone,
                        'ownerID': FirebaseAuth.instance.currentUser!.uid,
                      }).then((value) {
                        setState(() {
                          _editingControllerContent.clear();
                          _editingControllerHeader.clear();
                          imageURL = '';
                        });
                        Fluttertoast.showToast(
                            msg: 'Kayıp İhbarınız Oluşturuldu',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                            msg: error.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    },
                    child: const Text('İhbar Ekle'),
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
