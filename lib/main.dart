import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'dart:io';
// import 'dart:html';
// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mes12quetta/syncronize.dart';

import 'contactinfomodel.dart';
import 'controller.dart';
import 'databasehelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteDatabaseHelper.instance.db;
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MES 12 12Corps',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget txt=Text('No Image Selected',textAlign: TextAlign.center,style: TextStyle(fontSize:12,letterSpacing:0.4,color: Colors.grey[500]));
  String base64Image="",FileName="";
  Future<File> file;
  File tmpFile;

  Timer _timer;
  TextEditingController meter_no = TextEditingController();
  // TextEditingController peak = TextEditingController();
  TextEditingController offpeak = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  // String month;
  // String year;
  // List<String> month_id=['Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
  // List<String> year_id=['2021','2021','2023','2024'];
  List list;
  bool loading = true;
  Future userList()async{
    list = await Controller().fetchData();
    setState(() {loading=false;});
    //print(list);
  }

  Future syncToMysql()async{
    await SyncronizationData().fetchAllInfo().then((userList)async{
      EasyLoading.show(status: 'انتظار کرو ..... ڈیٹا اپ لوڈ ہو رہا ہے۔ موبائل بند نہ کریں۔...');
      await SyncronizationData().saveToMysqlWith(userList);
      EasyLoading.showSuccess('Successfully save to mysql');
    });
  }

  // Future isInternet()async{
  //   await SyncronizationData.isInternet().then((connection){
  //     if (connection) {
  //
  //       print("Internet connection available");
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Internet")));
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    userList();
    // isInternet();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MES 12Corps",textAlign: TextAlign.center),
        actions: [
          Text("Refersh"),
          IconButton(icon: Icon(Icons.refresh_sharp), onPressed: ()async{
            syncToMysql();
            // await SyncronizationData.isInternet().then((connection){
            //   if (connection) {
            //     syncToMysql();
            //     print("Internet connection available");
            //   }else{
            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Internet")));
            //   }
            // });
          })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: meter_no,
              decoration: InputDecoration(hintText: 'Enter Meter No'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: offpeak,
              decoration: InputDecoration(hintText: 'Enter Current Meter Reading'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: month,
              decoration: InputDecoration(hintText: 'Enter month'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: year,
              decoration: InputDecoration(hintText: 'Enter Year'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: Colors.grey[300])
              ),
              color: Colors.grey[200],
              onPressed: chooseImage,
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              child: Text("Choose Image",style: TextStyle(color: Colors.black54,fontSize:10,fontWeight: FontWeight.w500,letterSpacing: 0.1),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
            child: RaisedButton(color: Colors.green,
              onPressed: () async{
                ContactinfoModel contactinfoModel = ContactinfoModel(meter_no: meter_no.text,offpeak: offpeak.text,month:month.text,year:year.text,datetime: DateTime.now().toString());
                await Controller().addData(contactinfoModel).then((value){
                  if (value>0) {
                    print("Success");
                    userList();
                  }else{
                    print("Failed");
                  }

                });
              },
              child: Text("Save"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(color: Colors.black,
              onPressed: () async{
                ContactinfoModel contactinfoModel = ContactinfoModel(meter_no: meter_no.text,offpeak: offpeak.text,month:month.text,year:year.text,datetime: DateTime.now().toString());
                await Controller().deleteData(contactinfoModel).then((value){
                  if (value>0) {
                    // AlertDialog(title: Text("Simple Alert"),
                    //     content: Text("This is an alert message."),);
                        print("Success Deleted");
                    userList();
                  }else{
                    print("Failed");
                  }

                });
              },
              child: Text(" کریں۔ Delete اپ لوڈ کے بعد تمام ریکارڈ ",style: TextStyle(color: Colors.yellow), ),
            ),
          ),
          //delete
          loading ?Center(child: CircularProgressIndicator()):Expanded(
            child: ListView.builder(
              itemCount: list.length==null?0:list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(list[index]['id'].toString()),
                      SizedBox( width: 2,),
                      Text(list[index]['meter_no']),
                      SizedBox( width: 2,),
                      Text(list[index]['offpeak']),
                      SizedBox( width: 2,),
                      Text(list[index]['month']),
                      SizedBox( width: 2,),
                      Text(list[index]['year']),
                     // Text(list[index][' base64Image'])

                    ],),
                  // subtitle: Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //
                  //     Text(list[index]['month']),
                  //     SizedBox( width: 5,),
                  //     Text(list[index]['year']),
                  //
                  //   ],),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showImageDialogue(ctx) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          title: Text("Add an Image"),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                height: height*0.07,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(onTap:(){
                      setState(() {
                        file=ImagePicker.pickImage(source: ImageSource.camera,
                            maxHeight: 1024, maxWidth: 768,imageQuality: 96);
                      });
                      Navigator.pop(context);
                    },
                      child: Text("Take a photo"),),
                    InkWell(onTap:(){
                      setState(() {
                        file=ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 1024, maxWidth: 768,
                          imageQuality: 96,);
                      });
                      Navigator.pop(context);
                    } ,child: Text("Choose from gallery"),)
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }
  Widget chooseImage(){
    showImageDialogue(context);
  }

  Widget showImage(){
    return FutureBuilder<File>(

        future: file,
        builder: (BuildContext context,AsyncSnapshot<File>  snapshot){
          if(snapshot.connectionState==ConnectionState.done
              && snapshot.data!=null){
            tmpFile=snapshot.data;
            base64Image=base64Encode(snapshot.data.readAsBytesSync());
            if(tmpFile!=null){
              FileName=tmpFile.path.split('/').last;
            }
            return Text(
              "image.png",style: TextStyle(fontSize: 11,color: Colors.grey[500]),
            );
          }
          else if(snapshot.error!=null){
            return const Text('Error Picking Image',textAlign: TextAlign.center,);
          }
          else{
            return txt;
          }
        }
    );
  }
}
