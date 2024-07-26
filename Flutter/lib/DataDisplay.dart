import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import '/dataHandle.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:testingesp32/stringValue.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class DisplayPage extends StatefulWidget {
  final Widget Function(BuildContext context,Brightness brightness) builder;
  DisplayPage({this.builder});
  @override
  _DisplayPageState createState() => _DisplayPageState();
}
class W {
  static AppLocalizations of(BuildContext context) => AppLocalizations.of(context);
}
class _DisplayPageState extends State<DisplayPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int tabSet = 0;
  int _radioModeValue;
  int _radioTextValue;
  int _radioLanguageValue;
  double textSizeChange = 1;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  DatabaseReference  _espRef = FirebaseDatabase.instance.ref().child('ESP32');
  bool _login;
  // ignore: deprecated_member_use
  List<double> traceDustTemp =List();
  // ignore: deprecated_member_use
  List<double> traceDustBpm =List();
  
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _radioModeValue = 0;
      _radioTextValue = 1;
      _radioLanguageValue = 1;
    });
    super.initState();
    _tabController= TabController(length: 3, vsync: this);
    _login =false;
  }

  @override
  Widget build(BuildContext context) {
    return _login ? firstScaffold() : logInScaffold();
  }
  Widget firstScaffold(){
    return Scaffold(
      appBar: AppBar(
        title: Text(systemText("AppTitle"),
          style: TextStyle(fontSize: 22*textSizeChange),
        ),
        bottom: TabBar(
          indicatorColor: Colors.cyanAccent,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          onTap: (int index){setState(() {tabSet = index;});},
          tabs: [
            Tab(icon: Icon(MaterialCommunityIcons.temperature_celsius),),
            Tab(icon: Icon(Icons.favorite),),
            Tab(icon: Icon(Icons.settings),)
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _espRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null){
              print("snapshot data:${snapshot.data.snapshot.value.toString()}");
              var _esp =ESP.fromJson(snapshot.data.snapshot.value);
              print("ESP json data :${_esp.temp}/${_esp.bpm}/${_esp.avg}");
              traceDustTemp.add(double.tryParse(_esp.temp.toStringAsFixed(1)) ?? 0);
              traceDustBpm.add(double.tryParse(_esp.avg.toStringAsFixed(0)) ?? 0);

              return IndexedStack(
                index: tabSet,
                children: [_tempUI(_esp),_bpmUI(_esp),_settingUI(_esp),],
              );
            }else{
              return Center(
                child: Text("NO DATA YET"),
              );
            }
          }
      ),
    );
  }

  static const Radius _borderRadius = const Radius.circular(50);
  Widget _tempUI(ESP _esp){
      Oscilloscope vied = Oscilloscope(
      showYAxis: true,
      margin: EdgeInsets.all(20.10),
      strokeWidth: 5,
      backgroundColor: Colors.grey,
      traceColor: Colors.red,
      yAxisMax: 45.0,
      yAxisMin: 30.0,
      dataSet: traceDustTemp,
    );
    return Center(
      child:Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: Text(S.of(context).temptitle),
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 30 *textSizeChange
              ),
            ),
          ),
          Expanded(
            flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children:<Widget>[
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(40),
                      child: vied,
                    ),
                    FAProgressBar(
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      currentValue:_esp.temp,
                      progressColor: Colors.green,
                      backgroundColor: Colors.grey,
                      changeProgressColor: Colors.red,
                      size: 80,
                      maxValue: 50,
                      changeColorValue: 41,
                      displayText: " °C",
                      borderRadius: BorderRadius.all(_borderRadius),
                      animatedDuration: Duration(milliseconds: 1000),
                    ),
                  ]
                ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: Text(S.of(context).nowtempis'
                '${_esp.temp.toStringAsFixed(1)} ${systemText('°C')}',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30* textSizeChange),
            ),
          ),
        ],
      )
    );
  }

  Widget _bpmUI(ESP _esp){
    Oscilloscope ibp = Oscilloscope(
      showYAxis: true,
      margin: EdgeInsets.all(20.10),
      strokeWidth: 5,
      backgroundColor: Colors.grey,
      traceColor: Colors.red,
      yAxisMax: 200.0,
      yAxisMin: 20.0,
      dataSet: traceDustBpm,
    );
    return Center(
        child:Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top:50),
              child: Text(systemText("bpmtitle"),
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 30 *textSizeChange),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children:<Widget>[
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(40),
                      child: ibp,
                    ),
                    FAProgressBar(
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      currentValue:_esp.avg,
                      progressColor: Colors.pink,
                      backgroundColor: Colors.grey,
                      changeProgressColor: Colors.red,
                      size: 80,
                      maxValue: 180,
                      changeColorValue: 105,//5 value change
                      displayText: "bpm",
                      borderRadius: BorderRadius.all(_borderRadius),
                      animatedDuration: Duration(milliseconds: 1000),
                    ),
                  ],
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              //child: Text('${systemText('nowbpm')} '
              //    '${_esp.avg.toStringAsFixed(0)} ${systemText('bpm')}',
              child: Text('${W.of(context).nowbpm}${_esp.avg.toStringAsFixed(0)}${W.of(context).bpm}'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30* textSizeChange
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget _settingUI(ESP _esp){
     return Scaffold(
       body: Container(
         padding: const EdgeInsets.all(10),
         child: ListView(
           children: [
             SizedBox(height: 40),
             Row(
               children: [
                 Icon(Icons.settings, color: Colors.indigoAccent,),
                 SizedBox(width: 10),
                 Text(systemText("settingPage"),
                   style: TextStyle(
                       fontSize: 24 * textSizeChange,
                       fontWeight: FontWeight.bold,
                       letterSpacing: 1.2
                   ),
                 )
               ],
             ),
             Divider(height: 20, thickness: 1),
             SizedBox(height: 10),
             buildSetting(context, systemText("Language")),
             SizedBox(height: 20),
             Row(
               children:[
                 Icon(Icons.settings, color: Colors.indigoAccent,),
                 SizedBox(width: 10),
                 Text(systemText("Other Setting"),
                   style: TextStyle(
                     fontSize: 24 *textSizeChange,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1.2
                   ),
                 )
               ],
             ),
             Divider(height: 20, thickness: 1),
             SizedBox(height: 10),
             Row(
               children: <Widget>[
                 Container(
                   height: 50,
                   margin: EdgeInsets.all(10),
                   child: Text(
                     systemText('fontsize'),
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 20 *textSizeChange
                     ),
                   ),
                   alignment: Alignment(0.0, 0.0),
                 ),
                 Container(
                   height: 30,
                   margin: EdgeInsets.all(20),
                   child: Row(
                     children: <Widget>[
                       Text(W.of(context).small),//testing
                         style: TextStyle(fontSize: 16 *textSizeChange),
                       ),
                       new Radio(
                         value: 0,
                         groupValue: _radioTextValue,
                         onChanged: _handleRadioTextValueChange,
                       ),
                       Text(W.of(context).medium),
                           style: TextStyle(fontSize: 20 *textSizeChange),
                       ),
                       new Radio(
                         value: 1,
                         groupValue: _radioTextValue,
                         onChanged: _handleRadioTextValueChange,
                       ),
                       Text(W.of(context).large),
                         style: TextStyle(fontSize: 22 *textSizeChange),
                       ),
                       new Radio(
                         value: 2,
                         groupValue: _radioTextValue,
                         onChanged: _handleRadioTextValueChange,

                       ),
                     ],
                   ),
                 ),
               ],
             ),
             SizedBox(height: 20),
             Row(
               children: <Widget>[
                 Container(
                   margin: EdgeInsets.all(10),
                   child: Text(
                     systemText('mode'),
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 20*textSizeChange),
                   ),
                   alignment: Alignment(0.0, 0.0),
                 ),
                 Container(
                   height: 30,
                   decoration: BoxDecoration(
                     //border: Border.all(width: 2.8, color: Colors.red),
                       borderRadius: BorderRadius.circular(12)),
                   child: Row(
                     children: <Widget>[
                       Text(systemText('lightmode'),
                         style: TextStyle(fontSize: 18*textSizeChange),),
                       new Radio(
                         value: 0,
                         groupValue: _radioModeValue,
                         onChanged: _handleRadioModeValueChange,
                       ),
                       Text(systemText('darkmode'),
                         style: TextStyle(fontSize: 18*textSizeChange),),
                       new Radio(
                         value: 1,
                         groupValue: _radioModeValue,
                         onChanged: _handleRadioModeValueChange,
                       ),
                     ],
                   ),
                 ),
               ],
             ),
             Center(
               child: OutlinedButton(
                 style:OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(horizontal: 40),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20)
                   )
                 ),
                 onPressed: (){},
                 child: Text(systemText("call"),
                   style: TextStyle(
                       fontSize: 16* textSizeChange,
                       letterSpacing: 2.2,
                       //color: Colors.black
                 ),),
               ),
             )
           ],
         ),
       ),
     );
   }

   GestureDetector buildSetting(BuildContext context, String title){
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text(title,style: TextStyle(fontSize: 22*textSizeChange),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: <Widget>[
                          Text(systemText('chinese')),
                          new Radio(
                            value: 0,
                            groupValue: _radioLanguageValue,
                            onChanged: _handleRadioLanguageValueChange,
                          ),
                          Text(systemText('english')),
                          new Radio(
                            value: 1,
                            groupValue: _radioLanguageValue,
                            onChanged: _handleRadioLanguageValueChange,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(systemText("close")))
            ],
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: TextStyle(
              fontSize: 20* textSizeChange,
              fontWeight: FontWeight.w500,
            )),
            Icon(Icons.arrow_forward,color: Colors.grey)
          ],
        ),
      ),
    );
   }

  Widget logInScaffold(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(systemText("title"),
            style: TextStyle(fontWeight :FontWeight.bold, fontSize: 20),
          ),
            SizedBox(height: 50,),
            ElevatedButton(
              child: Text(systemText('Login'),
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black)
              )),
              onPressed: ()async{
                _signIn();
              },
            )],
        ),
      ),
    );
  }

  void _signIn() async {
    final User user = (await _auth.signInAnonymously()).user;
    print("*** user isAnonymous: ${user.isAnonymous}");
    print("*** user uid: ${user.uid}");
    setState(() {
      _login = user != null;
    });
  }

  void _handleRadioModeValueChange(int value){
    setState(() {
      _radioModeValue =value;
      if(_radioModeValue == 0){
        AdaptiveTheme.of(context).setLight();
      }else if(_radioModeValue ==1){
        AdaptiveTheme.of(context).setDark();
      }
    });
  }

  void _handleRadioTextValueChange(int value) {
    setState(() {
      _radioTextValue = value;
      switch (_radioTextValue) {
        case 0:
          textSizeChange = 0.8;
          break;
        case 1:
          textSizeChange = 1;
          break;
        case 2:
          textSizeChange = 1.2;
          break;
      }
    });
  }

  void _handleRadioLanguageValueChange(int value) {
    setState(() {
      _radioLanguageValue = value;
      theLocate = (_radioLanguageValue == 0) ? 'zh' : 'en';
    });
  }
}
