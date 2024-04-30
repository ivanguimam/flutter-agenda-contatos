import 'dart:io';

import 'package:flutter/material.dart';

class ContactImage extends StatelessWidget {
  String? img;

  double height = 80;
  double width = 80;

  ContactImage(this.img, this.height, this.width, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider defaultImage = const AssetImage('images/person.png');
    BoxDecoration boxDecoration = BoxDecoration(
      image: DecorationImage(
        image: img == null ? defaultImage : FileImage(File(img!)),
      ),
      shape: BoxShape.circle,
    );

    Container imageContainer = Container(
      decoration: boxDecoration,
      height: height,
      width: width,
    );

    return imageContainer;
  }
}
