import 'package:novel/screen/mainScreen.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/userPersonalInfo.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'orderInformationScreen.dart';
class SubbmitOrder extends StatefulWidget {
  const SubbmitOrder({Key? key}) : super(key: key);

  @override
  State<SubbmitOrder> createState() => _SubbmitOrderState();
}

class _SubbmitOrderState extends State<SubbmitOrder> {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: MediaQuery.of(context).size.height/40),
      child: Column(
          children: [
            Flexible(
                flex: 3,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //_m!.returnIcon(),
                    SizedBox(height: MediaQuery.of(context).size.height/25,),
                    SvgPicture.asset('assets/images/sub_order.svg', height: MediaQuery.of(context).size.width/1.7,),
                    SizedBox(height: MediaQuery.of(context).size.height/60,),
                    _m!.bodyText1(AppLocalizations.of(context)!.translate('Your order has been submitted'), scale: 2.5, color: MyColors.black, padding: 0.0),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    _m!.bodyText1(AppLocalizations.of(context)!.translate('Order Number') + '\n' + lastOrderCheckout['OrderNumber'], scale: 1.3),
                    //SizedBox(height: MediaQuery.of(context).size.height/10,),
                    //_m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Sign up'), null, ()=> signUp(), color: MyColors.mainColor),
                    //SizedBox(height: MediaQuery.of(context).size.height/10,),
                    //_m!.orDriver(),
                  ],
                )
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7*0, vertical: MediaQuery.of(context).size.height/30),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/30),
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Track Order'), null, ()=> _trackOrder(), color: MyColors.mainColor),
                    GestureDetector(
                      child: _m!.headText(AppLocalizations.of(context)!.translate('Back TO Home'), color: MyColors.novelBlue, paddingV: MediaQuery.of(context).size.height/60),
                      onTap: ()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MainScreen()), (route) => false),
                    )
                    //_m!.bodyText1(AppLocalizations.of(context)!.translate('New user?'), padV: MediaQuery.of(context).size.height/60*0),
                    //_m!.raisedButton(curve, MediaQuery.of(context).size.width/2, AppLocalizations.of(context)!.translate('Continue As Guest'), null, ()=> continueAsGuest(), color: MyColors.yelow, height: MediaQuery.of(context).size.height/20)
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  _trackOrder() {
    print('fdsfdsfsdfds');
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderInformation(ordersList.length-1))).then((value) => setState((){}));
  }

}

