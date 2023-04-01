import 'dart:io';

import 'package:novel/screen/SplachScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';
import 'const.dart';
import 'localizations.dart';
import 'model/transaction.dart';
import 'notification_ontroller.dart';

void main() async{
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

 // FlutterNativeSplash.removeAfter(initialization);

  //FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //NotificationController notificationController = Get.put(NotificationController());
/*
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
*/

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: [SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  var box = Boxes.getTransactions();
  transactions = box.values.cast<Transaction>().toList();
  if(transactions!.isEmpty) {
    await addTransaction();
  } else{
    guestType = transactions![0].guestType;
    ordersList = transactions![0].ordersList;
    productList = transactions![0].productList;
    categoryList = transactions![0].categoryList;
    subCategoryList = transactions![0].subCategoryList;
    salesList = transactions![0].salesList;
    brandsList = transactions![0].brandsList;
    shippingMethodsList = transactions![0].shippingMethodsList;
    homeSection4List = transactions![0].shopNowList;
    homeSection2List = transactions![0].newArrivalList;
    homeSection1List = transactions![0].homeSection1List;
    cartList = transactions![0].cartList;
    cartListTotal = transactions![0].cartListTotal;
    wishList = transactions![0].wishList;
    myAddress =transactions![0]. myAddress;
    selectedAddress = transactions![0].selectedAddress;
    countries = transactions![0].countries;
    currency = transactions![0].currency;
    currencyValue = transactions![0].currencyValue;
    paymentCard = transactions![0].paymentCard;
    notificationAndEmail = transactions![0].notificationAndEmail;
    userData = transactions![0].userData;
    userInfo = transactions![0].userInfo;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: const [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files0
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      /*When you want programmatically to change the current locale in your app, you can do it in the following way:*/
      //AppLocalizations.load(Locale('en', ''));
      supportedLocales: const [
        Locale('en','US'),
        Locale('fr','FR'),
        Locale('ar','AR'),
        Locale('tr','TR'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        //should to be in the bottom
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
      },
      title: 'COMIMANIA',
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
        primarySwatch: Colors.deepOrange,
      ),
      home: SplashScreen(),
    );
  }

}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
