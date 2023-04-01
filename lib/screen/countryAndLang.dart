
import 'package:novel/api.dart';

import '../localization_service.dart';
import '../color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class CountryAndLanguage extends StatefulWidget {
  const CountryAndLanguage({Key? key}) : super(key: key);

  @override
  State<CountryAndLanguage> createState() => _CountryAndLanguageState();
}

class _CountryAndLanguageState extends State<CountryAndLanguage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    langNum = lng;
  }

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;

  var langNum = 1;
  var countryNum = 1;
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: MyColors.novelBlue,
                      child: Row(
                        children: [
                          _m!.returnIcon(color: MyColors.white,),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Country And Language'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 30,
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
                      _m!.headText(AppLocalizations.of(context)!.translate('Select Your Language')),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _selectContainer(
                                _m!.bodyText1(AppLocalizations.of(context)!.translate('English'), color:  langNum == 0? MyColors.mainColor: MyColors.bodyText1), langNum == 0? true: false
                                , ()=>_langNum(0), paddH: 0.0
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width/20,),
                          Expanded(
                            flex: 1,
                            child: _selectContainer(
                                _m!.bodyText1(AppLocalizations.of(context)!.translate('Franc'), color:  langNum == 1? MyColors.mainColor: MyColors.bodyText1), langNum == 1? true: false
                                , ()=>_langNum(1), paddH: 0.0
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width/20,),
                          Expanded(
                            flex: 1,
                            child: _selectContainer(
                                _m!.bodyText1(AppLocalizations.of(context)!.translate('Arabic'), color:  langNum == 2? MyColors.mainColor: MyColors.bodyText1), langNum == 2? true: false
                                , ()=>_langNum(2), paddH: 0.0
                            ),
                          ),
                        ],
                      ),
                      _m!.headText(AppLocalizations.of(context)!.translate('Select Your Country')),
                      _selectContainer(
                          _rowCountry('assets/images/saudi_Arabia.png', AppLocalizations.of(context)!.translate('Saudi Arabia'), countryNum == 1? true: false),
                          countryNum == 1? true: false
                          , ()=>_countryNum(1)
                      ),
                      _selectContainer(
                          _rowCountry('assets/images/emirates.png', AppLocalizations.of(context)!.translate('United Arab Emirates'), countryNum == 2? true: false),
                          countryNum == 2? true: false
                          , ()=>_countryNum(2)
                      ),
                      _selectContainer(
                          _rowCountry('assets/images/kuwait.png', AppLocalizations.of(context)!.translate('Kuwait'), countryNum == 3? true: false),
                          countryNum == 3? true: false
                          , ()=>_countryNum(3)
                      ),
                      _selectContainer(
                          _rowCountry('assets/images/egypt.png', AppLocalizations.of(context)!.translate('Egypt'), countryNum == 4? true: false),
                          countryNum == 4? true: false
                          , ()=>_countryNum(4)
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Apply'), null, ()=> _apply()),
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

  _langNum(num){
    setState((){
      langNum = num;

    });
  }
  _countryNum(num){
    setState((){
      countryNum = num;
    });
  }

  _selectContainer(child, select, Function() click, {paddH}){
    paddH??=MediaQuery.of(context).size.width/30;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: select? MyColors.metal: MyColors.white,
            border: Border.all(color: MyColors.card),
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/30))
        ),
        child: child,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/30, horizontal: paddH),
        margin: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.width/30/2),
      ),
      onTap: ()=> click(),
    );
  }

  _rowCountry(assets, text, select){
    return Row(
      children: [
        Image.asset(assets),
        //SvgPicture.asset('assets/images/kuwait.svg'),
        Expanded(child: _m!.bodyText1(text, align: TextAlign.start, color: select? MyColors.mainColor: MyColors.bodyText1)),
        select? SvgPicture.asset('assets/images/check.svg'): SizedBox(),
      ],
    );
  }

  _apply() async{
    setState((){
      pleaseWait = true;
    });
    lng = langNum;
    await MyAPI(context: context).changeLang(() => null, lng);
    setState((){
      pleaseWait = false;
    });
  }
}
