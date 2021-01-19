import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:login_demo_for_finlite/provider/NoValueNotifier.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home (Chat Boat)'),
      ),
      body: Column(children: [
        Flexible(child: Consumer<NoValueNotifier>(
          builder: (BuildContext context, NoValueNotifier value, Widget child) {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _chatText[index],
              itemCount: _chatText.length,
            );
          },
        )),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: bottomTextLayout(),
        ),
      ]),
    );
  }

  List<ChatClass> _chatText = <ChatClass>[];
  TextEditingController _messageTextController = TextEditingController();

  void errorListener(SpeechRecognitionError errorNotification) {
    print(errorNotification.toString());
  }

  void _initSpeechToText() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(
        onStatus: (status) {
          print('status : $status');
          if (status == 'notListening') {
            print('here navigation');
          }
//          statusListener(status, searchQuery,context);
        },
        onError: errorListener);
    if (available) {
      speech.listen(onResult: (result) {
        _messageTextController.text = result.recognizedWords;
        print(result.recognizedWords);
        if (result.finalResult) {
          if (_messageTextController.text.isNotEmpty) {
            Future.delayed(Duration(seconds: 1), () {
              _submit(_messageTextController.text);
            });
          }
        }
      });
    } else
      print("not available or permission denied.");
  }

  Widget bottomTextLayout() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageTextController,
                onSubmitted: _submit,
                decoration: InputDecoration.collapsed(hintText: "Send message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _submit(_messageTextController.text);
                  }),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    _initSpeechToText();
                    // _submit(_textController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void chatBoatCall(query) async {
    _messageTextController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatClass message = ChatClass(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      name: "Bot",
      type: false,
    );

    _chatText.insert(0, message);
    Provider.of<NoValueNotifier>(context, listen: false).notify();
  }

  void _submit(String text) {
    _messageTextController.clear();
    ChatClass message = ChatClass(
      text: text,
      name: "Dhiren",
      type: true,
    );

    _chatText.insert(0, message);
    Provider.of<NoValueNotifier>(context, listen: false).notify();

    chatBoatCall(text);
  }
}

class ChatClass extends StatelessWidget {
  ChatClass({this.text, this.name, this.type});

  final bool type;
  final String text, name;

  List<Widget> opponentMessageLeftAligned(context) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(child: Text('B')),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> iMessageRightAligned(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name, style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
            child: Text(
          this.name[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type
            ? iMessageRightAligned(context)
            : opponentMessageLeftAligned(context),
      ),
    );
  }
}
