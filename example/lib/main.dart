import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleGestureDetector Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MyHomePage(title: 'SimpleGestureDetector Demo'),
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
  String _text;

  @override
  void initState() {
    super.initState();
    _text = 'Swipe me!';
  }

  void _onSwipeUp() {
    setState(() {
      _text = 'Swiped up!';
      print('Swiped up!');
    });
  }

  void _onSwipeDown() {
    setState(() {
      _text = 'Swiped down!';
      print('Swiped down!');
    });
  }

  void _onSwipeLeft() {
    setState(() {
      _text = 'Swiped left!';
      print('Swiped left!');
    });
  }

  void _onSwipeRight() {
    setState(() {
      _text = 'Swiped right!';
      print('Swiped right!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SimpleGestureDetector(
          onSwipeUp: _onSwipeUp,
          onSwipeDown: _onSwipeDown,
          onSwipeLeft: _onSwipeLeft,
          onSwipeRight: _onSwipeRight,
          swipeConfig: SimpleSwipeConfig(
            verticalThreshold: 40.0,
            horizontalThreshold: 40.0,
            swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
          ),
          child: _buildBox(),
        ),
      ),
    );
  }

  Widget _buildBox() {
    return Container(
      height: 160.0,
      width: 160.0,
      color: Colors.indigo,
      child: Center(
        child: Text(
          _text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
