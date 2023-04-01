import 'package:novel/api.dart';
import 'package:novel/screen/addAddressScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:novel/screen/subbmitOrder.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(myAddress.isNotEmpty&& selectedAddress == null) selectedAddress = 0;
  }

  MyWidget? _m;
  //List myAddress = [{'sale': 0}, {'sale': 20}, {'sale': 40}];

  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    return
      Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.metal,
          MyColors.metal,
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
                      _m!.bodyText1(AppLocalizations.of(context)!.translate('Address'), padding: 0.0, color: MyColors.white, scale: 1.2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 30,
          child: myAddress.isEmpty? _m!.empty(): ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: myAddress.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: _m!.cardAddress(height: MediaQuery.of(context).size.width/2.5, name: myAddress[index]['firstName']+ ' ' +myAddress[index]['lastName'], mobile: userInfo['phone'],
                    location: 'ST (${myAddress[index]['address1']}), CT (${myAddress[index]['address2']}), AVE (${myAddress[index]['city']}), BLVD (${countries[countries.indexWhere((element) => element['countryId']==myAddress[index]['countryId'])]['countryName']}).',
                    delete: ()=> _delete(index),
                    edit: ()=> _edit(index),
                    selected: selectedAddress == index? true:false
                ),
                onTap: ()=> setState(() {
                  selectedAddress = index;
                  editTransactionSelectedAddress();
                }),
              );
            },
          ),
        ),
        Flexible(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Add New Address'), null, ()=> _addAddres(), color: MyColors.mainColor),
            ],
            //color: MyColors.white,
            //width: MediaQuery.of(context).size.width,
          ),
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
      ]
    );
  }
  _edit(int index) async{
    setState((){
      pleaseWait = true;
    });
    //await MyAPI(context: context).getUserCountries(userData['token']);

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddAddress(myAddress[index]))).then((value) => setState((){}));

    setState((){
      pleaseWait = false;
    });
  }

  _delete(int index) async{
    setState((){
      pleaseWait = true;
    });
    await MyAPI(context: context).deleteUserAddress(token: token, addressId: myAddress[index]['AddressId']);
    setState((){
      pleaseWait = false;
    });
  }

  _addAddres() async{
    setState((){
      pleaseWait = true;
    });
    //await MyAPI(context: context).getUserCountries(userData['token']);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddAddress({}))).then((value) => setState((){}));
    setState((){
      pleaseWait = false;
    });
  }
}
