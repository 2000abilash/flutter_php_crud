import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:php_flutter_crud/addUser.dart';
import 'package:php_flutter_crud/updateUsers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: <String,WidgetBuilder>{
        '/addUser':(BuildContext context)=>AddUser(),
      },
    );
  }
}

Future<List?> getData() async{
  var url=Uri.parse("https://flutterabi.000webhostapp.com/getData.php");
  final response = await http.get(url);
  var dataRecieved = json.decode(response.body);
  print(dataRecieved);
  return dataRecieved;
}

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoad=true;
  @override
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.yellow,
      color: Colors.red,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        setState((){isLoad=false;});
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          isLoad=true;
          getData();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("CRUD PHP & FLUTTER"),
        ),
        body:isLoad?FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              print("Error in Loading"+snapshot.error.toString());
            }
            return snapshot.hasData?ItemList(list: snapshot.data,) : Center(child: CircularProgressIndicator(),);
          },
        ):Center(child: CircularProgressIndicator(),),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addUser');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  
  final list;
  const ItemList({Key? key,this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == 0 ?0:list.length,
        itemBuilder: (context,i){
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(list[i]['NAME'].toString().substring(0,1).toUpperCase()),
              ),
              title: Text(list[i]['NAME'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(list[i]['EMAIL'],
              style: TextStyle(
                fontSize: 15,
                color: Colors.indigo,
              ),
              ),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>
                    UpdateUsers(id:list[i]['ID'],name:list[i]['NAME'],email:list[i]['EMAIL'],),

                ),
                );
              },
            ),
          );
        });
  }
}
