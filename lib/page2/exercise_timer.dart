import 'package:flutter/material.dart';
import 'dart:math' as math;

//TODO dispose of animator's Tickers
class ExerciseTimer extends StatefulWidget {
  final bool counting;
  final Duration duration;
  final Duration timePassed;

  ExerciseTimer({Key key, this.counting,
    @required this.duration, this.timePassed}):super(key: key);

  @override
  _ExerciseTimerState createState() =>
      _ExerciseTimerState(counting: counting,
      duration: duration,
      timePassed: timePassed);
}

class _ExerciseTimerState extends State<ExerciseTimer> with TickerProviderStateMixin {
  AnimationController controller;
  bool counting = false;
  Duration duration;
  Duration timePassed;

  Function callback;


  _ExerciseTimerState({Key key, this.counting : false,
  this.duration, this.timePassed});

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:320),
    );


  }

  @override
  Widget build(BuildContext context) {
    //print('Timer's been rebuilt');
    setupCountdownTimer();

    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(

          children: <Widget>[
          Expanded(
            child: Align(
            alignment: FractionalOffset.center,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child){
                        return new CustomPaint(
                          painter: TimerPainter(
                            animation: controller,
                            color: Colors.white,
                            backgroundColor: Color.fromARGB(80, 255, 255, 255),
                          ),
                        );
                      },
                  )),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return Text(
                                timerString,
                                style: Theme.of(context).textTheme.display2,
                              );
                            }),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("day 1", style: Theme.of(context).textTheme.button,
                        ),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),),
          ]
    )));
  }

  setupCountdownTimer(){
    if (counting /*controller.isAnimating*/) {
      controller.stop(canceled: true);
      counting = false;
    } else {
      controller.reverse(
        ///TODO set animation progress here
          from: controller.value == 0.0
              ? 1.0
              : controller.value);
    }
  }
  stopCountdownTimer(){}
  resumeCountdownTimer(){}

  setupCountdownTimer2(bool isCounting) =>
   setState(() {counting = isCounting;});

  //TODO make it not the countdown
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60)
        .toString().padLeft(2, '0')}';
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter( {
    this.animation,
    this.backgroundColor,
    this.color,
  } ) : super( repaint: animation );

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint( Canvas canvas, Size size ) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);

  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }

}
