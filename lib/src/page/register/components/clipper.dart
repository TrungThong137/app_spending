import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path= Path();
    path.lineTo(0, size.height-30);
    path.lineTo(size.width, size.height-150);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}