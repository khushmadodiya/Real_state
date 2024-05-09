import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/admin_screen.dart';
import 'Screens/loginScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor:  Color.fromRGBO(0, 0, 0, 1)),
      title: 'real state',
      debugShowCheckedModeBanner: false,
      home:StreamBuilder  (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return AdminScreen();
            }
            else if(snapshot.hasError){
              return Center(child: Text('Error occure'));
            }
          }
          if(snapshot.connectionState==ConnectionState.waiting){
                 return Center(child: CircularProgressIndicator(color: Colors.white,));
          }
          return LoginScreen();
        },
      ),
    );
  }
}
