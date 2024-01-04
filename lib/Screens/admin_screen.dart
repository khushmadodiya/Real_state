import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global.dart';
import '../resources/auth_methos.dart';
import '../utils/utils.dart';
import '../widgets/customer_detail_card.dart';
import 'home_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController urlcontroller = TextEditingController();
  String urlText = "https://real-state-60a2b.web.app/?uid=$adminuid";

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: urlText));
    showSnackbar(context, 'Text copied to clipboard');
  }

  _showdialog(BuildContext context) {
    bool _loading = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black,
          title: Text('Setting'),
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Add New Customer Detail'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: _loading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : Text('Log Out'),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                await AuthMethods().signOut();
                setState(() {
                  _loading = false;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Real State'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => _showdialog(context),
              icon: Icon(Icons.settings),
            ),
          ],
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration:BoxDecoration(
                          border: Border.all(color: Colors.deepPurple)
                        ),
                        child: SelectableText(
                          urlText,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                          ),
                      ),
                      ),

                    IconButton(
                      onPressed: _copyToClipboard,
                      icon: Icon(Icons.copy),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .doc(adminuid)
                    .collection('customers')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return CustomerCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                    },
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
