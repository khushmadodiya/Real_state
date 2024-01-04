import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:real_state_auth/global.dart';
import 'package:real_state_auth/resources/firestore_methods.dart';
import 'package:real_state_auth/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatefulWidget {
  final snap;
  const CustomerCard({
    super.key,
    required this.snap,
  });

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final ref = FirebaseFirestore.instance
      .collection('admin')
      .doc(adminuid)
      .collection('customers')
      .snapshots();
  void _delete() async {
    String res = await firestoreMethos().delete(widget.snap['uid']);
    showSnackbar(context, res);
  }

  _showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            children: [
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Delete this customer detail'),
                  onPressed: () {
                    _dialog(context);
                    // Navigator.pop(context);
                  })
            ],
          );
        });
  }

  _dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text('Are you sure'), actions: [
              TextButton(
                  onPressed: () {
                    _delete();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Yes'))
            ]));
  }

  void _launchEmail(String emailAddress) async {
    final url = 'mailto:$emailAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the case where Gmail cannot be launched
      print('Could not launch $url');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch Gmail')));
    }
  }

  void _launchPhoneCall(String phoneNumber) async {

    final url = Uri(scheme: 'tel',path: phoneNumber  );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Handle the case where the phone app cannot be launched
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width > webScreenSize ? width * 0.3 : 30,
        vertical: width > webScreenSize ? 15 : 10,
      ),
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onLongPress: () => kIsWeb ? null : _showdialog(context),
        onDoubleTap: () => kIsWeb ? _showdialog(context) : null,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05)
              : const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white54,
                    backgroundImage: widget.snap['profile'] != '' &&
                            widget.snap['profile'] != null
                        ? NetworkImage(widget.snap['profile'])
                        : NetworkImage(
                            'https://cdn-icons-png.flaticon.com/128/3106/3106921.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    ' ${widget.snap['name'].toString()}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  _launchEmail(widget.snap['email'].toString());
                },
                child: Text(
                  '  ${widget.snap['email'].toString()}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: InkWell(
                    onTap:()=> _launchPhoneCall(widget.snap['phone'].toString()),
                child: Text(
                  '  ${widget.snap['phone'].toString()}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
