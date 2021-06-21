import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

var subscription;
var descriptors;
var name;
var device;
var r;
var c;

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: '心拍数アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;




  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FlutterBlue flutterBlue = FlutterBlue.instance;



  void _incrementCounter() async {

    flutterBlue.startScan(timeout: Duration(seconds: 1));
    subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print(r.device.name);

        if(r.device.name == "BBC micro:bit [puteg]"){
          device = r.device;
          name = r.device.name;
        }
      }


    setState(() {



      });
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });

    await device.connect();
    print("コネクトぉぉぉぉっぉぉぉっぉ");


  }

  void Disconnect_BLUE(){
    setState(() {
      device.disconnect();
    });
  }

  void Disc() async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for(BluetoothCharacteristic c in characteristics) {
        List<int> value = await c.read();
        print(value);
      }
      // do something with service
    });
  }

  void Ssrv() async {

    Disc();

  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          SizedBox(

            child: RaisedButton(
              onPressed: Disconnect_BLUE,
              color: Colors.greenAccent,
              elevation: 13,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Disconnect',
                  style: TextStyle(
                  color:Colors.black,
                  fontSize: 15.0
                  ),
                ),
              ),
            ),
            SizedBox(
            height: 0,
            width: 10,
            )
          ]
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connected by',
            ),
            Text(
              '$name',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: Ssrv,
                child: Text("サービス")),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
