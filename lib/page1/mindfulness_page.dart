import 'package:flutter/material.dart';
import 'package:meditivitytest2/page1/tab_content_structure.dart';

import 'bubble_tab_indicator.dart';

class MindfulnessPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(

              title: Text('Mindfulness'),
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.transparent,

              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Color(0xffafb6bc)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.more_horiz,
                      size: 30.0, color: Color(0xffafb6bc)),
                )
              ],
              bottom:
//              PreferredSize(
//                preferredSize: ,
//                child:
                TabBar(

                labelStyle: Theme.of(context).textTheme.body1,
                unselectedLabelColor: Color(0xffafb6bc),
                labelColor: Color(0xFF393C4F),
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 5, right: 5),
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (data){},
                // TODO make background rectangle width equal to the width of three tabs
                  //TODO fix bug with flickering tap animation
                indicator: MyBubbleTabIndicator(
                  indicatorColor: Colors.grey[50],
                  indicatorHeight: 30.0,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  indicatorRadius: 6.0,
                ),
//                BoxDecoration(
//
//                    borderRadius: BorderRadius.circular(6.0),
//                    color: Colors.redAccent,
//
//
//                ),

//                new BubbleTabIndicator(
//                  indicatorColor: Colors.redAccent,
//                  indicatorHeight: 40.0,
//                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
//                  indicatorRadius: 6.0,
//                ),
//                indicatorColor: Colors.redAccent,
//                indicatorWeight: 4,
//                indicatorSize: TabBarIndicatorSize.tab,
//                indicatorPadding: EdgeInsets.all(1),
//                labelPadding: EdgeInsets.only(right: 50, left: 50),
                tabs: <Widget>[


                     Container(

                    height: 33,
                    width: 90,
                    alignment: Alignment.center,
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(6.0),
//                        color: Colors.yellow,
//
//                    ),
                    //width: 200,
//                    color: Color(0xfff7f7f8),
                    //TODO move all hardcoded strings into a separate file
                       child:
                    Text('MEDITATION')

              //),


                  ),
                  Container(
                      height: 30,
                     width: 80,
                     // color: Color(0xfff7f7f8),
                      child:
//                      OverflowBox(
//                        maxWidth: 300,
//                        maxHeight: 33,
//
//                        child: Container(
//
//                            alignment: Alignment.center,
//                            width: 280,
//                            height: 33,
//                            margin: EdgeInsets.only(right: 10),
//
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(6.0),
//
//                                color: Colors.green
//                            ),
//                            child:
                      Text('COURSES'),
//                        ),
//                      ),
                      alignment: Alignment.center),
                  Container(
                      height: 30,
                      width: 80,
                      //color: Color(0xfff7f7f8),
                      child: Text('SOUNDS'),
                      alignment: Alignment.center),
                ],
              ),
              //)
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(),
                Expanded(
                    child: TabBarView(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        TabContentStructure.createContent(
                            context, 'MOST POPULAR'),
                        TabContentStructure.createContent(context, 'GROUP 2'),
                      ],
                    ),
                    ListView(
                      children: <Widget>[
                        TabContentStructure.createContent(context, 'GROUP 3'),
                        TabContentStructure.createContent(context, 'GROUP 4'),
                      ],
                    ),
                    ListView(
                      children: <Widget>[
                        TabContentStructure.createContent(context, 'GROUP 50'),
                        TabContentStructure.createContent(context, 'GROUP 100'),
                      ],
                    ),

                    //Icon(Icons.directions_car),
                  ],
                ))
              ],
            )));
  }
}
