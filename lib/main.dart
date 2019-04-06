import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colombia',
      theme: ThemeData(fontFamily: 'WorkSans'),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  int index = 0;
  List colors = [
    [Colors.cyan, Color(0xFF4FC3F7), Color(0xFFC2B280)],
    [Color(0xFF00283a), Color(0xFF1c698c), Color(0xFF99874f)],
  ];
  List question = [
    "Which continent is Colombia in?",
    "What is the capital?",
    "What is the official language?",
    "Which artist is from Colombia?"
  ];
  List options = [
    ['Africa', 'Asia', 'America'],
    ['Bogotá', 'Medellin', 'Cali'],
    ['English', 'Portuguese', 'Spanish'],
    ['Selena', 'Shakira', 'Pitbull']
  ];
  List answer = [2, 0, 2, 1];
  List img = ['q1', 'q2', 'q3', 'q4'];

  TextStyle _titleStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white);

  _play() async {
    int result = await audioPlayer.play("https://bit.ly/2WQLdcG");
    if (result != 1) {}
  }

  Widget _getBackground() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.7, 0.8],
                colors: colors[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Colombia', style: _titleStyle),
        Padding(
          padding: EdgeInsets.all(9),
          child: Text(
            'Test your knowledge of this beautiful country',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Swiper(
          onIndexChanged: (int idx) => setState(() => index = idx & 1),
          itemBuilder: (BuildContext context, int idx) =>
              InfoCard(question[idx], options[idx], answer[idx], img[idx]),
          itemCount: question.length,
          itemWidth: 400,
          itemHeight: MediaQuery.of(context).size.height * 0.7,
          layout: SwiperLayout.STACK,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _play();
    return Scaffold(
      body: Stack(children: <Widget>[_getBackground(), _getContent()]),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List options;
  final int answer;
  final String img;

  InfoCard(this.title, this.options, this.answer, this.img);

  _getOptions() {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < options.length; i++) {
      list.add(Padding(padding: EdgeInsets.all(5), child: Text(options[i])));
    }
    return list;
  }

  List<Widget> _getAnswer() => <Widget>[
        Padding(
          padding: EdgeInsets.all(9),
          child: Text(options[answer], style: TextStyle(fontSize: 30)),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: FlipCard(
        front: Content(title, _getOptions(), 'Reveal the answer!', null),
        back: Content('The answer is:', _getAnswer(), 'Swipe!', img),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final String title;
  final List<Widget> list;
  final String subtitle;
  final String img;

  Content(this.title, this.list, this.subtitle, this.img);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(title,
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ),
            Expanded(
              child: img != null
                  ? Image.asset('assets/$img.jpg')
                  : FlareActor("assets/Bob.flr", animation: "Dance"),
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: list),
            ),
            Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[300],
                child: Text(subtitle, style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}
