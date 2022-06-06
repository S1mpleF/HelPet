import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpet/screens/loading_screen.dart';
import 'package:helpet/screens/signup_screen.dart';
import 'package:helpet/utilities/colors.dart';
import 'package:helpet/screens/home_screens/user_home_screen.dart';
import 'package:line_icons/line_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isPassowordVisible = false;
  String inputEmail = "";
  String inputPassword = "";
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerPasswordMail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGradientBackGround(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100.0,
                    ),
                    Image.asset(
                      'images/pet.png',
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    Text(
                      "HelPet",
                      style: GoogleFonts.manrope(
                        color: colorsFillColor,
                        fontSize: 60.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "Bu Dünya sadece Bize Ait Değil",
                      style: GoogleFonts.manrope(
                        color: colorsFillColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      onSaved: (value) {
                        inputEmail = value.toString();
                      },
                      validator: (value) {},
                      style: const TextStyle(
                        color: colorsSmoothDarkGrey,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          LineIcons.envelope,
                          color: colorsSmoothDarkGrey,
                        ),
                        hintText: "E Mail",
                        filled: true,
                        fillColor: colorsFillColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorsFillColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorsFillColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepOrangeAccent, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      onSaved: (value) {
                        inputPassword = value.toString();
                      },
                      validator: (value) {},
                      obscureText: !isPassowordVisible,
                      style: const TextStyle(
                        color: colorsSmoothDarkGrey,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: (!isPassowordVisible)
                            ? IconButton(
                                onPressed: changeVisibility,
                                icon: const Icon(
                                  LineIcons.eyeSlash,
                                  color: colorsSmoothDarkGrey,
                                ),
                              )
                            : IconButton(
                                onPressed: changeVisibility,
                                icon: const Icon(
                                  LineIcons.eye,
                                  color: colorsSmoothDarkGrey,
                                ),
                              ),
                        prefixIcon: const Icon(
                          LineIcons.lock,
                          color: colorsSmoothDarkGrey,
                        ),
                        hintText: "Parola",
                        filled: true,
                        fillColor: colorsFillColor,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: colorsFillColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: colorsFillColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepOrangeAccent, width: 2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Şifremi Unuttum?'),
                                    content: SizedBox(
                                      height: 135,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                              "Şifrenizi Sıfırlamak için mail adresinize bir e posta göndereceğiz"),
                                          TextField(
                                            onChanged: (value) {},
                                            controller: _controllerPasswordMail,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "E mail Adresiniz..."),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_controllerPasswordMail.text
                                                    .contains('@')) {
                                                  FirebaseAuth.instance
                                                      .sendPasswordResetEmail(
                                                          email:
                                                              _controllerPasswordMail
                                                                  .text)
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Şifre Sıfırlama Mailiniz Gönderildi',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }).catchError(
                                                          (error, stackTrace) {
                                                    Fluttertoast.showToast(
                                                        msg: error.toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Gönder'),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        colorsSmoothDarkGrey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text(
                            'Şifremi Unuttum?',
                            style: TextStyle(
                              color: colorsFillColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              color: colorsFillColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    // ignore: sized_box_for_whitespace
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: logIN,
                        child: Text(
                          "Giriş Yap",
                          style: GoogleFonts.manrope(
                              color: colorsFillColor, fontSize: 18.0),
                        ),
                        color: colorsSmoothDarkGrey,
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildGradientBackGround() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorsSubOrange, colorsMainOrange, colorsSubOrange],
        ),
      ),
    );
  }

  void changeVisibility() {
    setState(() {
      isPassowordVisible = !isPassowordVisible;
    });
  }

  void logIN() async {
    //Veritabanındaki Bilgiler İle User Giriş Yapıyor
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: inputEmail, password: inputPassword)
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoadingScreen(value.user!.uid)),
              (route) => false);
        });
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
            msg: e.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
