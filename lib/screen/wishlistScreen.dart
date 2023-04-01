import 'package:novel/screen/checkoutScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';

import '../api.dart';
import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myWishlistList.clear();
    for (int i = 0; i < wishList.length; i++) {
      myWishlistList.add(getProduct(wishList[i]['PROId']));
    }
  }

  TextEditingController _searchController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  var total = 119.99*3;
  List myWishlistList = [{'sale': 0}, {'sale': 20}, {'sale': 40}, {'sale': 0}, {'sale': 30}];

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
                          _m!.returnIcon(color: MyColors.white, click: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainScreen())),),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('wishlist'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 31,
              child: myWishlistList.isEmpty? _m!.empty():ListView.builder(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                itemCount: myWishlistList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _m!.cardWishlist(height: MediaQuery.of(context).size.width/2.7,
                    sale: int.parse(myWishlistList[index]['discount'].toString()),
                    head: getCategoryName(int.parse(myWishlistList[index]['CATId'].toString())-1),
                    name: getProductName(myWishlistList[index]),
                    price: double.parse(myWishlistList[index]['price'].toString()),
                    image: myWishlistList[index]['photoUrls'][0]['name'],
                    delete: ()async => await _deleteWishlist(myWishlistList[index]['PROId'], index),
                    addToCArt: ()=> _shopNow(myWishlistList[index]),
                  );
                },
              ),
            ),
            Flexible(
              flex: 4,
              child: _m!.bottomContainer(3, curve*0, bottomConRati: 0.1),
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

  _shopNow(product) {
    print(product.toString());
    if(product['items'].isEmpty){
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Items is empty in this product'));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProductDetails(product)
      ),);
  }

  _deleteWishlist(productId, index) async{
    setState(() {
      pleaseWait = true;
    });
    bool s = await MyAPI(context: context).deleteWishlist(token: token, productId: productId);
    if(s) myWishlistList.removeAt(index);
    setState(() {
      pleaseWait = false;
    });
  }

}
