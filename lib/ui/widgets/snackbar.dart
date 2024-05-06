import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomSnackbar
{
  Text? text;
  static success( BuildContext context,String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message),backgroundColor: Colors.green, ));
  }
  static ErrorSnackbar( BuildContext context,String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message),backgroundColor: Colors.red, ));
  }
}