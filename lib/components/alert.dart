import 'package:flutter/material.dart';



class Alert extends StatelessWidget {

  Alert({this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4.0,
      title: Row(
        children: <Widget>[
          Icon(Icons.error,color: Colors.lightBlueAccent,),
          SizedBox(width: 5,),
          Text("Alert",style: TextStyle(color: Colors.black),),
        ],
      ),
      content: Text(errorMessage,style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Close",style: TextStyle(color: Colors.lightBlueAccent)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}