import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../MyWidget.dart';
import '../api.dart';
import '../color/MyColors.dart';
import '../const.dart';
import '../localizations.dart';
class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyNum = currency.indexWhere((element) => currencyValue == element);
  }

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;

 // var langNum = 1;
  var currencyNum = 1;
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
                      color: MyColors.mainColor,
                      child: Row(
                        children: [
                          _m!.returnIcon(color: MyColors.white,),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Currency'), padding: 0.0, color: MyColors.white, scale: 1.2),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _m!.headText(AppLocalizations.of(context)!.translate('Choose the currency'), paddingV: MediaQuery.of(context).size.width/50),
                      Container(
                        height: MediaQuery.of(context).size.height/2,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0.0),
                            //scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: currency.length,
                            itemBuilder: (BuildContext context, int i) {
                              return _selectContainer(
                                  _rowCurrency(currency[i]['CurMark'], currency[i]['CurName'], currencyNum == i? true: false),
                                  currencyNum == i? true: false
                                  , ()=> _countryNum(i)
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ),
            Flexible(
              flex: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Apply'), null, ()=> _apply(), color: MyColors.mainColor),
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

  _countryNum(num){
    setState((){
      currencyNum = num;
    });
  }

  _selectContainer(child, select, Function() click, {paddH}){
    paddH??=MediaQuery.of(context).size.width/25;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: select? MyColors.metal: MyColors.white,
            border: Border.all(color: MyColors.card),
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/30))
        ),
        child: child,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/300, horizontal: paddH),
        margin: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.width/30),
      ),
      onTap: ()=> click(),
    );
  }

  _rowCurrency(symbol, text, select){
    return
      Row(
      children: [
        Expanded(
          flex: 1,
          child: _m!.headText(symbol, scale: 1.7, paddingV: 0.0),
        ),
        //SvgPicture.asset('assets/images/kuwait.svg'),
        SizedBox(width: MediaQuery.of(context).size.width/25,),
        Container(
          width: 1,
          height: MediaQuery.of(context).size.width/10,
          color: MyColors.bodyText1,
        ),
        Expanded(
          flex: 3,
            child: _m!.bodyText1(text, align: TextAlign.start, color: select? MyColors.mainColor: MyColors.bodyText1)),
        select? SvgPicture.asset('assets/images/check.svg'): SizedBox(),
      ],
    );
  }

  _apply() async{
    //lng = langNum;
    currencyValue = currency[currencyNum];
    editTransactionCurrencyVale();
    MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('New currency is applied!'));
    //changeProductPrice(productList);
   // changeProductPrice(newArrivalList);
   // MyAPI(context: context).changeLang(() => null, lng);
  }
}

