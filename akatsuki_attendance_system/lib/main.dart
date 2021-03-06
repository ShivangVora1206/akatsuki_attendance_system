// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:http/http.dart' as http;

import 'function.dart';
void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
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
  late final String? PRN;
  Baseapp({String? key, required this.PRN}) : super();

  @override
  State<Baseapp> createState() => _BaseappState(PRN: PRN);
}

class _BaseappState extends State<Baseapp> {
  String greeting = "";
  late final String? PRN;
  // ignore: non_constant_identifier_names, unused_element
  _BaseappState({String? key, required this.PRN}) : super();
  String? studentName ;
  String? studentPRN ;
  String? studentRollNo ;
  int packetSize = 0;
  List subjectNames = [];
  List subjectAttendances = [];
  var data;
  var data2;
  var output = 0;
    int n = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // final List<int> _subjectAttendances = subjectAttendances.cast<int>();
    // final List<String> _subjectNames = subjectNames.cast<String>();

     // List<int?>  _subjectAttendances = subjectAttendances.cast<int?>();
     // List<String?> _subjectNames = subjectNames.cast<String?>();



    final List<int> _subjectAttendances = <int>[1, 2, 3, 4, 5];
    final List<String> _subjectNames = <String>['sub1',
      'sub2',
      'sub3',
      'sub4',
      'sub5'];


    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
            radius: 1,
            colors: [
              Colors.lightBlue,
              Colors.lightGreenAccent,
            ]
        ),
      ),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () async {
              data = await fetchdata("http://10.0.0.3:8000/getStudentData/$PRN");
              var decoded = jsonDecode(data);
              // data2 = await fetchdata("http://127.0.0.1:5000/u");
              // var decoded2 = jsonDecode(data2);
              print("pressed");
              setState(() {
                // greeting = decoded2['greetings'];
                // print(greeting);
                // print(greeting);
                // print(greeting);
                subjectNames.clear();
                subjectAttendances.clear();

                studentName = decoded['studentName'];
                // print(studentName);
                studentPRN = decoded['studentPRN'].toString();
                studentRollNo = decoded['studentRollNo'].toString();
                packetSize = int.parse(decoded['packetSize']);
                for(int i=1;i<=packetSize;i++){
                  subjectAttendances.add(decoded['sub'+i.toString()]);
                  subjectNames.add("sub"+i.toString());
                }
              });
            },//shivang module partially finished
            //logic is functional now I need to figure out to make this run without a button press
            child: Icon(Icons.home_filled),
          ),
          appBar: AppBar(
            flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.red,
                      ]
                  ),
                )
            ),
            centerTitle: true,
            title: Icon(Icons.home),
          ),
          backgroundColor: Colors.transparent,
          body: ListView.separated(
            padding: const EdgeInsets.all(3),
            itemCount: _subjectAttendances.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 250,
                child: Center(
                  child: TextButton(

                      child: Text(_subjectNames[index].toString() + "\nAttendance :" + _subjectAttendances[index].toString()),
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
                      Colors.blue,
                      Colors.redAccent
                    ]
                ),
              )
          ),
          centerTitle: true,
          title: Text("Akatsuki Attendance Systemm"),
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
                    color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
                ),
                ),
                controller: _textController,

              ),
              SizedBox(height: 10),
              ElevatedButton(

                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.black;
                      return Colors.lightBlue; // Use the component's default.
                    },
                  ),
                ),
                  onPressed: ()async {
                    captureInput();
                    print(_result);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Baseapp(PRN: _result)
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
            ],//hitesh module unfinished
          ),
        )
    );
  }
}