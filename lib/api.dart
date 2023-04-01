

import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:novel/MyWidget.dart';
import 'package:novel/firebase/Firebase.dart';
import 'package:novel/screen/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:mailer/smtp_server/gmail.dart';

import 'color/MyColors.dart';
import 'const.dart';
//import 'firebase/Firebase.dart';
import 'localization_service.dart';
import 'localizations.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:mailer/mailer.dart';

//import 'screen/singnIn.dart';
class MyAPI{
  final _baseUrl = 'https://novelnh.com/Api';
  //MyFirebase myFirebase = MyFirebase();

  Future<String?> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  String _getDevicePlatform() {
    var plattform = 'android';
    if (Platform.isIOS) { //// import 'dart:io'
      plattform = 'IOS';
    } else if(Platform.isAndroid) {
      plattform = 'ANDROID';
    }
    return plattform;
  }

  Future register(firstName, lastName, phone, email, password, dateBirth, gender) async{
    try{
      var  apiUrl =Uri.parse("$_baseUrl/Creat_User?email=$email&password=$password&firstName=$firstName&lastName=$lastName&phone=$phone&birthDate=$dateBirth&gender=$gender");
      //var  apiUrl =Uri.parse("$_baseUrl/Creat_User?email=$email&password=$password&firstName=$firstName&lastName=$lastName&phone=$phone&gender=$gender");
      //var  apiUrl =Uri.parse("$_baseUrl/Creat_User");
      Map mapDate = {
        "FirstName": firstName,
        "LastName": lastName,
        "Phone": phone,
        "Email": email,
        "Password": password,
        "BirthDate":dateBirth,
        "Gender":gender
      };

      http.Response response = await http.post(apiUrl,
          //body: jsonEncode(mapDate),
          //encoding: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);
      /*{"success":1,"status":200,"userId":60,"confirmcode":"305390","message":"Account successfully created."}*/
//      {"success":1,"status":200,"userId":62,"confirmcode":"979379","message":"Account successfully created."}
    //      {"success":1,"status":200,"userId":0,"confirmcode":"991748","message":"Account successfully created."} osh@gmail.com
     // success: 1, status: 200, userId: 71, confirmcode: 636292, message: Account successfully created oh@gmail.com
    print('Res: ------------------------');
      print(response.body);
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        if(jsonDecode(response.body)['status']==200){
          print(jsonDecode(response.body));
          //token = await jsonDecode(response.body)['content']['token'];
          userData = await jsonDecode(response.body);//id , email, name, token, fbKey
          editTransactionUserData();
          //await readUserInfo(userData['id']);
          flushBar(jsonDecode(response.body)['message']);
          return true;
        }
      }
      print(jsonDecode(response.body)['message']);
      flushBar(jsonDecode(response.body)['message']);
      return false;
    }catch(e){
      //flushBar(e.toString());
      return false;
    }

   }

  //MyFirebase myFirebase = MyFirebase();
  BuildContext? context;
  MyAPI({this.context});

  Map userobj = {};//for facebookSignIn

  faceBookLogIn(Function() _setState) async{
    var fcmToken;
    var deviceID = await _getDeviceId();
    var devicePlatform = _getDevicePlatform();
    try{
      //fcmToken = await myFirebase.getToken();
      print(fcmToken);
      print(fcmToken);
    }
    catch(e){
      fcmToken='';
      print(e);
      flushBar(e.toString());
    }
    fbLog()async {
      try {
        FacebookAuth.instance.getUserData().then((userData111) async {
            userobj = userData111;
          //setState(()=>chLogIn =true);
          var mobile = userobj["phone"] ??= '';
          var email = userobj["email"] ??= 'No Email';
          var id = userobj["id"];
          var firstName = userobj["name"].toString().split(' ')[0];
          var lastName = userobj["name"].toString().split(' ')[1];
            pleaseWait = true;
            _setState();
            var  apiUrl =Uri.parse("$_baseUrl/CreatUserFG?email=$email&FGtoken=$id&firstName=$firstName&lastName=$lastName&FGtype=facebook");
            http.Response response = await http.post(apiUrl, headers: {
              //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
              "Accept": "application/json",
              "content-type": "application/json",
            });
            apiUrl =Uri.parse("$_baseUrl/FGLogin?FGtoken=$id&FGtype=google&deviceToken=$fcmToken&deviceId=$deviceID&deviceType=$devicePlatform");
            response = await http.post(
                apiUrl,
                //Uri.parse('$_baseUrl/api/Auth/Login?'),
                //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
                //body: jsonEncode({"email": email, "password": password}),
                headers: {
                  //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
                  "Accept": "application/json",
                  "content-type": "application/json",
                });
            //await Hive.initFlutter();
            //Hive.registerAdapter(TransactionAdapter());
            //await Hive.openBox<Transaction>('transactions');
            //print(email + ',' + password);
            //print(jsonDecode(response.body));
            if(jsonDecode(response.body)['status'] == 200){
              print(jsonDecode(response.body));
              token = await jsonDecode(response.body)['token'];
              userData = await jsonDecode(response.body);//id , email, name, token, fbKey
              editTransactionUserData();
              var s = await readUserInfo(userData['token']);
              await getUserAddress(userData['token']);
              if(guestType){
                await MyAPI(context: context).clearShopCartGuest();
              }
              await getFromApi(false, context);
              guestType = false;
              editTransactionGuestType();
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString('email', email);
              //sharedPreferences.setString('password', _passwordController.text);
              sharedPreferences.setString('token', token);
              sharedPreferences.setBool('logIn', true);
              pleaseWait = false;
              _setState();
              Navigator.pushAndRemoveUntil(
                context!,
                MaterialPageRoute(
                    builder: (context) => MainScreen()
                ),
                    (Route<dynamic> route) => false,
              );
              return true;
            }
            else{
              pleaseWait = false;
              _setState();
              flushBar(jsonDecode(response.body)['message']);
              return false;
            }

        });
      } catch (e) {
        pleaseWait = false;
        _setState();
        flushBar(e.toString());
      }
    }
    FacebookAuth.instance.login(permissions: [
      "public_profile", "email"
    ]).then((value) async {
      if (value.status.index == 1) {
        flushBar(AppLocalizations.of(context!)!.translate(
            "Sign in doesn't complete"));
        return;
      } else if (value.status.index == 0) {
        await fbLog();
      } else {
        flushBar(value.message.toString());
        return;
      }
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount? userObjg; //for google

  googleLogIn(Function() _setState) async{
    // FacebookAuth.instance.getUserData().then((userData) async {
    var fcmToken;
    var deviceID = await _getDeviceId();
    var devicePlatform = _getDevicePlatform();
    try{
      //fcmToken = await myFirebase.getToken();
      print(fcmToken);
      print(fcmToken);
    }
    catch(e){
      fcmToken='';
      print(e);
      flushBar(e.toString());
    }
    try{
      _googleSignIn.signIn().then((userData111) async{
          userObjg = userData111;
        if (userObjg == null) {
          flushBar(AppLocalizations.of(context!)!.translate("Sign in doesn't complete"));
          return '';
        }
        //setState(()=>chLogIn =true);
          pleaseWait = true;
        _setState();
        var  apiUrl =Uri.parse("$_baseUrl/CreatUserFG?email=${userObjg!.email}&FGtoken=${userObjg!.id}&firstName=${userObjg!.displayName.toString().split(' ')[0]}&lastName=${userObjg!.displayName.toString().split(' ')[1]}&FGtype=google");
        http.Response response = await http.post(apiUrl, headers: {
                //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
                "Accept": "application/json",
                "content-type": "application/json",
              });
          apiUrl =Uri.parse("$_baseUrl/FGLogin?FGtoken=${userObjg!.id}&FGtype=google&deviceToken=$fcmToken&deviceId=$deviceID&deviceType=$devicePlatform");
          response = await http.post(
              apiUrl,
            //Uri.parse('$_baseUrl/api/Auth/Login?'),
              //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
              //body: jsonEncode({"email": email, "password": password}),
              headers: {
                //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
                "Accept": "application/json",
                "content-type": "application/json",
              });
          //await Hive.initFlutter();
          //Hive.registerAdapter(TransactionAdapter());
          //await Hive.openBox<Transaction>('transactions');
          //print(email + ',' + password);
          //print(jsonDecode(response.body));
          if(jsonDecode(response.body)['status'] == 200){
            print(jsonDecode(response.body));
            token = await jsonDecode(response.body)['token'];
            userData = await jsonDecode(response.body);//id , email, name, token, fbKey
            editTransactionUserData();
            var s = await readUserInfo(userData['token']);
            await getUserAddress(userData['token']);
            if(guestType){
              await MyAPI(context: context).clearShopCartGuest();
            }
            await getFromApi(false, context);
            guestType = false;
            editTransactionGuestType();
            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString('email', userObjg!.email);
            //sharedPreferences.setString('password', _passwordController.text);
            sharedPreferences.setString('token', token);
            sharedPreferences.setBool('logIn', true);
            pleaseWait = false;
            _setState();
            Navigator.pushAndRemoveUntil(
              context!,
              MaterialPageRoute(
                  builder: (context) => MainScreen()
              ),
                  (Route<dynamic> route) => false,
            );
            return true;
          }
          else{
            pleaseWait = false;
            _setState();
            flushBar(jsonDecode(response.body)['message']);
            return false;
          }
      });
    }catch(e){
      pleaseWait = false;
      _setState();
      flushBar(e.toString());
      return false;
    }
  }

  login(email , password) async{
    var fcmToken;
    var deviceID = await _getDeviceId();
    var devicePlatform = _getDevicePlatform();
    try{
      //fcmToken = await myFirebase.getToken();
      print(fcmToken);
      print(fcmToken);
    }
    catch(e){
      fcmToken='';
      print(e);
      flushBar(e.toString());
    }
    try{
      http.Response response = await http.post(
          //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/Login?email=$email&password=$password&deviceToken=$fcmToken&deviceId=$deviceID&deviceType=$devicePlatform"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(jsonDecode(response.body)['status'] == 200){
        print(jsonDecode(response.body));
          token = await jsonDecode(response.body)['token'];
          userData = await jsonDecode(response.body);//id , email, name, token, fbKey
          editTransactionUserData();
          var s = await readUserInfo(userData['token']);
          if(!s) return false;
          await getUserAddress(userData['token']);
          return true;
      }
      else{
        flushBar(jsonDecode(response.body)['message']);
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  forgetPassword(email) async{
    try{
      http.Response response = await http.post(
          Uri.parse("$_baseUrl/ForgotPassword?email=$email"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(jsonDecode(response.body)['status'] == 200){
        print(jsonDecode(response.body));
        userData = await jsonDecode(response.body);//id , email, name, token, fbKey
        return true;
      }
      else if(jsonDecode(response.body)['status'] == 423){
        flushBar(AppLocalizations.of(context!)!.translate('Your Email is invalid!'));
        return false;
      }
    else if(jsonDecode(response.body)['status'] == 424){
        flushBar(AppLocalizations.of(context!)!.translate('This email does not exist!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  resetPassword(userId, code, newPassword) async{
    try{
      http.Response response = await http.post(
          Uri.parse("$_baseUrl/ResetPassword?userId=$userId&confirmcode=$code&newpassword=$newPassword"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      return response;
      if(jsonDecode(response.body)['status'] == 200){
        print(jsonDecode(response.body));
        return true;
      }
      else{
        flushBar(jsonDecode(response.body)['message']);
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  updateUserLang(token , lang) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/UpdateLang?$token=1&lang=$lang'),
          //body: jsonEncode({"intParam": langNum.toString(), "guidParam": id.toString()}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print(response.body);
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      print(e);
    }
  }

  updateUser(token , firstName, lastName, phone) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/UpdateUser?token=$token&firstName=$firstName&lastName=$lastName&phone=$phone'),
          //body: jsonEncode({"intParam": langNum.toString(), "guidParam": id.toString()}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print(response.body);
      if(jsonDecode(response.body)['status'] == 200){
        print(jsonDecode(response.body));
        var s = await readUserInfo(token);
        if(!s) return false;
        flushBar(jsonDecode(response.body)['message']);
        return true;
      }
      else{
        flushBar(jsonDecode(response.body)['message']);
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      print(e);
    }
  }

  ver(userId, code)async{
    var apiUrl = Uri.parse('$_baseUrl/Confirm_User?userId=$userId&confirmcode=$code');
    /*Map mapDate = {
      "guidParam": value,
      "txtParam": code,
    };*/
    http.Response response = await http.post(apiUrl,
        //body: jsonEncode(mapDate),
        headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });
    print(response.statusCode);
    print(response.body);
    return response;
  }

  resend(userId)async{
    var apiUrl = Uri.parse('$_baseUrl/ResendCode?userId=$userId');
    /*Map mapDate = {
      "guidParam": value,
      "txtParam": code,
    };*/
    http.Response response = await http.post(apiUrl,
        //body: jsonEncode(mapDate),
        headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<bool?> getBrands() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/Brands"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        brandsList = jsonDecode(response.body);
        editTransactionBrandList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return false;
  }

  Future<bool?> getShippingMethods() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/ShippingMethods"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        shippingMethodsList = jsonDecode(response.body);
        editTransactionShippingMethodList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getUserAddress(token) async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/User_Address/$token"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        myAddress = jsonDecode(response.body);
        editTransactionMyAddress();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getCurrency() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/Currency?"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        currency = jsonDecode(response.body);
        if(currency.isNotEmpty && currencyValue.isEmpty) currencyValue = currency[currency.indexWhere((element) => element['CurValue'].toString()==1.toString())];
        editTransactionCurrency();
        editTransactionCurrencyVale();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getUserCountries(token) async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/Countries/$token"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        countries = jsonDecode(response.body);
        editTransactionCountries();

        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getCategories() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/MainCategories/$token"),
          Uri.parse("$_baseUrl/MainCategories?"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        categoryList = jsonDecode(response.body);
        editTransactionCategory();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return false;
  }

  getSubCategories(token, catId) async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/SubCategories/$token/$catId"),
          Uri.parse("$_baseUrl/SubCategories/$catId"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        subCategoryList = jsonDecode(response.body);
        editTransactionSubCategory();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool> getProducts() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/Products/$token"),
          Uri.parse("$_baseUrl/Products?"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        productList = jsonDecode(response.body);
        editTransactionProductList();
        //changeProductPrice(productList);
        salesList.clear();
        for(int i=0; i<productList.length; i++){
          if(productList[i]['discount'].toString() != 0.toString()) {
            salesList.add(productList[i]);
          }
        }
        editTransactionSalesList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return false;
  }

  getOrders() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/Products/$token"),
          Uri.parse("$_baseUrl/Orders/$token"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        ordersList = jsonDecode(response.body);
        editTransactionOrderList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool?> getHomeSection1() async{
    try{
      http.Response response = await http.get(
         Uri.parse("$_baseUrl/HomeSection1"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection1List = jsonDecode(response.body);
        editTransactionHomeSection();
         return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }

  Future<bool?> getHomeSection2() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/Products/$token"),
          Uri.parse("$_baseUrl/HomeSection2"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection2List = jsonDecode(response.body);
        editTransactionNewArrivales();
        //changeProductPrice(newArrivalList);
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getHomeSection3() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection3"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection3List = jsonDecode(response.body);
        editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }

  Future<bool?> getHomeSection4() async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          //Uri.parse("$_baseUrl/Products/$token"),
          Uri.parse("$_baseUrl/HomeSection4"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection4List = jsonDecode(response.body);
        editTransactionShopNow();
        //changeProductPrice(newArrivalList);
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  Future<bool?> getHomeSection5() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection5"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection5List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }

  Future<bool?> getHomeSection6() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection6"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection6List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }
  Future<bool?> getHomeSection7() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection7"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection7List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }
  Future<bool?> getHomeSection8() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection8"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection8List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }
  Future<bool?> getHomeSection9() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection9"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection9List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }
  Future<bool?> getHomeSection10() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection-10"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection10List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }
  Future<bool?> getHomeSection11() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/HomeSection-11"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        homeSection11List = jsonDecode(response.body);
        //editTransactionHomeSection();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
    }
    return null;
  }

  createUserAddress({token, firstName, lastName,
    company, address1, address2, city, postCode, countryId, defaultAddress}) async{
    postCode??= '0000';
    defaultAddress??= false;
    //company??= 'null';
    print("$_baseUrl/Creat_U_Address?token=$token&firstName=$firstName&lastName=$lastName&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress");
    try{
      Map mapDate = {
        "token": token,
        "firstName": firstName,
        "lastName": lastName,
        "company": company,
        "address1": address1,
        "address2": address2,
        "city": city,
        "postCode": postCode,
        "countryId": countryId,
        "defultAddress": defaultAddress
      };

      http.Response response = await http.post(
        Uri.parse('$_baseUrl/Creat_U_address?token=$token&firstName=$firstName&lastName=$lastName&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress'),
          //Uri.parse("$_baseUrl/Creat_U_Address?token=$token&firstName=$firstName&lastName=$lastName&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress"),
          //Uri.parse("$_baseUrl/Creat_U_Address?token=$token&firstName=$firstName&lastName=$lastName&company=$company&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getUserAddress(token);
          return true;
        }
        else {
          flushBar(jsonDecode(response.body)['message']);
          //await getUserAddress(token);
          return false;
        }
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 423){
        flushBar(AppLocalizations.of(context!)!.translate('Your e-mail is invalid!'));
        return false;
      }
      else if(response.statusCode == 424){
        flushBar(AppLocalizations.of(context!)!.translate('This e-mail is already entered!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool?> getShopCart(token) async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/ShopCart/$token"),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        try{
          if(jsonDecode(response.body)['status'].toString()==421.toString()){
            cartList.clear();
            cartList = [];
            editTransactionCartList();
            return true;
          }
        }catch(e){
        }
        cartList = jsonDecode(response.body);
        editTransactionCartList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  getShopCartTotal(token) async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/ShopCartTotal/$token"),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        cartListTotal = jsonDecode(response.body);
        if(jsonDecode(response.body)['status']==421){
          cartListTotal.clear();
        }
        editTransactionCartListTotal();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  addShopCart({token, pIId, quantity}) async{
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/AddShopCart?token=$token&PIId=$pIId&QTY=$quantity'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCart(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  updateShopCart({token, pIId, quantity}) async{
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/UpdateCart?token=$token&PIId=$pIId&QTY=$quantity'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCart(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  checkOut({token, payType, pCId, shipId, addressId}) async{
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/CheckOut?token=$token&PayType=$payType&PCId=$pCId&ShipId=$shipId&AddressId=$addressId'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status'].toString()==200.toString()){
          lastOrderCheckout = jsonDecode(response.body);
          await getShopCart(token);
          await getOrders();
          return true;
        }
        else if(jsonDecode(response.body)['status'].toString()==400.toString()){
          flushBar(AppLocalizations.of(context!)!.translate('Please Fill in all Required Fields!'));
          return false;
        }
      else if(jsonDecode(response.body)['status'].toString()==404.toString()){
          flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
          return false;
        }
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Order not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  setPromoCode({token, code}) async{
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/SetPromoCode?token=$token&PromoCode=$code'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCartTotal(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==404){
          flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
          return false;
        }
        else if(jsonDecode(response.body)['status']==420){
          flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
          return false;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Order not found!'));
          return false;
        }
        else if(jsonDecode(response.body)['status']==422){
          flushBar(AppLocalizations.of(context!)!.translate('Promo code not found!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  setComiWallet({token, value}) async{
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/SetComiWallet?token=$token&comiValue=$value'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCartTotal(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==404){
          flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
          return false;
        }
        else if(jsonDecode(response.body)['status']==420){
          flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
          return false;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Order not found!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  deleteShopCart({token, pIId}) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/ShopCartDelete/$token/$pIId'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCart(token);
          return true;
        }
        else if(response.statusCode == 421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool?> getShopCartGuest() async{
    var deviceID = await _getDeviceId();
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/GuestShopCart/$deviceID"),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        try{
          if(jsonDecode(response.body)['status'].toString()==421.toString()){
            cartList.clear();
            cartList = [];
            editTransactionCartList();
            return true;
          }
        }catch(e){
        }
        cartList = jsonDecode(response.body);
        editTransactionCartList();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  addShopCartGuest({pIId, quantity}) async{
    var deviceID = await _getDeviceId();
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/GuestAddShopCart?deviceId=$deviceID&PIId=$pIId&QTY=$quantity'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCartGuest();
          return true;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  deleteShopCartGuest({pIId}) async{
    var deviceID = await _getDeviceId();
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/GuestCartDelete/$deviceID/$pIId'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getShopCartGuest();
          return true;
        }
        else if(response.statusCode == 421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  clearShopCartGuest({token}) async{
    var deviceID = await _getDeviceId();
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/GuestShopCartClear/$deviceID'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          //await getShopCartGuest();
          for(int i=0; i< cartList.length; i++){
            await addShopCart(token: token, pIId: cartList[i]['PIId'], quantity: cartList[i]['QTY']);
          }
          return true;
        }
        else if(response.statusCode == 421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool?> getWishlist(token) async{
    try{
      http.Response response = await http.get(
          Uri.parse("$_baseUrl/WishList/$token"),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        wishList = jsonDecode(response.body);
        editTransactionWishlist();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  addWishlist({token, productId}) async{
    if(guestType){
      MyWidget(context!).guestDialog();
      return;
    }
    try{
      http.Response response = await http.post(
        Uri.parse('$_baseUrl/AddWishList?token=$token&PROId=$productId'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getWishlist(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product already added!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  deleteWishlist({token, productId}) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/WishListDelete/$token/$productId'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getWishlist(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==421){
          flushBar(AppLocalizations.of(context!)!.translate('Product not found in wishlist!'));
          return false;
        }
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Product not found in wishlist!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  updateUserAddress({token, addressId, firstName, lastName, company, address1, address2, city, postCode, countryId, defaultAddress}) async{
    try{
      Map mapDate = {
        "token": token,
        "AddressId": addressId,
        "firstName": firstName,
        "lastName": lastName,
        "company": company,
        "address1": address1,
        "address2": address2,
        "city": city,
        "postCode": postCode,
        "countryId": countryId,
        "defultAddress": defaultAddress
      };
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/UpdateUserAddress?token=$token&AddressId=$addressId&firstName=$firstName&lastName=$lastName&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress'),
          //Uri.parse('$_baseUrl/Update_U_address?token=$token&addressId=$addressId&firstName=$firstName&lastName=$lastName&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress'),
          //Uri.parse("$_baseUrl/Update_User_Address?token=$token&addressId=$addressId?firstName=$firstName&lastName=$lastName&company=$company&address1=$address1&address2=$address2&city=$city&postCode=$postCode&countryId=$countryId&defultAddress=$defaultAddress"),
          //Uri.parse("$_baseUrl/Update_User_Address?"),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      print('Res: ------------------------');
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getUserAddress(token);
          return true;
        }
        else {
          flushBar(jsonDecode(response.body)['message']);
          //await getUserAddress(token);
          return false;
        }
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 423){
        flushBar(AppLocalizations.of(context!)!.translate('Your e-mail is invalid!'));
        return false;
      }
      else if(response.statusCode == 424){
        flushBar(AppLocalizations.of(context!)!.translate('This e-mail is already entered!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  deleteUserAddress({token, addressId, firstName, lastName, company, address1, address2, city, postCode, countryId, defaultAddress}) async{
    try{
      Map mapDate = {
        "token": token,
        "AddressId": addressId,
      };

      print("$_baseUrl/User_address_delete?token=$token&addressId=$addressId");
      http.Response response = await http.delete(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
          Uri.parse("$_baseUrl/User_address_delete/$token/$addressId"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode(mapDate),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      print(response.body);
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getUserAddress(token);
          return true;
        }
        else {
          flushBar(jsonDecode(response.body)['message']);
          //await getUserAddress(token);
          return false;
        }
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
      else if(response.statusCode == 421){
        flushBar(AppLocalizations.of(context!)!.translate('Address not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  createPaymentMethod({token, name, cardNum, securityCode, expDate, }) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/Create_Payment?token=$token&name=$name&cardNumber=$cardNum&securityCode=$securityCode&expirationDate=$expDate'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getPaymentMethod(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==420){
          flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
          return false;
        }
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  updatePaymentMethod({token, name, cardNum, securityCode, expDate, pcId}) async{
    try{
      http.Response response = await http.post(
          Uri.parse('$_baseUrl/UpdatePayment?token=$token&PCId=$pcId&name=$name&cardNumber=$num&securityCode=$securityCode&expirationDate=$expDate'),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      //print(response.body);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        if(jsonDecode(response.body)['status']==200){
          //flushBar(jsonDecode(response.body)['message']);
          await getPaymentMethod(token);
          return true;
        }
        else if(jsonDecode(response.body)['status']==420){
          flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
          return false;
        }
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
  }

  Future<bool?> getPaymentMethod(token) async{
    try{
      http.Response response = await http.get(
        //Uri.parse('$_baseUrl/api/Auth/Login?'),
        //Uri.parse("$_baseUrl/Products/$token"),
          Uri.parse("$_baseUrl/PaymentCards/$token"),
          //body: jsonEncode({"email": email, "password": password, "FBKey":fcmToken.toString()}),
          //body: jsonEncode({"email": email, "password": password}),
          headers: {
            //"Accept-Language": LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      //await Hive.initFlutter();
      //Hive.registerAdapter(TransactionAdapter());
      //await Hive.openBox<Transaction>('transactions');
      //print(email + ',' + password);
      //print(jsonDecode(response.body));
      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        paymentCard = jsonDecode(response.body);
        editTransactionPaymentCard();
        return true;
      }
      else if(response.statusCode == 404){
        flushBar(AppLocalizations.of(context!)!.translate('Variables not sent!'));
        return false;
      }
      else if(response.statusCode == 420){
        flushBar(AppLocalizations.of(context!)!.translate('User not found!'));
        return false;
      }
    }
    catch(e){
      flushBar(AppLocalizations.of(context!)!.translate('please! check your network connection'));
      return false;
      print(e);
    }
    return null;
  }

  flushBar(text){
    try{
      Flushbar(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context!).size.width/20, vertical: MediaQuery.of(context!).size.width/20*0),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context!).size.height / 30),
        icon: Icon(
          Icons.error_outline,
          size: MediaQuery.of(context!).size.height / 30,
          color: MyColors.white,
        ),
        duration: const Duration(seconds: 3),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context!).size.height / 30/2)),
        backgroundColor: Colors.grey.withOpacity(0.5),
        barBlur: 20,
        message: text,
        messageText: Text(text,
          style: const TextStyle(
            fontFamily: 'Gotham',
            color: MyColors.white,
          ),
        ),
        //flushbarStyle: FlushbarStyle.FLOATING,
        messageSize: MediaQuery.of(context!).size.width / 30,
      ).show(context!);
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> sendPushMessage(body, title, _token) async {
    if (_token == null || _token == 'lastName') {
      try{
        //_token = await myFirebase.getToken();
        print(_token);
        print(_token);
      }
      catch(e){
        print('Unable to send FCM message, no token exists.');
        return;
        print(e);
        flushBar(e.toString());
      }
    }
    String constructFCMPayload(String? token, _title, _body) {
      return jsonEncode({
        'to': token,
        'data': {
          //'to': token,
          //"registration_ids" : token,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'COMMENT',
          'via': 'FlutterFire Cloud Messaging!!!',
          //'count': _messageCount.toString(),
        },
        'notification': {
          'title': _title,
          'body': _body,
        },
      });
    }
    try {
      //var _serverKey = 'AAAAMwglvWs:APA91bHsPk8XkZsd4YE3mdQsGSJDPlwB_DwXt150mupjJ-CpujuI69ardOGDyM0sQ608LN5oxlS4DkIgloHg5MGGZkCepZudg2PfsfylJnbiPaern8MHCQG66B5XZhi9yomLwRJbz9jM';
      //var _serverKey = 'AAAAOPv0WzU:APA91bH_4SPyvOt7K3n2rGhl1v6DgCAogSL5hO6hiSkqQNV6Yqh77kNlGOc-AUwBgp4Avig-6xQp5vXiyJxPBEyg1SEqKSyXX5HbQJ8qG2cNNn0XHwGxVtOx31fK0OBK6xR_fjoF9ntn';
      var _serverKey = 'AAAAR-Z6wxU:APA91bHxD-k35HJkOZA0keidt5OiEIYIqQ1Nnp8BP4_H6SosKrY1lYf7yVQcks0UfyWWFoMnRv4t3VEllRRqDAsRHgT12jg4O6xKZCOqeYFkk7ECXBxNJE3yaSdKnWzlvXYc_U8Lpe69';
      var response = await http.post(
        //Uri.parse('https://api.rnfirebase.io/messaging/send'),
        //Uri.parse('https://fcm.googleapis.com/v1/projects/mr-services-15410/messages:send'),
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$_serverKey',
          'project_id':'308809483029',
        },
        body: constructFCMPayload(_token, title, body),
      );
      print('FCM request for device sent!');
      print(jsonEncode(response.body));
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Future readUserInfo(var token) async {
    try{
      print("flag1");
      var url = Uri.parse("$_baseUrl/User_info/$token?");
      //var url = Uri.parse("$_baseUrl/SignUp/SignUp_Read?filter=id~eq~'46438c59-63c6-47af-2cd3-08da1c725dd8'");
      //var url = Uri.parse("$_baseUrl/SignUp/SignUp_Read?");
      //var url = Uri.parse("$_baseUrl/SignUp/SignUp_ReadById");
      http.Response response = await http.get(
        url,
        //body: jsonEncode({"UserName": "email", "Password": "password", "FBKey":"fcmToken.toString()"}),
        headers: {
         // "Accept-Language": LocalizationService.getCurrentLocale().languageCode,
         // "Accept": "application/json",
         // "content-type": "application/json",
          "Authorization": token,
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print("flag2");
        //print(jsonDecode(response.body)['result'].length.toString());
        userInfo = jsonDecode(response.body);
        editTransactionUserInfo();
        print(userInfo);
        //nameController.text = userInfo['name'];
        //mobileController.text = userInfo['mobile']; //userInfo['mobile'];
        //cityController.text = userInfo['city']['name']; //userInfo['city'];
        return true;

        print("flag3");
      } else {
        print("flag4");
        print(response.statusCode);
        return false;
      }
      print("flag5");
      //await Future.delayed(Duration(seconds: 1));
    }catch(e){
      flushBar('check network connection');
      print('check network connection\n' + e.toString());
      return false;
    }
  }

  newPasswordVer(String newPassword, email, code) async{
    //curl -X POST "https://mr-service.online/Main/SignUp/ResetPassword?UserEmail=www.osh.themyth2%40gmail.com&code=160679&password=0938025347" -H "accept: */*"
    var apiUrl = Uri.parse('$_baseUrl/SignUp/ResetPassword?UserEmail=$email&code=$code&password=$newPassword');
    http.Response response = await http.post(apiUrl, headers: {
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      print("we're good");
      //userData = jsonDecode(response.body);
      if (jsonDecode(response.body)['errors'] == "") {
          //isLogIn = true;
          //token = jsonDecode(response.body)["content"]["Token"].toString();
          //updateUserInfo(userData["content"]["Id"]);
        /*Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Sign_in(true),),
              (Route<dynamic> route) => false,
        );*/
        return true;
        }
      else {
          //setState(() => chLogIn = false);
          flushBar(jsonDecode(response.body)['errors']);
          return false;
        }
    }
    else {
      print(response.statusCode);
      print('A network error occurred');
      return false;
    }

  }

  String getBase64FileExtension(String base64String) {
    switch (base64String.characters.first) {
      case '/':
        return 'jpeg';
      case 'i':
        return 'png';
      case 'R':
        return 'gif';
      case 'U':
        return 'webp';
      case 'J':
        return 'pdf';
      default:
        return 'unknown';
    }
  }

  changeLang(Function() _setState, int _lng) async {
    pleaseWait = true;
    _setState;
    await LocalizationService().changeLocale(_lng, context);
    pleaseWait = false;
    _setState;
  }

}