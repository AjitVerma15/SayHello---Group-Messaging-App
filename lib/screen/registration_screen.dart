import 'package:chatapp/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/botton.dart';
import 'package:chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:chatapp/components/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


String errorMessage;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  String email;
  String password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/Hello.png'),
                    height: 200,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  style: TextStyle(),
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: _obscureText,
                  style: TextStyle(),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: new Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    ),
                  )),
              SizedBox(
                height: 24.0,
              ),
              Botton(
                text: "Register",
                onpressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if(newuser != null){
                     SharedPreferences pref= await SharedPreferences.getInstance();
                     pref.setString('email',email);
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner=false;
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner=false;
                    });
                    print(e);
                    switch (e.code) {
                      case "ERROR_INVALID_EMAIL":
                        errorMessage = "Your email address appears to be malformed.";
                        break;
                      case "ERROR_WRONG_PASSWORD":
                        errorMessage = "Your password is wrong.";
                        break;
                      case "ERROR_USER_NOT_FOUND":
                        errorMessage = "User with this email doesn't exist.";
                        break;
                      case "ERROR_USER_DISABLED":
                        errorMessage = "User with this email has been disabled.";
                        break;
                      case "ERROR_TOO_MANY_REQUESTS":
                        errorMessage = "Too many requests. Try again later.";
                        break;
                      case "ERROR_OPERATION_NOT_ALLOWED":
                        errorMessage = "Signing in with Email and Password is not enabled.";
                        break;
                      case "ERROR_NETWORK_REQUEST_FAILED":
                        errorMessage = "Internet Connection Problem";
                        break;
                      case "ERROR_EMAIL_ALREADY_IN_USE":
                        errorMessage = "The email address is already in use by another account.";
                        break;
                      default:
                        errorMessage = "An undefined Error happened.";
                    }
                    setState(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return Alert(errorMessage:errorMessage);
                        },
                      );
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
