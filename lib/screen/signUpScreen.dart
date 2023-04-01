import 'package:novel/api.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/userPersonalInfo.dart';
import 'package:novel/screen/verification.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;

  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.topGradiant,
          MyColors.white,
          MyColors.topGradiant,
        ],
          transform: GradientRotation(3.14 / 4),),
      ),
      child: Scaffold(
        backgroundColor: MyColors.trans,
        body: initScreen(context),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  var _password = true;

  initScreen(BuildContext context) {
    var curve = MediaQuery.of(context).size.width/20;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: MediaQuery.of(context).size.height/40),
          child: Column(
              children: [
                Flexible(
                    flex: 3,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _m!.returnIcon(),
                        SizedBox(height: MediaQuery.of(context).size.height/10,),
                        /*_m!.comimaniaLogo(),*/
                        SizedBox(height: MediaQuery.of(context).size.height/10,),
                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Sign up'), null, ()=> signUp(), color: MyColors.mainColor),
                        SizedBox(height: MediaQuery.of(context).size.height/10,),
                        _m!.orDriver(),
                      ],
                    )
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7*0, vertical: MediaQuery.of(context).size.height/30),
                    child: Column(
                      children: [
                        _m!.bodyText1(AppLocalizations.of(context)!.translate('Login Via')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Image.asset('assets/images/facebook.png', height: MediaQuery.of(context).size.width/6,),
                              onTap: ()=> _facebookLogIn(),
                            ),
                            GestureDetector(
                              child: Image.asset('assets/images/apple.png', height: MediaQuery.of(context).size.width/6,),
                              onTap: ()=> _appleLogIn(),
                            ),
                            GestureDetector(
                              child: Image.asset('assets/images/google.png', height: MediaQuery.of(context).size.width/6,),
                              onTap: ()=> _googleLogIn(),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/30),
                        //_m!.bodyText1(AppLocalizations.of(context)!.translate('New user?'), padV: MediaQuery.of(context).size.height/60*0),
                        //_m!.raisedButton(curve, MediaQuery.of(context).size.width/2, AppLocalizations.of(context)!.translate('Continue As Guest'), null, ()=> continueAsGuest(), color: MyColors.yelow, height: MediaQuery.of(context).size.height/20)
                      ],
                    ),
                  ),
                ),
              ]
          ),
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
  }

  signUp() {
    /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Verification(email: 'Email', value: 'userId', password: 'Password', verCode: 'confirmcode',),
        )
    );*/
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPersonalInfo(),
        ));

  }

  _facebookLogIn() async{
    await MyAPI(context: context).faceBookLogIn(()=>_setState());
  }

  _googleLogIn() async{
    setState(() {
      pleaseWait = true;

    });
    await MyAPI(context: context).googleLogIn(()=>_setState());
    setState(() {
      pleaseWait = false;

    });
  }

  _appleLogIn() {}

  _setState(){
    setState(() {

    });
  }
}

