import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:novel/screen/subbmitOrder.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../api.dart';
import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
import 'paymentMethodsScreen.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = userInfo['email'];
    _phoneController.text = userInfo['phone']??'';
    _genderController.text = userInfo['gender']??'';
    if(paymentCard.isNotEmpty){
      _cardNumController.text = paymentCard[0]['cardNumber'];
      _cardDateController.text = paymentCard[0]['expirationDate'];
    }
    _nameController.text = userInfo['firstName'];
    _namelastController.text = userInfo['lastName'];
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _namelastController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _cardNumController = new TextEditingController();
  TextEditingController _cardDateController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _sizeTopController = new TextEditingController();
  TextEditingController _sizeBottomController = new TextEditingController();
  TextEditingController _sizeShoseController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  var total = 119.99*3;
  List myCartList = [{'quantity': 1}, {'quantity': 2}, {'quantity': 1}, {'quantity': 3}];

  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.metal,
          //MyColors.white,
          MyColors.metal,
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

  initScreen(BuildContext context) {
    var curve = MediaQuery
        .of(context)
        .size
        .width / 20;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      //alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height/4/2,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/40),
                      color: MyColors.mainColor,
                      child: Row(
                        children: [
                          _m!.returnIcon(color: MyColors.white,),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Edit Profile'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 26,
              child: Container(
                decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.all(Radius.circular(curve)),
                    color: MyColors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _m!.headText(AppLocalizations.of(context)!.translate('Account Info')),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Save'), color: MyColors.novelBlue, scale: 1.1),
                            onTap: ()=> _changeName(),
                          ),
                        ],
                      ),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _nameController, AppLocalizations.of(context)!.translate('Name'), null, paddV: curve/4*0),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _namelastController, AppLocalizations.of(context)!.translate('Last Name'), null, paddV: curve/4*0),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _emailController, AppLocalizations.of(context)!.translate('Email'), null, paddV: curve/4*0, readOnly: true),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _phoneController, AppLocalizations.of(context)!.translate('Phone'), null, paddV: curve/4*0, readOnly: true),
                      SizedBox(height: curve/2,),
                      Row(
                        children: [
                          _m!.headText(AppLocalizations.of(context)!.translate('Card Info')),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Change'), color: MyColors.novelBlue, scale: 1.1),
                            onTap: ()=> _changeCard(),
                          ),
                        ],
                      ),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _cardNumController, AppLocalizations.of(context)!.translate('Card Number'), null, paddV: curve/4*0, readOnly: true),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _cardDateController, AppLocalizations.of(context)!.translate('Exp Date'), null, paddV: curve/4*0, readOnly: true),
                      //_m!.textFiled(curve/2, MyColors.metal, MyColors.black, _ageController, AppLocalizations.of(context)!.translate('Age range'), null, paddV: curve/4*0, readOnly: true),
                      SizedBox(height: curve/2,),
                      _m!.headText(AppLocalizations.of(context)!.translate('Gender')),
                      _m!.textFiled(curve/2, MyColors.metal, MyColors.black, _genderController, AppLocalizations.of(context)!.translate('Gender'), null, paddV: curve/4*0, readOnly: true),
                      SizedBox(height: curve/2,),
                      /*_m!.headText(AppLocalizations.of(context)!.translate('My Size')),
                  _m!.textFiled(curve/2, MyColors.metal, MyColors.bodyText1, _sizeTopController, AppLocalizations.of(context)!.translate('Top:'), null, height: MediaQuery.of(context).size.width/4.7, paddV: 0.0),
                  _m!.textFiled(curve/2, MyColors.metal, MyColors.bodyText1, _sizeBottomController, AppLocalizations.of(context)!.translate('Bottom:'), null, height: MediaQuery.of(context).size.width/4.7, paddV: 0.0),
                  _m!.textFiled(curve/2, MyColors.metal, MyColors.bodyText1, _sizeShoseController, AppLocalizations.of(context)!.translate('Shoes:'), null, height: MediaQuery.of(context).size.width/4.7, paddV: 0.0),*/
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.all(Radius.circular(curve)),
                    color: MyColors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20*0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _m!.headText(AppLocalizations.of(context)!.translate('Notifications And Email'),align: TextAlign.start),
                          ),
                          ToggleSwitch(
                            minWidth: MediaQuery.of(context).size.width/10,
                            cornerRadius: MediaQuery.of(context).size.width/7,
                            activeBgColors: [[MyColors.novelBlue], [MyColors.novelBlue]],
                            activeFgColor: Colors.white,
                            inactiveBgColor: MyColors.orange1,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: notificationAndEmail? 0:1,
                            totalSwitches: 2,
                            labels: ['On', 'Of'],
                            radiusStyle: true,
                            onToggle: (index) {
                              print('switched to: $index');
                              setState((){
                                notificationAndEmail = !notificationAndEmail;
                                editTransactionNoteficationAndEmail();
                              });
                            },
                          ),

                        ],
                      ),
                      _m!.driver(),
                      _m!.bodyText1(AppLocalizations.of(context)!.translate('Subscribe to our newsletter to get latest offers and updates'),align: TextAlign.start, padding: 0.0),
                    ],
                  ),
                ),
              ),

            ),
            SizedBox(height: MediaQuery.of(context).size.height/80,)
          ],
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
  _submitOrder() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubbmitOrder()));
  }

  _changeName() async{
    setState(() {
      pleaseWait = true;
    });
    bool s = await MyAPI(context:context).updateUser(token, _nameController.text, _namelastController.text, _phoneController.text);
    if(s){
      _nameController.text = userInfo['firstName'];
      _namelastController.text = userInfo['lastName'];
    }
    setState(() {
      pleaseWait = false;
    });
  }

  _changeCard() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> PaymentMethods()));
  }
}
