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
class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _messageController = TextEditingController();
  MyWidget? _m;

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
                          _m!.returnIcon(color: MyColors.white),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Help'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 30,
              child: Column(
                children: [
                  _dropDown(MediaQuery.of(context).size.width/1.2, curve/2),
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height/1.7,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2*0),
                    decoration: BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(curve/2))
                    ),
                    child: TextField(
                      maxLines: null,
                      //validator: requiredValidator,
                      //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.multiline,
                      controller: _messageController,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/22,
                          color: MyColors.gray,
                          fontFamily: 'SairaMedium'),
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(

                        border: InputBorder.none,
                        //labelText: titleText,
                        hintText: AppLocalizations.of(context)!.translate('Type your message'),
                        hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/25,
                            color: MyColors.bodyText1,
                            fontFamily: 'SairaLight'),
                        errorStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/2400,
                        ),
                      ),

                    ),
                  )

                ],


              ),
            ),
            Flexible(
              flex: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Search'), null, ()=> _search(), color: MyColors.mainColor),
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
      ],
    );
  }
  _edit(int index) {}

  _search() {

  }

  final List<String>  _type = <String> ['Type1', 'Type2', 'Type3'];
  var _proplemType = 'Problem Type';
  _dropDown(width, curve){
    if(_type.isEmpty) {
      return;
    } else{
      return Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.all(Radius.circular(curve))
        ),
        //width: width,
        //height: MediaQuery.of(context).size.width/6.5,
        child: Row(
          children: [
            Expanded(
                child: _m!.bodyText1(_proplemType, align: TextAlign.start,scale: 1.25, padding: 0.0),
            ),
            DropdownButton<String>(
              //key: _dropDownKey,
                underline: DropdownButtonHideUnderline(child: Container(),),
                icon: const Icon(Icons.arrow_forward_ios_outlined,),
                dropdownColor: MyColors.white.withOpacity(0.9),
                //value: 'Type1',
                items: _type.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/25,
                          color: MyColors.gray,
                          fontFamily: 'SairaMedium'),
                    ))).toList(),
                selectedItemBuilder: (BuildContext context){
                  return _type.map((e) => Text(e.toString())).toList();
                },
                onChanged: (chosen){
                  setState(() {
                    _proplemType = chosen.toString();
                    print(chosen.toString());
                  });
                }
            ),
          ],
        ),
      );
    }
    /*return
    Container(
      child: EnhancedDropDown.withData(
        dropdownLabelTitle: '',
        dataSource: citiesName,
        defaultOptionText: "Dawha",
        valueReturned: (chosen) {
          _stateController.text = chosen;
          var index = cities.indexWhere((element) => element['name']==chosen);
          cityId = cities[index]['id'];
          print(chosen);
        },

      ),
    );*/
  }

}
