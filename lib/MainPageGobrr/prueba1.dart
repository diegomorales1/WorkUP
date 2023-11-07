import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AddPyme());
}

class AddPyme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Up Pyme',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Work Up Pyme'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _launched;
  String _phone = '';
  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        forceSafariVC: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendmail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.redAccent,
                onPressed: () => setState(() {
                  _launched = _sendmail(
                      'mailto:workupstore@gmail.com?subject=News&body=New%20plugin');
                }),
                child: const Text('pyme time!'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              RaisedButton(
                color: Colors.purple,
                onPressed: () => setState(() {
                  _launched = _launchInWebViewOrVC(
                      "https://issetechmt.wixsite.com/website-1");
                }),
                child: const Text('Work Up Blog'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              RaisedButton(
                color: Colors.orange,
                onPressed: () => setState(() {
                  _launched = _launchInWebViewOrVC(
                      "https://www.youtube.com/channel/UCm5cjrSH4XWXSgjD7AnCdnA?view_as=subscriber");
                }),
                child: const Text('Work Up video presentacion'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
