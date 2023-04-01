import 'package:novel/api.dart';
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
class AddAddress extends StatefulWidget {
  Map lastAddress;
  AddAddress(this.lastAddress, {Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState(lastAddress);
}

class _AddAddressState extends State<AddAddress> {

  _AddAddressState(this.lastAddress);

  var _error = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text= userInfo['firstName']??'';
    _lastNameController.text= userInfo['lastName']??'';
    _phoneNumberController.text= userInfo['phone']??'';
    _cityController.addListener(() {setState((){});});
    _streetController.addListener(() {setState((){});});
    _nearController.addListener(() {setState((){});});
    if(lastAddress.isNotEmpty){
      _countryId = lastAddress['countryId'];
      _country = countries[countries.indexWhere((element) => element['countryId']==lastAddress['countryId'])]['countryName'];
      _cityController.text = lastAddress['city'];
      _streetController.text = lastAddress['address1'];
      _nearController.text = lastAddress['address2'];
    }
  }

  MyWidget? _m;
  Map lastAddress;
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _nearController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    return Container(
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
        resizeToAvoidBottomInset: true,
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
                      _m!.bodyText1(lastAddress.isEmpty?AppLocalizations.of(context)!.translate('New Address'):AppLocalizations.of(context)!.translate('Edit Address'), padding: 0.0, color: MyColors.white, scale: 1.2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 35,
          child: Container(
            color: MyColors.white,
            padding: EdgeInsets.all(curve),
            margin: EdgeInsets.only(top: curve, bottom: curve*2, left: curve, right: curve),
            child: ListView(
              children: [
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _firstNameController, AppLocalizations.of(context)!.translate('First Name'), Icons.person_outline, readOnly: true),
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _lastNameController, AppLocalizations.of(context)!.translate('Last Name'), Icons.person_outline, readOnly: true),
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _phoneNumberController, AppLocalizations.of(context)!.translate('Phone number'), Icons.phone_outlined, readOnly: true),
                SizedBox(height: MediaQuery.of(context).size.height/100,),
                _dropDown(),
                //_m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _countryController, AppLocalizations.of(context)!.translate('Country'), Icons.location_on_outlined),
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _cityController, AppLocalizations.of(context)!.translate('City'), Icons.location_on_outlined, error: _error),
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _streetController, AppLocalizations.of(context)!.translate('Street'), Icons.location_on_outlined, error: _error),
                _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _nearController, AppLocalizations.of(context)!.translate('Near'), Icons.location_on_outlined, error: _error),
                SizedBox(height: MediaQuery.of(context).size.height/100,),
                _m!.raisedButton(curve, MediaQuery.of(context).size.width, lastAddress.isEmpty? AppLocalizations.of(context)!.translate('Add'): AppLocalizations.of(context)!.translate('Save'), null, ()=>_addAddres(), color: MyColors.mainColor),
              ],
            ),

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
      ],
    );
  }

  _addAddres() async{
    if(_cityController.text.isEmpty || _streetController.text.isEmpty || _nearController.text.isEmpty || _countryId =='-1'){
      setState((){
        _error = true;
      });
      return;
    }
    setState((){
      pleaseWait = true;
    });
    var s = false;
    print(lastAddress.isEmpty.toString());
    if(lastAddress.isEmpty){
      s = await MyAPI(context: context).createUserAddress(token: token, firstName: _firstNameController.text, lastName: _lastNameController.text, city: _cityController.text, address1: _streetController.text, countryId: _countryId, address2: _nearController.text);
    }
    else{
      s = await MyAPI(context: context).updateUserAddress(token: token, addressId: lastAddress['AddressId'], firstName: _firstNameController.text, lastName: _lastNameController.text, city: _cityController.text, address1: _streetController.text, countryId: _countryId, address2: _nearController.text, postCode: lastAddress['postCode'], company: lastAddress['company'], defaultAddress: lastAddress['defultAddress']);
    }
    setState((){
      pleaseWait = false;
    });
    if(s){
      Navigator.of(context).pop();
    }

  }

  final List<String>  _countryName = <String> ['Type1', 'Type2', 'Type3'];
  var _country = 'country';
  var _countryId = '-1';

  _dropDown(){
    var curve = MediaQuery.of(context).size.height/100;
    _countryName.clear();
    for(int i = 0; i< countries.length; i++){
      _countryName.add(countries[i]['countryName']);
    }
      return Container(
        //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.all(Radius.circular(curve))
        ),
        //width: width,
        //height: MediaQuery.of(context).size.width/6.5,
        child: Column(
          children: [
            Stack(
              children: [
                _m!.bodyText1(_country, align: TextAlign.start,scale: 1.25, padding: 0.0),
                DropdownButton<String>(
                  //key: _dropDownKey,
                    underline: DropdownButtonHideUnderline(child: Container(),),
                    icon: const Icon(Icons.location_on_outlined,),
                    dropdownColor: MyColors.white.withOpacity(0.9),
                    //value: 'Type1',
                    items: _countryName.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.gray,
                              fontFamily: 'SairaMedium'),
                        ))).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return _countryName.map((e) => Text(e.toString())).toList();
                    },
                    onChanged: (chosen){
                      setState(() {
                        _country = chosen.toString();
                        _countryId = countries[countries.indexWhere((element) => _country == element['countryName'])]['countryId'];
                        print(chosen.toString());
                      });
                    }
                ),
              ],
            ),
            _m!.driver(color: _error && _countryId == '-1'?MyColors.red: Colors.grey),
          ],
        )
      );
  }

}
