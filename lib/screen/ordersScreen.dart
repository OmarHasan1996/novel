import 'package:novel/screen/orderInformationScreen.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '/color/MyColors.dart';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('Orders'), padding: 0.0, color: MyColors.white, scale: 1.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 35,
                child: ordersList.isEmpty? _m!.empty():
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                  itemCount: ordersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: _m!.cardOrder(
                          height: MediaQuery.of(context).size.width/2.0,
                          name: ordersList[index]['AddressFirstname']+ ' ' + ordersList[index]['AddressLastname'],
                          product: ordersList[index]['OrderNumber'],
                          status: ordersList[index]['OrderStatus'],
                          total: double.parse(currencyValue['CurValue']) * double.parse(ordersList[index]['Total']),
                          date: ordersList[index]['Date'],
                          delete: ()=> _delete(index),
                          edit: ()=> _viewOrder(index),
                          //selected: selectedAddress == index? true:false
                      ),
                      onTap: ()=> _viewOrder(index),
                    )
                    ;
                  },
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

  _viewOrder(int index) async{

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderInformation(index))).then((value) => setState((){}));

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

}
