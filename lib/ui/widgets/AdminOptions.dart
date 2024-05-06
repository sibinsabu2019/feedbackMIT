import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Selectoption extends StatelessWidget {
  void Function()? onTap;
  String? option;
  IconData? icon;
   Selectoption({
    super.key,required this.onTap,
    required this.option,required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: onTap,
     child: Column(
       children: [
         ListTile(leading: Icon(icon),
          title: Text(option!),),
         Divider(color: Colors.blueGrey[400],)
       ],
     ));
  }
}