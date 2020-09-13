import 'package:day_night_switch/day_night_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/components/dark.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedinuser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageTextcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

//  void getMessages() async {
//  final messages = await _firestore.collection('messages').getDocuments();
//  for (var message in messages.documents){
//    print(message.data);
//  }
//  }

//  void messageStream() async {
//    await for (var snapshot in _firestore.collection('messages').snapshots()) {
//      for (var message in snapshot.documents) {
//        print(message.data);
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          Transform.scale(
            scale: 0.3,
            child:DayNightSwitch(
              value: themeChange.darkTheme,
              onChanged: (bool value){
                themeChange.darkTheme = value;
              },
            ),
          ),
          FlatButton(
            child: Text("Log out"),
            onPressed: () async {
              _auth.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              Navigator.pop(context);
            },
          ),
        ],
        title: Text("Chat"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                           width: 2.0))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextcontroller,
                      style: TextStyle(),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(),
                          border: InputBorder.none),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _messageTextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedinuser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      "Sent",
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubble = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageTime = message.data['time'] as Timestamp;
          final currentUser = loggedinuser.email;

          final messageWidget = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            time: messageTime,
          );
          messageBubble.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubble,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.time});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
//                ' ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}',
            style: TextStyle(fontSize: 12.0),
          ),
          SizedBox(
            height: 6,
          ),
          Material(
              elevation: 5.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              color: isMe ? null : Colors.white54,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 15,),
//                      color: isMe ? Colors.white : Colors.black45),
                ),
              )),
        ],
      ),
    );
  }
}
