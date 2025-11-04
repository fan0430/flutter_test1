import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:shorebird_downloader/shorebird_downloader.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:yaml/yaml.dart';
import 'package:path/path.dart'; 
// import 'package:dart_config/default_server.dart';
// import 'dart:async';


import 'package:flutter/services.dart' show BasicMessageChannel, StringCodec, rootBundle;
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// late final SharedPreferences prefs;

void main() async{
  runApp(const MyApp());
//   ShorebirdCheckDownloader(
//   customShowUpdateDialog: (currentPatchNumber, nextPatchNumber) =>
//       ShorebirdCheckDownloader.showUpdateDialog(
//     Get.context!,
//     currentPatchNumber,
//     nextPatchNumber,
//   ),
// ).checkPatch();
  print("start downloader");
  
  // prefs = await SharedPreferences.getInstance();
  // print("prefs ="+prefs.toString());

  final downloader = ShorebirdCheckDownloader(appid: '17e24122-5f70-40c2-8d57-ce39c7615308');
  // await downloader.onDownloadProgress((size,totol) => print("$size/$totol"));
  // await downloader.allowDownloadPatchHandle((size,totol) => print("$size/$totol"));
  // downloader.onDownloadStart()
  downloader.checkPatch();
  String myString = "https://jsonplaceholder.typicode.com/users";
// try {
//   Uri myUri = Uri.parse(myString);
//   // 使用解析的 Uri
//   var response = await http.get(myUri as Uri);
//   var responseBody = response.body;
//   // String formattedJson = jsonEncode(responseBody);
//   // var prettyJsonString = JsonEncoder.withIndent('  ').convert(responseBody);

//   print("responseBody ==" + responseBody);
//   // debugPrint("responseBody ==" +responseBody, wrapWidth: 1024);
//   debugPrint("responseBody ==" +responseBody);
//   var response2 = await http.post(myUri as Uri,
//     headers: {
//       'Content-type': 'application/json; charset=UTF-8'
//     },
//     body: utf8.encode(jsonEncode({
//       'id': 11,
//       'name': 'Justin Lin',
//       'username': 'caterpillar',
//       'email': 'caterpillar@openhome.cc'
//     }))
//   );

//   var responseBody2 = response2.body;
//   print("responseBody2 ==" + responseBody2);
// } catch (e) {
//   if (e is FormatException) {
//     print("Invalid Uri format");
//   } else {
//     rethrow; // 重新抛出意外的异常
//   }
// }

//  Future<Map> conf = loadConfig("../pubspec.yaml");
//   conf.then((Map config) {
//     print(config['name']);
//     print(config['description']);
//     print(config['version']);
//     print(config['author']);
//     print(config['homepage']);
//     print(config['dependencies']);
//   });

  try {
    // 读取 pubspec.yaml 文件
    String pubspecContent = await rootBundle.loadString('pubspec.yaml');

    // 解析 YAML 格式的内容
    Map<dynamic, dynamic> pubspecYaml = loadYaml(pubspecContent);

    // 获取 dependencies 部分
    Map<dynamic, dynamic> dependencies = pubspecYaml['dependencies'];

    // 打印依赖信息
    print('依赖的包：');
    dependencies.forEach((key, value) {
      print('$key: $value');
    });
  } catch (e) {
    print('Error: $e');
  }

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page T'),
      home: MyHomePage(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Flutter Demo Home Page T'),
      //   ),
      //   body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       // const MyHomePage(title: 'Flutter Demo Home Page T'),
      //       Image.asset('assets/test.png'), // 替换成你的图片路径
      //     ],
      //   ),
      // ),
      // ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const BasicMessageChannel<String> _channel =
      BasicMessageChannel<String>('com.example.basic_channel', StringCodec());

  String _messageFromNative = 'No message received yet';
  final TextEditingController _textController = TextEditingController();
  final List<String> _dataList = []; // 儲存資料的列表

  @override
  void initState() {
    super.initState();
    _channel.setMessageHandler(_handleMessage);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<String> _handleMessage(String? message) async {
    setState(() {
      _messageFromNative = message ?? 'No message received';
    });
    return 'Message received on Flutter';
  }

  void _sendMessageToNative() {
    _channel.send('Hello from Flutter!');
  }

  void _addData() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _dataList.add(_textController.text);
        _textController.clear(); // 清空輸入框
      });
    }
  }

  void _deleteData(int index) {
    setState(() {
      _dataList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BasicMessageChannel Example',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              _messageFromNative,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessageToNative,
              child: Text(
                'Send Message to Native',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _textController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: '請輸入文字',
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
                hintText: '在這裡輸入...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.red[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.deepPurple,
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.edit,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addData,
                icon: Icon(Icons.add),
                label: Text(
                  '新增資料',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(thickness: 2, color: Colors.deepPurple),
            SizedBox(height: 10),
            Text(
              '資料列表 (${_dataList.length} 筆)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _dataList.isEmpty
                  ? Center(
                      child: Text(
                        '尚無資料\n請在上方輸入文字並點擊新增',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _dataList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              _dataList[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteData(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

    

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter=_counter +2;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
