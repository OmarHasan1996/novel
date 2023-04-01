import 'package:novel/screen/checkoutScreen.dart';
import 'package:novel/screen/countryAndLang.dart';
import 'package:novel/screen/helpScreen.dart';
import 'package:novel/screen/ordersScreen.dart';
import 'package:novel/screen/paymentMethodsScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signInScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'CurrencyScreen.dart';
import 'addressScreen.dart';
import 'editeProfile.dart';
import 'mainScreen.dart';
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _searchController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  var total = 119.99*3;
  List myWishlistList = [{'sale': 0}, {'sale': 20}, {'sale': 40}, {'sale': 0}, {'sale': 30}];

  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.metal,
          MyColors.white,
          MyColors.metal,
        ],
          transform: GradientRotation(3.14 / 4),),
      ),
      child: Scaffold(
        backgroundColor: MyColors.metal,
        body: initScreen(context),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  initScreen(BuildContext context) {
    var curve = MediaQuery
        .of(context)
        .size
        .height / 70;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 19,
              child:  Container(
                      //alignment: Alignment.topCenter,
                      //height: MediaQuery.of(context).size.height/40*19,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/40*0),
                      color: MyColors.mainColor,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/40,),
                          _m!.returnIcon(color: MyColors.white, click: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainScreen())),),
                          SizedBox(height: MediaQuery.of(context).size.height/60,),
                          _m!.comimaniaLogo(color: true),
                          SizedBox(height: MediaQuery.of(context).size.height/60,),
                          _m!.raisedButton(curve, MediaQuery.of(context).size.width/5, AppLocalizations.of(context)!.translate('Edit Profile'), null, ()=> _editProfile(), height: MediaQuery.of(context).size.height/20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                            margin: EdgeInsets.symmetric(horizontal: curve*0, vertical: curve),
                            decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.all(Radius.circular(curve))
                            ),
                            child: Column(
                              children: [
                                _rowList(Icons.car_crash, AppLocalizations.of(context)!.translate('Orders'), () => _orders(), color: MyColors.mainColor),
                                _m!.driver(padV: curve),
                                _rowList(Icons.payment_outlined, AppLocalizations.of(context)!.translate('Payment Methods'), () => _paymentMethod(), color: MyColors.mainColor),
                              ],
                            ),
                          ),
                          Expanded(child: Center()),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                            decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.only(topLeft:Radius.circular(curve), topRight: Radius.circular(curve))
                            ),
                            child: Column(
                              children: [
                                _rowList(Icons.language_outlined, AppLocalizations.of(context)!.translate('Country And Language'), () => _countryAndLang()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            Flexible(
              flex: 17,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/40*0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve*0),
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(curve), bottomRight: Radius.circular(curve))
                      ),
                      child: Column(
                        children: [
                          _m!.driver(padV: 0.0),
                          SizedBox(height: curve),
                          _rowList(Icons.currency_exchange_outlined, AppLocalizations.of(context)!.translate('Currency'), () => _currency()),
                          _m!.driver(padV: curve),
                          _rowList(Icons.location_on_outlined, AppLocalizations.of(context)!.translate('Address'), () => _address()),
                          _m!.driver(padV: curve),
                          _rowList(Icons.help_outline, AppLocalizations.of(context)!.translate('Help'), () => _help()),
                          SizedBox(height: curve),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                      margin: EdgeInsets.symmetric(horizontal: curve*0, vertical: curve*2),
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(curve))
                      ),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Expanded(child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Logout'), align: TextAlign.start, scale: 1.4, color: MyColors.novelBlue)),
                            Icon(Icons.arrow_forward_ios_outlined, color: MyColors.bodyText1,),
                          ],
                        ),
                        onTap: ()=> _logout(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: _m!.bottomContainer(4, curve*0, bottomConRati: 0.1),
            ),
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

  _addToCart(int index) {

  }

  _rowList(icon1, text, Function() click,{color}){
    color??= MyColors.bodyText1;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon1, color: color,),
          Expanded(child: _m!.bodyText1(text, align: TextAlign.start, )),
          Icon(Icons.arrow_forward_ios_outlined, color: MyColors.bodyText1,),
        ],
      ),
      onTap: ()=> click(),
    );
  }

  _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> EditProfile()),
    );

  }

  _logout() async{
    //MyAPI(context: context).sendPushMessage('body', 'title', null);
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('logIn', false);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> SignINScreen()), (route) => false);
  }

  _address() async{
    setState((){
      pleaseWait = true;
    });

    await MyAPI(context: context).getUserCountries(userData['token']);
    await MyAPI(context: context).getUserAddress(userData['token']);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Address()));
    setState((){
      pleaseWait = false;
    });
  }

  _help() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HelpScreen()));
  }

  _orders() async{
    setState(() {
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).getOrders();
    setState(() {
      pleaseWait = false;
    });
    if(s) Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrdersScreen()));
  }

  _paymentMethod() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PaymentMethods()));
  }

  _countryAndLang() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CountryAndLanguage()));
  }

  _currency() {
    if(currency.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CurrencyScreen()));
  }
}
