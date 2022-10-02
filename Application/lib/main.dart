import 'dart:convert';

import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/models/credit_card.dart';
import 'package:cinema_tickets/routes.dart';
import 'package:cinema_tickets/screens/new/mains.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:cinema_tickets/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> initHive() async {
  Hive.registerAdapter<CreditCard>(CreditCardAdapter());
  await Hive.initFlutter();
  final secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }

  var encryptionKey = base64Url.decode((await secureStorage.read(key: 'key'))!);
  await Hive.openBox<CreditCard>('cards',
      encryptionCipher: HiveAesCipher(encryptionKey));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Application.token;
  await initNotification();
  await initHive();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema Tickets',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        appBarTheme: AppBarTheme(color: kBackGroundColor, elevation: 0),
        backgroundColor: Colors.black45,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      initialRoute: TestHomeScreen.routeName,
      routes: routes,
    );
  }
}
