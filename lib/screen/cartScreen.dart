import 'dart:math';

import 'package:novel/api.dart';
import 'package:novel/screen/checkoutScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _totatl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   _totatl = _readTotal();
  }

  TextEditingController _promoCod = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  var total = 0.0;
  List myCartList = [{'quantity': 1}, {'quantity': 2}, {'quantity': 1}, {'quantity': 3}];


  _readTotal() async{
    total = 0;
    await MyAPI(context: context).getShopCartTotal(token);
    /*myCartList.clear();
    for(int i = 0; i<cartList.length; i++){
      myCartList.add({'product': getProduct(cartList[i]['PROId']), 'item':getProduct(cartList[i]['PROId'])['items'][getProduct(cartList[i]['PROId'])['items'].indexWhere((element) => element['PIId']==cartList[i]['PIId'])], 'quantity': int.parse(cartList[i]['QTY'].toString())});
    }*/
    total = double.parse(cartListTotal['Total'].toString()) * double.parse(currencyValue['CurValue'].toString());
    /*for(int i =0; i<myCartList.length; i++){
      total += double.parse(myCartList[i]['product']['price'])*myCartList[i]['quantity'];
    }*/
  }
  @override
  Widget build(BuildContext context) {
    myCartList.clear();
    for(int i = 0; i<cartList.length; i++){
      myCartList.add({'product': getProduct(cartList[i]['PROId']), 'item':getProduct(cartList[i]['PROId'])['items'][getProduct(cartList[i]['PROId'])['items'].indexWhere((element) => element['PIId']==cartList[i]['PIId'])], 'quantity': int.parse(cartList[i]['QTY'].toString())});
    }
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
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
                          _m!.returnIcon(color: MyColors.white, click: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainScreen())),),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('YOUR CART'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 20,
              child: myCartList.isNotEmpty?
              ListView.builder(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                itemCount: myCartList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _m!.cardCart(height: MediaQuery.of(context).size.width/2.7,
                    quantity: myCartList[index]['quantity'],
                    sale: int.parse(myCartList[index]['product']['discount'].toString()),
                    head: getBrandName((myCartList[index]['product']['brandId'].toString())),
                    name: getProductName(myCartList[index]['product']),
                    price: double.parse(myCartList[index]['product']['price'].toString()),
                    image: myCartList[index]['product']['photoUrls'][0]['name'],
                    size: myCartList[index]['item']['size'],
                    quantityMin: ()=> setState(() {
                      _decreaseQuantity(index);
                    }),
                    quantityAdd: int.parse(myCartList[index]['item']['quantity'].toString())<=myCartList[index]['quantity']? null:
                        ()=> setState(() {
                          _increaseQuantity(index);
                    }),
                    delete: ()=> setState(() {
                      _deletCart(index);
                    }),
                  );
                },
              ):
              _m!.empty(),
            ),
            Flexible(
              flex: 11,
              child: Container(
                color: MyColors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width/30,),
                    _setPromoCode(),
                    _setComiWallet(),
                    FutureBuilder(
                      future: _totatl,
                      builder : (BuildContext context, AsyncSnapshot snap){
                        if(snap.connectionState == ConnectionState.waiting){
                          return JumpingText('.......',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/18,
                              color: MyColors.mainColor,
                              fontFamily: 'SairaBold',
                              // fontStyle: FontStyle.italic,
                            ),
                          );
                        }
                        else{
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _m!.bodyText1(AppLocalizations.of(context)!.translate('TOTAL AMOUNT')),
                              _m!.headText("$total".substring(0,min(7, total.toString().length))),
                            ],
                          );
                        }
                      },
                    ),
                    //SizedBox(height: MediaQuery.of(context).size.width/30,),
                    Expanded(child: Center()),
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('CHECKOUT'), null, cartList.isEmpty? null :()=> _checkout(), color: MyColors.mainColor),
                    SizedBox(height: MediaQuery.of(context).size.height/70,),
                  ],
                ),

              ),

            ),
            Flexible(
              flex: 4,
              child: _m!.bottomContainer(2, curve*0, bottomConRati: 0.1),
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

  _checkout() {
    !guestType? Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CheckoutScreen(total))): _m!.guestDialog();
  }

  _setPromoCode(){
    _submit() async{
      setState(() {
        pleaseWait = true;
      });
      bool s = await MyAPI(context: context).setPromoCode(token: token, code: _promoCod.text);
      if(s) total = double.parse(cartListTotal['Total'].toString());
      setState(() {
        pleaseWait = false;
      });
    }
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.width/9,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: 0.0),
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30),
              decoration: BoxDecoration(
                color: MyColors.metal,
                border: Border.all(color: MyColors.card),
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/30/2)),
              ),
              child: TextField(
                controller: _promoCod,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/26,
                    color: MyColors.bodyText1,
                    fontFamily: lng==2?'OmarMedium':'SairaMedium'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //labelText: titleText,
                  hintText: AppLocalizations.of(context)!.translate('Promo Code'),
                  hintStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/28,
                      color: MyColors.bodyText1,
                      fontFamily: lng==2?'OmarLight':'SairaLight'),
                  errorStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/2400,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: _m!.raisedButton(MediaQuery.of(context).size.width/30, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Submit'), null, ()=> _submit(), height: MediaQuery.of(context).size.width/9),
          ),
        ],
      ),
    );
  }

  bool _comiWallet = false;
  _setComiWallet(){
    _useComi() async{
      setState(() {
        _comiWallet = !_comiWallet;
        pleaseWait = true;
      });
      bool s = await MyAPI(context: context).setComiWallet(token: token, value: _comiWallet?'yes':'no');
      if(s) total = double.parse(cartListTotal['Total'].toString());
      setState(() {
        pleaseWait = false;
      });
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/60),
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/60, horizontal: MediaQuery.of(context).size.width/20),
      //color: MyColors.metal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30),
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.card),
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/17/3)),
                ),
                child: _comiWallet? Icon(Icons.check, color: MyColors.novelBlue, size: MediaQuery.of(context).size.width/17,): SizedBox(height: MediaQuery.of(context).size.width/17, width: MediaQuery.of(context).size.width/17,),
              ),
              onTap: ()=>_useComi(),
            ),
          ),
          Flexible(
            flex: 1,
            child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Use my COMI-Wallet'), color: MyColors.black, padding: 0.0),
          ),
        ],
      ),
    );
  }

  _increaseQuantity(index)async{
    myCartList[index]['quantity']++;
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).updateShopCart(token: token, pIId: myCartList[index]['item']['PIId'],quantity: myCartList[index]['quantity']);
    _readTotal();
    setState(() {
      pleaseWait = false;
    });

  }
  _decreaseQuantity(index)async{
    myCartList[index]['quantity']--;
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).updateShopCart(token: token, pIId: myCartList[index]['item']['PIId'],quantity: myCartList[index]['quantity']);
    _readTotal();
    setState(() {
      pleaseWait = false;
    });

  }
  _deletCart(index)async{
    //myCartList[index]['quantity']--;
    setState(() {
      pleaseWait = true;
    });
    bool s =false;
    !guestType?
    s = await MyAPI(context: context).deleteShopCart(token: token, pIId: myCartList[index]['item']['PIId'])
        :s = await MyAPI(context: context).deleteShopCartGuest(pIId: myCartList[index]['item']['PIId']);
    myCartList.removeAt(index);
    _readTotal();
    setState(() {
      pleaseWait = false;
    });

  }
}
