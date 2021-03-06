import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soft_bloc/bloc/auth/auth_bloc.dart';
import 'package:soft_bloc/services/user_repository.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot userData;
  HomePage({Key key,this.userData}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg:"Double click to exit..");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) =>
      AuthBloc(UserRepository())..add(CheckPermanentUser()),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.list),
            title: Text("Home"),
            centerTitle: true,
          ),
          body: BlocListener<AuthBloc,AuthState>(listener: (context,state){
            if(state is WarningPermanentUser){
              print("Permanent");
              return _showDialog();
            }
            if(state is WarningFreeUser){
              print("free user");
              return _showDialog();
            }
            if(state is Unauthenticated) {
              Navigator.pushNamed(context, "/");
            }
          },
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                  Text(widget.userData.data['fullName']),
//                  Text(widget.userData.data['imei']),
                    RaisedButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.deepPurpleAccent,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoggedOut(),
                        );
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
