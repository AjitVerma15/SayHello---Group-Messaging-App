import 'package:flutter/material.dart';

class Botton extends StatelessWidget {

  Botton({this.text,this.color,this.onpressed});
  final text;
  final color;
  final onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(text,style: TextStyle(),),
        ),
      ),
    );
  }
}