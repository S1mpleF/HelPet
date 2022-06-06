import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mail = TextEditingController();
  TextEditingController _phone = TextEditingController();
  MaskTextInputFormatter _phoneMask = MaskTextInputFormatter(
      mask: '(###) ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsSmoothDarkGrey,
        title: const Text('Kayıt Ol'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(LineIcons.user),
                    border: OutlineInputBorder(),
                    hintText: 'AD SOYAD'),
                textInputAction: TextInputAction.next,
                controller: _name,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(LineIcons.envelope),
                    border: OutlineInputBorder(),
                    hintText: 'E MAIL'),
                    keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _mail,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(LineIcons.phone),
                    border: OutlineInputBorder(),
                    hintText: 'TELEFON NUMARASI'),
                inputFormatters: [_phoneMask],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: _phone,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(LineIcons.lock),
                    border: OutlineInputBorder(),
                    hintText: 'ŞİFRE'),
                controller: _password,
              ),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(colorsSmoothDarkGrey)),
                  onPressed: () async {
                    //Veritabanına Yeni User Kaydı Oluşturuluyor
                    SimpleFontelicoProgressDialog _dialog =
                        SimpleFontelicoProgressDialog(
                            context: context, barrierDimisable: false);
                    _dialog.show(
                        message: 'Yükleniyor...',
                        type: SimpleFontelicoProgressDialogType.normal);
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _mail.text, password: _password.text)
                        .then((value) async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(value.user!.uid)
                          .set({
                        'nameAndSurname': _name.text,
                        'phoneNumber': _phone.text,
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Hesap Oluşturuldu',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0);
                      });
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: error.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  },
                  child: const Text('Kayıt Ol'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
