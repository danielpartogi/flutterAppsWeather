import 'package:flutter/material.dart';
import 'dart:async';
import '../util/util.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  Icon actionIcon = new Icon(Icons.search);
  Icon forwardIcon = new Icon(Icons.forward, color: Colors.white.withOpacity(0),);
  Widget appBarTitle = new Text("Bandung");
  final textController = TextEditingController();
  String cityName;
  bool ignore = true;



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Stack(
        children: <Widget>[
          new Positioned(
            child: new Image.asset('images/umbrella.png',
                fit: BoxFit.cover,
                height: 1000,
              ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 100.9, 20.9, 0.0),
            child: new Text('${cityName==null?util.defaultCity :cityName}',
              style: cityStyle() 
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          new Container(
            margin : const EdgeInsets.fromLTRB(30.0, 360.0, 0.0, 0.0),
            child: updateTempWidget(cityName),
          ),
          new AppBar(
            title: appBarTitle,
            leading:  Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.search),
         onPressed: () {
              setState(() {
                 this.actionIcon = new Icon(Icons.close);
                 this.forwardIcon = new Icon(Icons.forward);
                 this.ignore = false;
                 this.appBarTitle = new TextField(
                   style: new TextStyle(
                     color: Colors.white
                   ),
                   controller: textController,
                   decoration: new InputDecoration(
                     hintText: "Search...",
                     hintStyle: new TextStyle(color: Colors.white)
                   ),
                   onSubmitted: (newValue){
                     setState(() {
                      this.cityName = newValue; 
                      this.appBarTitle = new Text('$cityName');
                      this.forwardIcon = new Icon(Icons.folder, color:Colors.white.withOpacity(0));
                     });
                   },
                 );
              });
            }
      );
    },
  ),
            centerTitle: true,
            backgroundColor: Colors.black26.withOpacity(0.1),
            elevation: 0.0,
            actions: <Widget>[
            new IgnorePointer(
              ignoring: ignore,
              child: new IconButton(
              icon: forwardIcon,
              onPressed: (){
               setState(() {
                this.cityName =textController.text;
                this.appBarTitle = new Text('$cityName');
                this.forwardIcon = new Icon(Icons.forward, color:Colors.white.withOpacity(0));
                this.ignore = true;
               });
              },
            ),
            )
        ],
      ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${util.appId}&units=metric';
    var response = await http.get(apiUrl);

    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(city==null?util.defaultCity:city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        //where we get all the info of the json data, we setup widgets etc.
        if (snapshot.hasData) {
          Map content = snapshot.data;
           if (content['cod']!='404') {
              return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString() + "℃",
                      style: tempStyle())
                  )
                ],
              )
            );
           }
           else {
          return new Container(
            width: 0.0,
            height: 0.0,
          );
        }
        } else {
          return new Container(
            width: 0.0,
            height: 0.0,
          );
        }
      });
  }
}

class ChangeCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new Image.asset('images/white_snow.png', 
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
              )
            ],
          )
          
        ],
      ),
    );
  }
}


TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 29.9
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white70,
    fontSize: 39.9,
    fontWeight: FontWeight.w600
  );
}