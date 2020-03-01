import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditivitytest2/page2/player_page.dart';

class TabContentStructure {
  static Widget createContent(BuildContext context, String groupTitle) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          createSectionHeader(context, groupTitle),
          Container(
              height: 230,
              child:
              ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              //TODO assign background img in a more concise way
              createCard(context, 'assets/images/rain.jpg'),
              createCard(context, 'assets/images/beach.jpg'),
            ],
          )
          )
        ],
      ),
    );
  }
}

Widget createSectionHeader(BuildContext context, String headerTitle, {onViewMore}) {
  return Container (
      margin: EdgeInsets.only(top: 30),
      height: 44,
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 16, top: 10),
        child: Text(headerTitle, style: Theme.of(context).textTheme.body1,),
      ),
      Container(
        margin: EdgeInsets.only(left: 16, top: 2),
        child: FlatButton(
          onPressed: onViewMore,
          child: Text('See all', style: TextStyle(color: Color(0xffafb6bc))),
        ),
      )
    ],
  )
  );
}

Widget createCard(BuildContext context, String imageAssetUrl){
  //TODO replace all constants with variables passed in an object
  return GestureDetector(
    onTap:  ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage())),
      child: Container(
    ///check orientation
    width: MediaQuery.of(context).orientation== Orientation.portrait?
    ///then set the card's width limits (relative or absolute max)
    MediaQuery.of(context).size.width * 0.85 : 350,
    //TODO add a special case for tablets
    padding: EdgeInsets.all(10.0),
    margin: EdgeInsets.only(left: 16.0, top: 5, bottom: 30),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.blueGrey[100],
        image:  DecorationImage(
          //TODO add black vignette
          image: AssetImage(imageAssetUrl),
          fit: BoxFit.fitWidth,
          alignment: Alignment.center
        ),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('Info Info Inf...',
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.subhead,),
              ),
              Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text('Title Title Title Title'.toUpperCase(),
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.title),
                  Text('Day 1. Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle...',
                      overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],)
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 5),
                      child: Icon(Icons.timer, color: Colors.white, )),
                  Text('00h 00m',
                  style: Theme.of(context).textTheme.subhead,),
                ],)
              ),


            ],
          ),

        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text('BEGIN', style: Theme.of(context).textTheme.button,),
                color: Color(0xff6bd4d4),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerPage()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)) ,
              )
            ],
          ),
        ),

      ],
    ),
  ));
}