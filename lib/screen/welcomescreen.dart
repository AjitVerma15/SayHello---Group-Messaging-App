import 'package:chatapp/components/dark.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screen/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/components/botton.dart';
import 'package:provider/provider.dart';
import 'package:day_night_switch/day_night_switch.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.grey,end: Colors.white,).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:200.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          child: Image.asset('images/Hello.png'),
                          height: 60.0,
                        ),
                      ),
                      SizedBox(width: 15,),
                      TypewriterAnimatedTextKit(
                        text:["Say Hello"],
                        textStyle: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  TypewriterAnimatedTextKit(
                    textAlign: TextAlign.center,
                    text: ["Group Messaging App"],
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Botton(text: "Log In",onpressed: (){
                    Navigator.pushNamed(context, LoginScreen.id);
                  },),
                  Botton(text: "Register",onpressed: (){
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.all(15.0),
        child: Text("Made with ❤ by Ajit Verma",style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
      )
      ,
    );
  }
}


