import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final txtFullName = new TextEditingController();
  final txtEmail = new TextEditingController();
  bool _valName=false;
  bool _valEmail=false;

  Future _saveDetails(String name,String email) async {
    var url =Uri.parse( "https://flutterabi.000webhostapp.com/saveData.php");
    final response = await http.post(url,body: {
      "name":name,
      "email":email,
    });
    var res = response.body;
    if(res == "true"){
      Navigator.pop(context);
    }
    else{
      print("Error"+res);
    }
  }

  @override
  void dispose() {
    txtFullName.dispose();
    txtEmail.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: txtFullName,
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(
                  fontSize: 17,
                ),
                errorText: _valName ? 'Name can\'t be empty!':null,
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
        TextField(
          controller: txtEmail,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
              fontSize: 17,
            ),
            errorText: _valEmail ? 'Email can\'t be empty!':null,
            labelText: 'Email',
            labelStyle: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: (){
                      setState((){
                        txtFullName.text.isEmpty ? _valName =true :_valName = false;
                        txtEmail.text.isEmpty ? _valEmail =true :_valEmail = false;

                        if(_valName == false && _valEmail == false){
                          _saveDetails(txtFullName.text,txtEmail.text);
                        }

                      });
                    },
                    child: Text("Save Details")
                ),
                ElevatedButton(
                    onPressed: (){
                      txtFullName.clear();
                      txtEmail.clear();
                    },
                    child: Text("Clear")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
