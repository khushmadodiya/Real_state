
import 'package:InfoLinker/widgets/field_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart';

import '../global.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
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
    final url = Uri(scheme: 'mailto',path: emailAddress);
    final weburl = Uri.parse('https://mail.google.com/mail/u/0/#inbox?compose=new');
    Clipboard.setData(ClipboardData(text: emailAddress));
    if (await canLaunchUrl(url)) {
     kIsWeb? await launchUrl(weburl,mode: LaunchMode.inAppWebView): await launchUrl(url,mode: LaunchMode.externalApplication);
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
        horizontal: width > webScreenSize ? width * 0.3 : 20,
        vertical: width > webScreenSize ? 15 : 8,
      ),
      height: MediaQuery.of(context).size.height / 3.5,
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
              : const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    color: Colors.transparent,
                    child: Container(
                      width: 40,
                      height: 30,
                      child: Image.network( widget.snap['profile'] != '' &&
                          widget.snap['profile'] != null
                          ? widget.snap['profile'].toString()
                          :
                          'https://cdn-icons-png.flaticon.com/128/3106/3106921.png'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FieldContainer(
                      text: '${widget.snap['name'].toString()}',
                    ),
                  ),
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
                child:FieldContainer(
                  text:  '  ${widget.snap['email'].toString()}',
                  icon: Icon(Icons.mail_outline,color: Colors.black,),
                ),)),

              Expanded(
                  child: InkWell(
                    onTap:()=> _launchPhoneCall(widget.snap['phone'].toString()),
                child:FieldContainer(
                  text:  '  ${widget.snap['phone'].toString()}',
                  icon: Icon(Icons.phone,color: Colors.black,),
                )
              )),
              SizedBox(height: 10,)            ],
          ),
        ),
      ),
    );
  }
}
