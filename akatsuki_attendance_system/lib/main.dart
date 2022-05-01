// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:http/http.dart' as http;

import 'function.dart';
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
    nextScreen: inputPRNPage(),
    splashTransition: SplashTransition.fadeTransition,
    backgroundColor: Colors.white,
    duration: 4000,
    ),
  )
  );
}
//should become an animation page



class Baseapp extends StatefulWidget{
  late final String PRN;
  Baseapp({String? key, required this.PRN}) : super();

  @override
  State<Baseapp> createState() => _BaseappState(PRN: PRN);
}

class _BaseappState extends State<Baseapp> {
  late final String PRN;
  _BaseappState({String? key, required this.PRN}) : super();
  var subjectNames = [];
  var subjectAttendances = [];
  var data;
  var output = 0;
    int n = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // final List<int> _subjectAttendances = subjectAttendances.cast<int>();
    // final List<String> _subjectNames = subjectNames.cast<String>();

     List<int>  _subjectAttendances = subjectAttendances.cast<int>();
     List<String> _subjectNames = subjectNames.cast<String>();



    // final List<int> _subjectAttendances = <int>[1, 2, 3, 4, 5];
    // final List<String> _subjectNames = <String>['sub1',
    //   'sub2',
    //   'sub3',
    //   'sub4',
    //   'sub5'];


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
            onPressed: () async {
              data = await fetchdata("http://10.0.0.6:8000/getStudentAttendance/1951721245049");
              var decoded = jsonDecode(data);
              setState(() {
                //shivang module unfinished
                output = decoded['sub2'];
                print('before output print');
                print(output);
              });
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
            itemCount: _subjectAttendances.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 250,
                child: Center(
                  child: TextButton(

                      child: Text(_subjectNames[index].toString() + "\nPRN : " + widget.PRN + "\nAttendance :" + _subjectAttendances[index].toString()),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Baseapp(PRN: "-1",)
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

class inputPRNPage extends StatefulWidget {
  const inputPRNPage({Key? key}) : super(key: key);

  @override
  _inputPRNPage createState() => _inputPRNPage();
}

class _inputPRNPage extends State<inputPRNPage> {
  // the result which will be displayed on the screen
  String? _result;
  // Create a text controller  to retrieve the value
  final _textController = TextEditingController();

  // the function which calculates square
  void captureInput() {
    // textController.text is a string and we have to convert it to double
    final String? userInput = _textController.text.toString();
    setState(() {
      _result = userInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The user will type something here

              TextField(
                decoration: InputDecoration(
                labelText: 'Enter PRN Number',
                labelStyle: TextStyle(
                    color: Colors.black
                ),
                enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 3, color: Colors.red),
                                borderRadius: BorderRadius.circular(15),
                              ),
                focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
                ),
                ),
                controller: _textController,

              ),
              SizedBox(height: 25),
              ElevatedButton(

                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.black;
                      return Colors.red; // Use the component's default.
                    },
                  ),
                ),
                  onPressed: (){
                    captureInput();
                    print(_result);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Baseapp(PRN: _result.toString())
                    )
                    );
                  },
                child: Text("Submit",
                style: TextStyle(
                fontSize: 20,
                  fontStyle: FontStyle.italic
                ),
                ),

              )
            ],
          ),
        )
    );
  }
}