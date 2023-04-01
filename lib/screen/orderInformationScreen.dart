import 'package:flutter/material.dart';

import '../api.dart';
import '../color/MyColors.dart';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class OrderInformation extends StatefulWidget {
  var index;
  OrderInformation(this.index, {Key? key}) : super(key: key);

  @override
  State<OrderInformation> createState() => _OrderInformationState(index);
}

class _OrderInformationState extends State<OrderInformation> {
  var index;
  _OrderInformationState(this.index);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order = ordersList[index];
  }

  Map order = {};

  MyWidget? _m;

  var _openDetailsNum = 0;
  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    //print(shippingMethodsList.indexWhere((element) => element['ShipId'].toString() == order['ShipId'].toString()).toString());

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
    //print(shippingMethodsList.indexWhere((element) => element['ShipId'].toString() == order['ShipId'].toString()).toString());
    var curve = MediaQuery
        .of(context)
        .size
        .width / 30;
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
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('Order Information'), padding: 0.0, color: MyColors.white, scale: 1.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 11,
                child: _m!.cardOrderInformation(
                  paymentMethod: order['PayType'],
                  shippingMethod: getProductName(shippingMethodsList[int.parse(shippingMethodsList.indexWhere((element) => element['ShipId'].toString() == order['ShipId'].toString()).toString())]),
                  name: order['AddressFirstname'] + ' ' + order['AddressLastname'],
                  location: 'ST (${order['AddressAddress1']}), CT (${order['AddressAddress2']}), AVE (${order['AddressCity']}), BLVD (${order['AddressCountry']}).',
                  date: order['Date'],
                ),
                ),
              Flexible(
                flex: 24,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: curve/2, horizontal: curve),
                  padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
                  color: MyColors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                    itemCount: order['items'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemDetails(curve,
                          getProductName(getProduct(order['items'][index]['PROId'])).toString(),
                         order['items'][index]['quantity'], order['items'][index]['Price'], index
                      );
                    },
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
        ]
    );
  }

  _delete(int index) async{
    /*setState((){
      pleaseWait = true;
    });
    await MyAPI(context: context).deleteUserAddress(token: token, addressId: myAddress[index]['AddressId']);
    setState((){
      pleaseWait = false;
    });*/
  }

  _row(txtLeft, txtRight){
    return Row(
      children: [
        _m!.bodyText1(txtLeft, color: MyColors.card),
        Expanded(child: SizedBox()),
        _m!.bodyText1(txtRight, color: MyColors.black),
      ],
    );
  }

  _select(index){
    setState(() {
      _openDetailsNum = index;
    });
  }
  
  _itemDetails(curve, name, quantity, price, index){
    bool open = false;
    index == _openDetailsNum? open = true: open = false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
      margin: EdgeInsets.symmetric(horizontal: curve*0, vertical: curve),
      decoration: BoxDecoration(
        color: open? MyColors.metal: MyColors.white,
        border: Border.all(color: MyColors.card),
        borderRadius: BorderRadius.all(Radius.circular(curve)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _m!.headText(name),
              Expanded(child: SizedBox()),
              IconButton(onPressed: ()=> _select(index),
                icon: Icon(open? Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_right, size: MediaQuery.of(context).size.width/12,),
              )
            ],
          ),
          open?
          Column(
            children: [
              _m!.driver(padV: curve),
              // _row(AppLocalizations.of(context)!.translate('Code'), code),
              _row(AppLocalizations.of(context)!.translate('Quantity'), quantity),
              _row(AppLocalizations.of(context)!.translate('Price'), currencyValue['CurMark'] + ' ' + (double.parse(price.toString()) * double.parse(currencyValue['CurValue'].toString())).toString()),
              _row(AppLocalizations.of(context)!.translate('Total'), currencyValue['CurMark'] + ' ' + (int.parse(quantity) * double.parse(price)).toString()),
            ],
          ):SizedBox(),
        ],
      )
    );
  }

}
