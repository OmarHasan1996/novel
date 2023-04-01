import 'package:novel/screen/mainScreen.dart';
import 'package:novel/screen/signInScreen.dart';
import 'package:novel/screen/signUpScreen.dart';

import '../api.dart';
import '../color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
class LetsGoScreen extends StatefulWidget {
  @override
  _LetsGoScreenState createState() => _LetsGoScreenState();
}

class _LetsGoScreenState extends State<LetsGoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  MyWidget? _m;

  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/images/login_background.png"),
          fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: MyColors.trans,
        body: initScreen(context),
      ),
    );
  }

  initScreen(BuildContext context) {
    var curve = MediaQuery.of(context).size.width/20;
    return Stack(
      children: [
        Column(
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  //alignment: Alignment.bottomCenter,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     /* Container(
                        height: MediaQuery.of(context).size.height/9,
                        width: MediaQuery.of(context).size.width,
                        color: MyColors.orange2,
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8, vertical: MediaQuery.of(context).size.height/10),
                        child: _m!.comimaniaLogo(isWhite: true),
                      ),
                      Image.asset('assets/images/splash_background.png', width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.2,
                        //height: MediaQuery.of(context).size.width,
                      ),*/
                    ]),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7, vertical: MediaQuery.of(context).size.height/13),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _m!.raisedButton(curve, MediaQuery.of(context).size.width*43/140, AppLocalizations.of(context)!.translate('SignUp'), null, ()=> signUp()),
                          SizedBox(width: MediaQuery.of(context).size.width/10),
                          _m!.raisedButton(curve, MediaQuery.of(context).size.width/140*43, AppLocalizations.of(context)!.translate('Login'), null, ()=> logIn()),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/20),
                      _m!.raisedButton(curve, MediaQuery.of(context).size.width/2.5, AppLocalizations.of(context)!.translate('Continue As Guest'), null, ()=> continueAsGuest(), color: MyColors.white, height: MediaQuery.of(context).size.height/25)
                    ],
                  ),
                ),
              ),
            ]
        ),
        Align(
          alignment: Alignment.center,
          child: pleaseWait?
          _m!.progress()
              :
          const SizedBox(),
        ),

      ],
    )
    ;
    /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height/20 + MediaQuery.of(context).size.width/12,),
              _m!.headText(AppLocalizations.of(context)!.translate('name'), paddingV: MediaQuery.of(context).size.height/40),

            ],
          ),*/
  }

  signUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(),
        ));
  }

  continueAsGuest() async{
    guestType = true;
    editTransactionGuestType();

    setState((){
      pleaseWait = true;
    });
    //bool s = await MyAPI(context: context).login(_emailController.text, _passwordController.text);
    await getFromApi(true, context);
    //await MyAPI(context: context).getCurrency(token);
    //await MyAPI(context: context).getPaymentMethod(token);
    //s = await MyAPI(context: context).getCategories(token);
    setState((){
      pleaseWait = false;
    });
    //_save();
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
  }

  logIn() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignINScreen(),
        ));
  }
}
