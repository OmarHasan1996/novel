import 'package:novel/api.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
//import 'package:flutter_holo_date_picker/date_picker.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'verification.dart';

class ConfirmPassword extends StatefulWidget {
  var newUser;
  ConfirmPassword(this.newUser, {Key? key}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState(newUser);
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  var newUser;

  _ConfirmPasswordState(this.newUser);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController.text = newUser['Password'];
    _passwordConfirmController.addListener(() { setState((){

    });});
  }

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController = new TextEditingController();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _m!.returnIcon(),
              SizedBox(height: MediaQuery.of(context).size.height/25,),
              //_m!.comimaniaLogo(),
              SizedBox(height: MediaQuery.of(context).size.height/25,),
              _m!.bodyText1(AppLocalizations.of(context)!.translate('Confirm password'), color: MyColors.mainColor, scale: 1.2, padV: MediaQuery.of(context).size.height/40*0, align: TextAlign.start, padding: 0.0),
              Expanded(
                  flex: 1,
                  child:SingleChildScrollView(
                    child: Column(
                      children: [
                        _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordController, AppLocalizations.of(context)!.translate('Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), readOnly: true),
                        _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordConfirmController, AppLocalizations.of(context)!.translate('Repeat Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), error: true, val: _passwordController.text),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                      ],
                    ),
                  )
              ),
              MediaQuery.of(context).viewInsets.bottom == 0 ?
              _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Signup'), null, ()=> _signUp(), color: MyColors.mainColor):
              SizedBox(height: MediaQuery.of(context).size.height/100*0,),
              //SizedBox(height: MediaQuery.of(context).size.height/10,),
              //_m!.orDriver(),
            ],
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
    );
  }

  _showPassword() {
    setState(() {
      _password = !_password;
    });
  }

  var _gender = 0;

  _signUp() async{
    /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Verification(email: newUser['Email'], value: 60, password: newUser['Password'], verCode: "305390",),
        )
    );return;*/
    if(_passwordController.text!= _passwordConfirmController.text){
      return;
    }
    setState((){
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).register( newUser['FirstName'], newUser['LastName'], newUser['Phone'], newUser['Email'], newUser['Password'], newUser['Date'], newUser['gender']);
    if(s){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(email: newUser['Email'], value: userData['userId'], password: '', verCode: userData['confirmcode'],),
          )
      );
    }
    setState((){
      pleaseWait = false;
    });
  }

}

