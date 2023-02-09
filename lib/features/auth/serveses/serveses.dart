import 'package:flutter/material.dart';

void navigatTo(context, Widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));

void navigatAndFinsh(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Widget),
      (route) => false,
    );