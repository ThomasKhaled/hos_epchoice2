import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ElTagally extends StatefulWidget{
  String title;

  ElTagally(this.title);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ElTagallyState(title);
  }
}

class ElTagallyState extends State<ElTagally>{
  String title;
  var url,urlasync;
  ElTagallyState(this.title);
  AudioPlayer audio = AudioPlayer();

  Future<String> getAudioUrl(text) async{
    final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://movieapp-216811.appspot.com/');
    var ref = storage.ref().child(getAudioName(text));
    String url = await (await ref.getDownloadURL()).toString();
    return url;

  }

  Widget button(title){
    return InkWell(
      onTap: (){
        getAudioUrl(title).then((onValue){
          setState(() {
            urlasync = onValue;
          });
        }).whenComplete((){
          setState(() {
            url = urlasync;
          });
          print('abo el urllllllllllllllllllllllllllllllllllllllll: $url');
          urlAndNavigate(title);
        });

      },
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        decoration: new BoxDecoration(
          color: Color.fromARGB(140, 6, 3, 97),
          border: new Border.all(color: Colors.white, width: 2.0),
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: new Center(child: new Text(title, style: new TextStyle(fontSize: 18.0, fontFamily: 'Coptic' ,color: Colors.white),),),
      ),
    );
  }

  Widget urlAndNavigate(text){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AudioInfo(text,url)));
  }

  getAudioName(title){
    switch(title){
      case 'أرباع الناقوس' : return 'arba3_nakoos_tagally.mp3'; break;
      case ']galilea' : return 'tygalilea.mp3'; break;
      case 'مرد الانجيل' : return 'marad_engeel_tagaly.mp3'; break;
      case 'مرد المزمور' : return 'marada_mazmoor_tagaly.mp3'; break;

    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(170, 6, 3, 97),
          title: Text(title),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              button('أرباع الناقوس'),
              Divider(color: Color.fromARGB(170, 6, 3, 97),height: 20.0,),
              button(']galilea'),
              Divider(color: Color.fromARGB(170, 6, 3, 97),height: 20.0,),
              button('مرد المزمور'),
              Divider(color: Color.fromARGB(170, 6, 3, 97),height: 20.0,),
              button('مرد الانجيل')
            ],
          ),
        ),
      ),
    );
  }


}



class AudioInfo extends StatefulWidget{
  String audioTitle;
  var url;
  AudioInfo(this.audioTitle,this.url);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AudioInfoState(audioTitle,url);
  }
}

class AudioInfoState extends State<AudioInfo>{
  String audioTitle;
  var url;
  bool pause = false,play=false;
  AudioInfoState(this.audioTitle,this.url);
  AudioPlayer audio = AudioPlayer();
  Timer timer;
  int start =0;

  void startTimer(){
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) => setState(
            (){
          if(play){
            start = start + 1;
          }else{
            timer.cancel();
          }
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){audio.stop(); url=''; Navigator.pop(context);}),
        backgroundColor: Color.fromARGB(170, 6, 3, 97),
        title: Text(audioTitle,style: TextStyle(fontFamily: 'Coptic'),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: (){
            Share.share(url,subject: audioTitle);
          })
        ],
      ),
      body: WillPopScope(
        onWillPop: (){
          audio.stop(); url=''; Navigator.pop(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Padding(
              padding: const EdgeInsets.all(30.0),
              child: /*Card(
                child: Container(
                  color: Colors.grey[100],
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                      ],
                    ),
                  ),
                ),
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/tagally.jpg',width: 300,fit: BoxFit.fitHeight,height: 200,)
                ],
              )
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'btn1',
                    backgroundColor: Color.fromARGB(170, 6, 3, 97),
                    child: Icon(Icons.fast_rewind),
                    onPressed: (){
                      setState(() {
                        if(start >= 5){
                          start = start - 5;
                          audio.seek(start.toDouble());
                        }else{
                          Fluttertoast.showToast(msg: 'Cant Fast Backward',textColor: Colors.black,toastLength: Toast.LENGTH_SHORT);
                        }
                      });
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    backgroundColor: Color.fromARGB(170, 6, 3, 97),
                    child: Icon(Icons.pause),
                    onPressed: (){
                      audio.pause();
                      pause = true;
                      play=false;
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 'btn3',
                    backgroundColor: Color.fromARGB(170, 6, 3, 97),
                    child: Icon(Icons.play_arrow),
                    onPressed: (){
                      audio.play(url);
                      pause = false;
                      play=true;
                      startTimer();
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 'btn4',
                    backgroundColor: Color.fromARGB(170, 6, 3, 97),
                    child: Icon(Icons.fast_forward),
                    onPressed: (){
                      setState(() {
                        if(start <= audio.duration.inSeconds - 5){
                          start = start + 5;
                          audio.seek(start.toDouble());
                        }else{
                          Fluttertoast.showToast(msg: 'Cant Fast Forward',textColor: Colors.black,toastLength: Toast.LENGTH_SHORT);
                        }
                        print(start);
                      });

                    },
                  )


                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}