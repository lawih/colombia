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
  TextStyle _titleStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
  AudioPlayer audioPlayer = AudioPlayer();
  int bgIndex = 0;
  List colors = [
    [Colors.cyan, Color(0xFF4FC3F7), Color(0xFFC2B280)],
    [Color(0xFF00283a), Color(0xFF1c698c), Color(0xFF99874f)],
  ];
  List question = [
    "Which continent is Colombia in?",
    "What is the capital?",
    "What is the official language?",
    "Which artist is from here?"
  ];
  List options = [
    ['Africa', 'Asia', 'America'],
    ['Bogotá', 'Medellin', 'Cali'],
    ['English', 'Portuguese', 'Spanish'],
    ['Selena', 'Shakira', 'Pitbull']
  ];
  List answer = [2, 0, 2, 1];
  List img = ['q1', 'q2', 'q3', 'q4'];

  _play() async {
    await audioPlayer.play("https://bit.ly/2WQLdcG");
  }

  Widget _getBackground() {
    return Column(
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.7, 0.8],
                colors: colors[bgIndex],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFront() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Colombia', style: _titleStyle),
        Padding(
          padding: EdgeInsets.all(9),
          child: Text(
            'Test your knowledge of this amazing country',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Swiper(
            onIndexChanged: (int i) => setState(() => bgIndex = i % 2),
            itemBuilder: (BuildContext context, int i) =>
                InfoCard(question[i], options[i], answer[i], img[i]),
            itemCount: img.length,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _play();
    return Scaffold(
      body: Stack(children: <Widget>[_getBackground(), _getFront()]),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List options;
  final int answer;
  final String img;

  InfoCard(this.title, this.options, this.answer, this.img);

  List<Widget> _getOptions() => options.map((item) => Text(item)).toList();

  List<Widget> _getAnswer() =>
      [Text(options[answer], style: TextStyle(fontSize: 30))];

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
  final String action;
  final String img;

  Content(this.title, this.list, this.action, this.img);

  Widget _getTitle() => Padding(
      padding: EdgeInsets.all(20),
      child: Text(title,
          style: TextStyle(fontSize: 20), textAlign: TextAlign.center));

  Widget _getImg() => Expanded(
      child: img != null
          ? Image.asset('assets/$img.jpg')
          : FlareActor("assets/Bob.flr", animation: "Wave"));

  Widget _getAction() => Container(
      padding: EdgeInsets.all(20),
      color: Colors.cyan,
      child: Text(action, style: TextStyle(color: Colors.white)));

  Widget _toColumn(List<Widget> list) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: list);

  Widget _getLandscape() => Row(children: [
        Expanded(child: _toColumn(<Widget>[_getTitle(), _getImg()])),
        Expanded(
            child: _toColumn(
                <Widget>[Expanded(child: _toColumn(list)), _getAction()]))
      ]);

  Widget _getPortrait() => _toColumn(<Widget>[
        _getTitle(),
        _getImg(),
        Expanded(child: _toColumn(list)),
        _getAction()
      ]);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Colors.white,
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? _getPortrait()
            : _getLandscape(),
      ),
    );
  }
}
