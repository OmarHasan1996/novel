import 'package:novel/api.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'verification.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.addListener(() {setState(() {});});
    _passwordController.addListener(() {setState(() {});});
    _passwordRepeatController.addListener(() {setState(() {});});
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordRepeatController = new TextEditingController();
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: MediaQuery.of(context).size.height/40),
      child: Stack(
        children: [
          Column(
          children: [
            Flexible(
      flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _m!.returnIcon(),
              _m!.bodyText1(AppLocalizations.of(context)!.translate('Reset Password '), color: MyColors.mainColor, scale: 1.9, padV: MediaQuery.of(context).size.height/40),
              _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _emailController, AppLocalizations.of(context)!.translate('E-mail'), Icons.email_outlined, error: _error),
              _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordController, AppLocalizations.of(context)!.translate('Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), error: _error),
              _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordRepeatController, AppLocalizations.of(context)!.translate('Repeat Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), error: _error, val: _passwordController.text),
              SizedBox(height: MediaQuery.of(context).size.height/20,),
              _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Reset Password '), null, ()=> _resetPassword(), color: MyColors.mainColor),
              SizedBox(height: MediaQuery.of(context).size.height/25,),
            ],
          )
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
      ))
      ;
  }

  _showPassword() {
    setState(() {
      _password = !_password;
    });
  }

  _resetPassword() async{
    setState(() {
      _error = true;
    });
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      return;
    }else if(_passwordRepeatController.text != _passwordController.text){
      return;
    }
    setState(() {
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).forgetPassword(_emailController.text);
    setState(() {
      pleaseWait = false;
    });
    if(s){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(email: _emailController.text, value: userData['userId'], password: _passwordController.text, verCode: userData['confirmcode'],),
          )
      );

    }

  }

}

