import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
void main() {
  runApp( MaterialApp(
    home:AnimatedSplashScreen(
      splash: Container(
        child: Center(
          child: Text("Akatsuki",
                  style: TextStyle(
                        fontFamily: 'GlossAndBloom',
                        fontSize: 35,
                        color: Colors.red
                        ),
          )
      ),
  ),
    nextScreen: Baseapp(),
    splashTransition: SplashTransition.fadeTransition,
    backgroundColor: Colors.white,
    duration: 4000,
    ),
  )
  );
}
//should become an animation page

class Baseapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    int n = 0;
    final List<int> subjectAttendances = <int>[1, 2, 3, 4, 5];
    final List<String> subjectNames = <String>['sub1',
      'sub2',
      'sub3',
      'sub4',
      'sub5'];
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
            radius: 1,
            colors: [
              Colors.white,
              Colors.white
            ]
        ),
      ),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: (){
              n++;
              print("Button presses");
              if(n == 10){//affordability page
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Baseapp()
              )
                );
            }else{//goto home page
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Baseapp()
              )
                );
              }
            },
            child: Icon(Icons.home_filled),
          ),
          appBar: AppBar(
            flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.redAccent
                      ]
                  ),
                )
            ),
            centerTitle: true,
            title: Text("Akatsuki Attendance System"),
          ),
          backgroundColor: Colors.transparent,
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: subjectAttendances.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 250,
                child: Center(
                  child: TextButton(

                      child: Text(subjectNames[index].toString() + subjectAttendances[index].toString()),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Baseapp()
                                        )
                  ),

                ),
              )
                );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
                )
    );
  }
}

