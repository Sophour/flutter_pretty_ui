import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditivitytest2/services/background_audio_service/background_audio_task.dart';

import 'exercise_timer.dart';

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayerPageWidget();
  }
}

class PlayerPageWidget extends StatefulWidget {
  PlayerPageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlayerPageDefaultState createState() => _PlayerPageDefaultState();
}

class _PlayerPageDefaultState extends State<PlayerPageWidget>
    with WidgetsBindingObserver {
  bool _settingsTabIsActive = false;
  bool _audioIsPlaying = false;

  bool counting = false;
  Duration duration;
  Duration timePassed;
  Function myTimerCallback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  @override
  void dispose() {
    disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    AudioService.start(
      backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      notificationColor: 0xff413c69,
      androidNotificationIcon: 'mipmap/ic_launcher',
      enableQueue: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            //TODO setup custom icons
              icon: Icon(Icons.volume_up),
              onPressed: () {

              }),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.nacional.hr/wp-content/uploads/2019/04/rain-3443977_1920.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom:140, top: 150),
                //height: 291,
                child: Text(
                  'Title Title',
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Container(
                child: SizedBox(
                  width: 230,
                  height: 230,
                  child: ExerciseTimer(
                      counting: counting,
                      duration: Duration(seconds: 120),
                      timePassed: Duration(seconds: 0)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top:200),

                  child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(

                    child: Container(
                      width: 100,
                      height: 42,
                      alignment: Alignment.center,
                      child: Text(
                      'Pause',
                      style: Theme.of(context).textTheme.button,
                    ),),
                   // highlightColor: Colors.white,
                    //color: Colors.white,
                   color: Colors.white ,
                    borderSide: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                    highlightColor: Colors.white,
                    onPressed: () => AudioService.pause(),

                  )
                ],
              ))
            ],
          )),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        disconnect();
        break;
      default:
        break;
    }
  }
}

Widget customIconButton(
    double width, double height, Function onTapAction, imageUrl) {
  return Container(
      color: Colors.redAccent,
      //margin: EdgeInsets.all(2.0),
      child: GestureDetector(
          onTap: onTapAction,
          child: SizedBox(
              height: height,
              width: width,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    //TODO doesn't display icons
                    image: AssetImage(imageUrl),
                  ),
                ),
              ))));
}
