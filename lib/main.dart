import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/models/centre.dart';
import 'package:shifaa/models/doctor.dart';
import 'package:shifaa/utils/local_storage.dart';
import 'package:shifaa/views/doctor_views/doctor_home/doctor_home_page.dart';
import 'package:shifaa/views/shared_views/login/login_page.dart';

import 'package:shifaa/views/shared_views/pageNotFound.dart';
import 'package:shifaa/views/patient_views/nav_page/nav_page.dart';
import 'package:shifaa/views/shared_views/register/register_page.dart';
import 'package:statusbarz/statusbarz.dart';

import 'controllers/notification_provider.dart';
import 'firebase_options.dart';
import 'models/patient.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationProvider.requestFirebasePerms();

  FirebaseMessaging.onBackgroundMessage(
      NotificationProvider.firebaseMessagingBackgroundHandler);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  bool patientLoggedIn = await LocalStorage.checkIfValueExist('patientId');
  bool doctorLoggedIn = await LocalStorage.checkIfValueExist('doctorId');
  Future.delayed(Duration(seconds: 2))
      .whenComplete(() => FlutterNativeSplash.remove());
  runApp(Phoenix(
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      useOnlyLangCode: true,
      assetLoader: JsonAssetLoader(),
      child: MyApp(patientLoggedIn, doctorLoggedIn),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool patientLoggedIn;
  final bool doctorLoggedIn;

  const MyApp(
    this.patientLoggedIn,
    this.doctorLoggedIn, {
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return StatusbarzCapturer(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => UserProvider(context),
                lazy: false,
              ),
              ChangeNotifierProvider(
                create: (context) => NotificationProvider(),
                lazy: false,
              ),
            ],
            builder: (context, child) => MaterialApp(
              title: "Shifaa",
              showPerformanceOverlay: false,
              navigatorObservers: [Statusbarz.instance.observer],
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.transparent,
                      titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik',
                          fontSize: 18)),
                  primarySwatch: Colors.blue,
                  cardTheme: const CardTheme(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  fontFamily: 'Rubik'),
              initialRoute: handleType(),
              onGenerateRoute: (settings) {
                final args = settings.arguments;

                switch (settings.name) {
                  case 'login':
                    return MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                        settings: settings);

                  case 'home':
                    return MaterialPageRoute(
                        builder: (context) => const NavPage(),
                        settings: settings);

                  case 'doctorHome':
                    return MaterialPageRoute(
                        builder: (context) => const DoctorHomePage(),
                        settings: settings);

                  case 'register':
                    return MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                        settings: settings);

                  default:
                    return MaterialPageRoute(
                      builder: (context) => const PageNoteFound(),
                    );
                }
              },
              home: const Placeholder(),
            ),
          ),
        );
      },
    );
  }

  handleType() {
    if (patientLoggedIn)
      return 'home';
    else if (doctorLoggedIn)
      return 'doctorHome';
    else
      return 'login';
  }
}
