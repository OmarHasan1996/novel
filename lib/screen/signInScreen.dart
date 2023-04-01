import 'package:novel/api.dart';
import 'package:novel/screen/mainScreen.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
class SignINScreen extends StatefulWidget {
  const SignINScreen({Key? key}) : super(key: key);

  @override
  State<SignINScreen> createState() => _SignINScreenState();
}

class _SignINScreenState extends State<SignINScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    _emailController.addListener(() {setState((){});});
    _passwordController.addListener(() {setState((){});});
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  bool _error = false;

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
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  var _password = true;

  initScreen(BuildContext context) {
    var curve = MediaQuery.of(context).size.width/20;
    return Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: MediaQuery.of(context).size.height/60),
            child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _m!.returnIcon(),
                      _m!.bodyText1(AppLocalizations.of(context)!.translate('Login to your account'), color: MyColors.mainColor, scale: 1.8, padV: MediaQuery.of(context).size.height/50),
                      _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _emailController, AppLocalizations.of(context)!.translate('E-mail'), Icons.email_outlined, error: _error),
                      _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordController, AppLocalizations.of(context)!.translate('Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), error: _error),
                      SizedBox(height: MediaQuery.of(context).size.height/20,),
                      _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Login'), null, ()=> _logIn(), color: MyColors.mainColor),
                      GestureDetector(
                        onTap: ()=> _forgetPass(),
                        child: _m!.headText(AppLocalizations.of(context)!.translate('Forgot your password ?'),color: MyColors.novelBlue, scale: 0.8, paddingV: MediaQuery.of(context).size.height/60),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      _m!.orDriver(),
                    ],
                  )
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7*0, vertical: MediaQuery.of(context).size.height/30),
                  child: SingleChildScrollView(
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
                        //SizedBox(height: MediaQuery.of(context).size.height/50),
                        _m!.bodyText1(AppLocalizations.of(context)!.translate('New user?'), padV: MediaQuery.of(context).size.height/60*0),
                        GestureDetector(
                          onTap: ()=> _signUp(),
                          child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Signup'), color: MyColors.novelBlue, scale: 1.2),
                        ),
                        //_m!.raisedButton(curve, MediaQuery.of(context).size.width/2, AppLocalizations.of(context)!.translate('Continue As Guest'), null, ()=> continueAsGuest(), color: MyColors.yelow, height: MediaQuery.of(context).size.height/20)
                      ],
                    ),
                  ),
                ),
              ),
            ]
        ),),
          Align(
            alignment: Alignment.center,
            child: pleaseWait?
            _m!.progress()
                :
            const SizedBox(),
          ),
        ]
    );
  }

  void _afterLayout(Duration timeStamp) {
    _read();
  }

  signUp() {

  }

  continueAsGuest() {}

  _showPassword() {
    setState(() {
      _password = !_password;
    });
  }

  _logIn() async{
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      setState((){
        _error = true;
      });
      return;
    }
    setState((){
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).login(_emailController.text, _passwordController.text);
    if(s && guestType){
      await MyAPI(context: context).clearShopCartGuest();
    }
    await getFromApi(false, context);
    setState((){
      pleaseWait = false;
    });
    if(!s) return;
    guestType = false;
    editTransactionGuestType();
    _save();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen()
        ),
          (Route<dynamic> route) => false,
    );
  }

  _forgetPass() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(),
        ));
  }

  _appleLogIn() {}

  _signUp() {
    /*if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      setState((){
        _error = true;
      });
      return;
    }*/
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(),
        ));
  }

  _save() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', _emailController.text);
    sharedPreferences.setString('password', _passwordController.text);
    sharedPreferences.setString('token', token);
    sharedPreferences.setBool('logIn', true);
//    sharedPreferences.setString('name', _fullNameController.text);
//    sharedPreferences.setString('phone', _mobileController.text);
  }

  _read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _emailController.text = sharedPreferences.getString('email')!;
    //_passwordController.text = sharedPreferences.getString('password')!;
  //  _fullNameController.text = sharedPreferences.getString('name')!;
  //  _mobileController.text = sharedPreferences.getString('phone')!;

  }

  _facebookLogIn() async{
    await MyAPI(context: context).faceBookLogIn(()=>_setState());
  }

  _googleLogIn() async{
    await MyAPI(context: context).googleLogIn(()=>_setState());
  }

  _setState(){
    setState(() {
    });
  }

}

