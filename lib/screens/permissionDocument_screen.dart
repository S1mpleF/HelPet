import 'package:flutter/material.dart';
import 'package:helpet/utilities/colors.dart';

class PermissionDocumentScreen extends StatefulWidget {
  String imgURL;
  PermissionDocumentScreen(this.imgURL, {Key? key}) : super(key: key);

  @override
  State<PermissionDocumentScreen> createState() =>
      _PermissionDocumentScreenState();
}

class _PermissionDocumentScreenState extends State<PermissionDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Veritabanındaki İzin Belgesini Büyük Hali ile gösteren Ekran
      appBar: AppBar(
        title: const Text("İzin Belgesi"),
        backgroundColor: colorsSmoothDarkGrey,
      ),
      body: SafeArea(
          child: Center(
              child: Image.network(
        widget.imgURL,
        fit: BoxFit.fitWidth,
      ))),
    );
  }
}
