import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zero_to_hero/LoginPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

AndroidNotificationChannel channel = AndroidNotificationChannel('high_importance', 'Notifs');
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.
    resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  runApp(MyApp());


}



class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key); //not sure if this is necessary

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: SplashScreen(),
    );
  }


}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 166, 189, 240),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset('assets/ZeroToHero.png'),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
