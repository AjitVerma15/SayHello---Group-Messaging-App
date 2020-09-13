
import 'package:chatapp/components/dark.dart';
import 'package:chatapp/screen/ThemePage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screen/welcomescreen.dart';
import 'package:chatapp/screen/chat_screen.dart';
import 'package:chatapp/screen/registration_screen.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/dark.dart';
import 'package:provider/provider.dart';

String email;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  print(email);
  runApp(Chatapp()
  );
}

class Chatapp extends StatefulWidget {
  @override
  _ChatappState createState() => _ChatappState();
}

class _ChatappState extends State<Chatapp> {

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  DarkThemeProvider  themeProvider = DarkThemeProvider();
  @override


  getCurrentAppTheme() async{
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getThemes();
  }
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_){
            return themeChangeProvider;
          },
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context,value,Widget child){
          return MaterialApp(
            theme:Styles.themeData(themeChangeProvider.darkTheme, context),
            initialRoute: email == null ? WelcomeScreen.id : ChatScreen.id,
            routes: {
              WelcomeScreen.id:(context)=>WelcomeScreen(),
              LoginScreen.id :(context)=>LoginScreen(),
              RegistrationScreen.id:(context)=>RegistrationScreen(),
              ChatScreen.id :(context)=>ChatScreen(),
            },
          );
        },
      ),
    );
  }
}


