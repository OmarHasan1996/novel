import 'package:novel/api.dart';
import 'package:novel/screen/paymentMethodsScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:novel/screen/subbmitOrder.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'addressScreen.dart';
import 'mainScreen.dart';
class CheckoutScreen extends StatefulWidget {
  var total;
  CheckoutScreen(this.total, {Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState(total);
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _CheckoutScreenState(this.total);
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _cardNameController = new TextEditingController();
  TextEditingController _cardNumController = new TextEditingController();
  TextEditingController _cardDateController = new TextEditingController();
  TextEditingController _cardCVVController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  var total;
  List myCartList = [{'quantity': 1}, {'quantity': 2}, {'quantity': 1}, {'quantity': 3}];

  var _cashType = false;

  @override
  Widget build(BuildContext context) {
    if(myAddress.isNotEmpty){
      _nameController.text = myAddress[selectedAddress]['firstName']+ ' ' +myAddress[selectedAddress]['lastName'];
      _addressController.text = 'ST (${myAddress[selectedAddress]['address1']}), CT (${myAddress[selectedAddress]['address2']}), AVE (${myAddress[0]['city']}), BLVD (${countries[countries.indexWhere((element) => element['countryId']==myAddress[selectedAddress]['countryId'])]['countryName']}).';
      _mobileController.text = userInfo['phone']??'';
    }
    if(paymentCard.isNotEmpty){
      _cardNameController.text = AppLocalizations.of(context)!.translate('Name On Card') + '\n' + paymentCard[0]['name'];
      _cardNumController.text = AppLocalizations.of(context)!.translate('Card Number') + '\n' + paymentCard[0]['cardNumber'];
      _cardCVVController.text = AppLocalizations.of(context)!.translate('CVV Code') + '\n' + paymentCard[0]['securityCode'];
      _cardDateController.text = AppLocalizations.of(context)!.translate('Exp Date') + '\n' + paymentCard[0]['expirationDate'];
    }
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
                      color: MyColors.novelBlue,
                      child: Row(
                        children: [
                          _m!.returnIcon(color: MyColors.white,),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Checkout'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.all(Radius.circular(curve)),
                    color: MyColors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _m!.headText(AppLocalizations.of(context)!.translate('Shipping Address')+':'),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            child: _m!.headText(myAddress.isNotEmpty?AppLocalizations.of(context)!.translate('Address Info'):AppLocalizations.of(context)!.translate('Add address'), color: MyColors.mainColor),
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Address())).then((value) => setState((){})),
                          )
                        ],
                      ),
                      _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.black, _nameController, AppLocalizations.of(context)!.translate('Name'), null),
                      _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.black, _addressController, AppLocalizations.of(context)!.translate('Address'), null),
                      _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.black, _mobileController, AppLocalizations.of(context)!.translate('Mobile Number'), null),
                      Row(
                        children: [
                          _m!.headText(AppLocalizations.of(context)!.translate('Payment method')+':'),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            child: _m!.headText(paymentCard.isNotEmpty?AppLocalizations.of(context)!.translate('Card Info'):AppLocalizations.of(context)!.translate('Add card'), color: MyColors.mainColor),
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PaymentMethods())).then((value) => setState((){})),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: ()=> _slectPayType(0),
                            icon: SvgPicture.asset('assets/images/point.svg', color: !_cashType? MyColors.novelBlue: MyColors.card,),
                          ),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Card'), scale: 1.2, align: TextAlign.start, padding: 0.0, color: MyColors.black),
                          Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: ()=> _slectPayType(1),
                            icon: SvgPicture.asset('assets/images/point.svg', color: _cashType? MyColors.novelBlue: MyColors.card,),
                          ),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Cash'), scale: 1.2, align: TextAlign.start, padding: 0.0, color: MyColors.black),
                        ],
                      ),
                      _cashType ? SizedBox(): _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.bodyText1, _cardNameController, AppLocalizations.of(context)!.translate('Name On Card'), null, height: MediaQuery.of(context).size.width/4.7),
                      _cashType ? SizedBox(): _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.bodyText1, _cardNumController, AppLocalizations.of(context)!.translate('Name On Card'), null, height: MediaQuery.of(context).size.width/4.7),
                      _cashType ? SizedBox(): _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.bodyText1, _cardCVVController, AppLocalizations.of(context)!.translate('Name On Card'), null, height: MediaQuery.of(context).size.width/4.7),
                      _cashType ? SizedBox(): _m!.textFiledBorder(curve/2, MyColors.metal, MyColors.bodyText1, _cardDateController, AppLocalizations.of(context)!.translate('Name On Card'), null, height: MediaQuery.of(context).size.width/4.7),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: Container(
                //color: MyColors.white,
                //width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dropDown(),
                    //_m!.iconText('assets/images/noun_delivery.svg', AppLocalizations.of(context)!.translate("Standard Shipment Free Within 3-6 Business Days"), MyColors.black),
                    _m!.driver(padH: MediaQuery.of(context).size.width/20, padV: MediaQuery.of(context).size.height/100),
                   // _m!.iconText('assets/images/noun_FastDelivery.svg', AppLocalizations.of(context)!.translate("Express Delivery \n\$35,00 Available"), MyColors.black),
                    SizedBox(height: MediaQuery.of(context).size.width/20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('TOTAL AMOUNT'), color: MyColors.black),
                            _m!.bodyText1(total.toString(), color: MyColors.black),
                          ],
                        ),
                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Submit Order'), null, ()=> _submitOrder())
                      ],
                    ),
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

  _submitOrder() async{
    setState(() {
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).checkOut(token: token, payType: _cashType? 'cash' : 'credit', pCId: paymentCard[0]['PCId'], shipId: _shippingMethod['ShipId'], addressId: myAddress[selectedAddress]['AddressId']);
    if (s) {
      cartList.clear();
      cartList= [];
      editTransactionCartList();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SubbmitOrder()));
    }
    setState(() {
      pleaseWait = false;
    });
  }

  _slectPayType(num) {
    setState(() {
      num == 0? _cashType = false: _cashType = true;
    });
  }

  final GlobalKey _dropDownKey = GlobalKey();

  _openList() {
    _dropDownKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              //return false;
            });
          }
        });
      }
    });
  }

  var _shippingMethod = shippingMethodsList[0];
  _dropDown(){
    var curve = MediaQuery.of(context).size.height/100;
    List<String> _shippingName = [];
    for(int i = 0; i < shippingMethodsList.length; i++){
      _shippingName.add(lng==0?shippingMethodsList[i]['name_en']:lng==1?shippingMethodsList[i]['name_fr']:shippingMethodsList[i]['name_ar']);
    }
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
      //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
      /*decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.all(Radius.circular(curve))
        ),*/
      //width: width,
      //height: MediaQuery.of(context).size.width/6.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                _m!.iconText('assets/images/noun_delivery.svg', (lng==0?_shippingMethod['name_en']:lng==1?_shippingMethod['name_fr']:_shippingMethod['name_ar']).toString() + ' , ' + AppLocalizations.of(context)!.translate('Value: ') + _shippingMethod['value'], MyColors.black, click: ()=> _openList(), scale: 1.2),
                DropdownButton<String>(
                    key: _dropDownKey,
                    underline: DropdownButtonHideUnderline(child: Container(),),
                    icon: Icon(Icons.arrow_forward_ios_outlined, size: 0.0001,),
                    dropdownColor: MyColors.white.withOpacity(0.9),
                    //value: 'Type1',
                    items: _shippingName.map((e) => DropdownMenuItem(
                        value: e,
                          child: Text(e.toString(),
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                                color: MyColors.gray,
                                fontFamily: 'SairaMedium'),
                            textAlign: TextAlign.center,
                          ),
                        )).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return _shippingName.map((e) => Container(
                        child: Text(e.toString()),
                        width: MediaQuery.of(context).size.width/1.1,
                        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                      )).toList();
                    },
                    onChanged: (chosen){
                      setState(() {
                        _shippingMethod = shippingMethodsList[_shippingName.indexWhere((element) => element == chosen)];
                        //_genderController.text = chosen.toString();
                        //gender = chosen.toString();
                        //gender == AppLocalizations.of(context)!.translate('Male') ? _gender = 0 : _gender = 1;
                        print(chosen.toString());
                      });
                    }
                ),
              ],
            ),
            //_m!.driver(color: _error && _gender == -1?MyColors.red: Colors.grey),
          ],
        )
    );
  }


}
