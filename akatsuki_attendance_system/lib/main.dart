import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'dart:io';
import 'dart:convert';
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

class Baseapp extends StatelessWidget{
  late final String PRN;
  var subjectAttendances = [];
  var subjectNames = [];
  Baseapp({String? key, required this.PRN}) : super();
  @override

  void requester() async {
    // produces a request object
    var request = await HttpClient()
        .getUrl(Uri.parse('http://10.0.0.6:8000/getStudentAttendance/$PRN'));
// sends the request
    var response = await request.close();
// transforms and prints the response
    await for (var contents in response.transform(Utf8Decoder())) {
      String formattedContent = "";
      var listSubKeyVal = [];

      int i = 0;
      for (i = 1; i < contents.length - 1; i++) {
        formattedContent += contents[i];
      }
      List<String> subjectKeyValue = formattedContent.split(",");
      for (i = 0; i < subjectKeyValue.length; i++) {
        listSubKeyVal.add(subjectKeyValue[i].toString().split(":"));
      }
      print(listSubKeyVal);


      for (int i = 0; i < listSubKeyVal.length; i++) {
        subjectAttendances.add(listSubKeyVal[i][1]);
      }
      for (int i = 0; i < listSubKeyVal.length; i++) {
        subjectNames.add(listSubKeyVal[i][0]);
      }
      print(subjectNames);
      print(subjectAttendances);
    }
  }


  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    int n = 0;
    requester();
    // final List<int> _subjectAttendances = subjectAttendances.cast<int>();
    // final List<String> _subjectNames = subjectNames.cast<String>();

     List<int>  _subjectAttendances = subjectAttendances.cast<int>();
     List<String> _subjectNames = subjectNames.cast<String>();


  print("after rquester");

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
            onPressed: (){
              n++;
              print("Button presses");
              if(n == 10){//affordability page
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Baseapp(PRN: "-1",)
              )
                );
            }else{//goto home page
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Baseapp(PRN: "-1",)
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
            itemCount: _subjectAttendances.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 250,
                child: Center(
                  child: TextButton(

                      child: Text(_subjectNames[index].toString() + "\nPRN : " + PRN + "\nAttendance :" + _subjectAttendances[index].toString()),
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