// @dart=2.9
import 'dart:ffi';
import 'package:astrodrishti_app/brain/ads.dart';
import 'package:astrodrishti_app/screens/sidescreens/loading.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astrodrishti_app/update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'cubit/astrocubit_cubit.dart';

import 'startpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

int version = 6;

BannerAd ads;
CreateAd ade = CreateAd();
// String hemlo = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')],
      path: 'Assets',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkupdate();
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    super.initState();
  }

  Widget startpage = loading();

  Future<void> checkupdate() async {
    var snap = await FirebaseFirestore.instance
        .collection("AppData")
        .doc("update")
        .get();
    int ver = (snap.data() as dynamic)["Version"];
    if (version >= ver) {
      setState(() {
        startpage = start_page();
      });
    } else if (version != ver) {
      setState(() {
        startpage = update_page();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return BlocProvider(
      create: (context) => AstrocubitCubit(),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          // textTheme: GoogleFonts.aBeeZeeTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),
        home: startpage,
      ),
    );
  }
}
