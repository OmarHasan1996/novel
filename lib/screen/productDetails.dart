import 'dart:math';

import '../api.dart';
import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
//import 'package:image_viewer/image_viewer.dart';
import 'package:fading_images_slider/fading_images_slider.dart';
class ProductDetails extends StatefulWidget {
  var product;
  ProductDetails(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState(product);
}

class _ProductDetailsState extends State<ProductDetails> {
  var product;
  _ProductDetailsState(this.product);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = getProduct_name(product);
    _description = getProduct_desc(product);
    _starNum = double.parse(product['rating'].toString());
    price = double.parse(product['items'][0]['price'].toString());
    sale = int.parse(product['discount'].toString());
    if(sale == null || sale == 0) isSale = false;
    else isSale = true;
    _colors.clear();
    for(int i = 0; i< product['items'].length; i++){
      bool newww = true;
      for(int j = 0; j < _colors.length; j++){
        if(product['items'][i]['color'] == _colors[j]) newww = false;
      }
      if(newww) _colors.add(product['items'][i]['color']);
    }
    _itemId = product['items'][0]['PIId'];

    _size = product['items'][0]['size'].toString();

  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordRepeatController = new TextEditingController();
  MyWidget? _m;

  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _imagesList.clear();
    _textList.clear();
    for(int i = 0; i < product['photoUrls'].length; i++){
      _imagesList.add(Image.network(product['photoUrls'][i]['name'], height: MediaQuery.of(context).size.height/2.44, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,));
      _textList.add(Text(''));
    }
    price = double.parse(product['items'][product['items'].indexWhere((element) => element['PIId'] == _itemId)]['price'].toString());

    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.white,
          MyColors.white,
          MyColors.white,
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

  List<Image> _imagesList=[];
  List<Text> _textList=[];
  var _starNum = 3.0;
  var name='T-Shirts';
  var _description='T-Shirts';
  var price = 119.99, sale=30;
  var isSale = false;
  List _colors = [0xff645828, 0xffD1452e, 0xffef4523, 0xff2df6f1];
  var _selectedColor = 0;
  var _quantity = 1;
  var _itemId = '1';

  initScreen(BuildContext context) {
    var curve = MediaQuery.of(context).size.width/20;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10*0, vertical: MediaQuery.of(context).size.height/40*0),
          child: Column(
              children: [
                Flexible(
                    flex: 7,
                    child:
                    Stack(
                      children: [
                        FadingImagesSlider(

                          textAlignment: Alignment.center,
                          images: _imagesList, texts: _textList,

                        ),
                        /*Container(
                          width: MediaQuery.of(context).size.width,
                          color: MyColors.backGround,
                          //alignment: Alignment.center,
                          child: _image == null? Image.asset('assets/images/lets.png', height: MediaQuery.of(context).size.height/2, fit: BoxFit.fitHeight,):
                          Image.network(_image, height: MediaQuery.of(context).size.height/2, fit: BoxFit.fitHeight,),
                        ),*/
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/40),
                            child: _m!.returnIcon(),
                          ),
                        ),
                      ],
                    )
                ),
                Flexible(
                  flex: 11,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/80),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _m!.starRow(MediaQuery.of(context).size.width/4, _starNum),
                          _m!.bodyText1(name.toString(),scale: 1.2,/*color: MyColors.orange,*/ padding: 0.0, align: TextAlign.start),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: isSale?[
                              _m!.headText(currencyValue['CurMark'] + ' ' + getPriceFit(price, sale),scale: 1.0, color: MyColors.novelBlue,),
                              _m!.bodyText1(currencyValue['CurMark'] + ' ' + getPriceFit(price, 0.0),scale: 1, padding: MediaQuery.of(context).size.width/40, align: TextAlign.start, baseLine: true),
                              Expanded(child: SizedBox()),
                              _m!.miniContainer(_m!.bodyText1(sale.toString() + '%', color: MyColors.white, scale: 1.0, padding: 0.0), MediaQuery.of(context).size.width/15),
                            ]: [
                              _m!.headText(currencyValue['CurMark'] + ' ' + (price).toString(),scale: 1),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/100,),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Color:'), padding: 0.0),
                          SizedBox(
                            height: MediaQuery.of(context).size.width/12,
                            child: _horisintalListColor(),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/60,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _m!.bodyText1(AppLocalizations.of(context)!.translate('Size:'),color: MyColors.novelBlue, padding: 0.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width/3,
                                    height: MediaQuery.of(context).size.width/7,
                                    decoration: BoxDecoration(
                                      color: MyColors.white,
                                      border: Border.all(
                                          color: MyColors.card
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(curve/2)),
                                    ),
                                    child: _dropDown(),
                                  )
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _m!.bodyText1(AppLocalizations.of(context)!.translate('Quantity:'),color: MyColors.novelBlue, padding: 0.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width/3,
                                    height: MediaQuery.of(context).size.width/7,
                                    decoration: BoxDecoration(
                                      color: MyColors.white,
                                      border: Border.all(
                                          color: MyColors.card
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(curve/2)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Icon(Icons.minimize_outlined),
                                            onPressed: _quantity == 1? null:()=> setState((){
                                              _quantity--;
                                            }),
                                          ),),
                                        Expanded(
                                          flex: 1,
                                          child: _m!.headText(_quantity.toString(), color: MyColors.black),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Icon(Icons.add_outlined),
                                            onPressed: _quantity >= int.parse(product['items'][product['items'].indexWhere((element) => element['PIId'] == _itemId)]['quantity'].toString())? null:()=> setState((){
                                              _quantity++;
                                            }),
                                          ),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/60,),

                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Description'), color: MyColors.gray, padding: 0.0, scale: 1.1),


                          _m!.bodyText1(_description, maxLine: 111, padding: 0.0, align: TextAlign.start, scale: 0.75),
                        ],
                      ),
                    ),
                  ),

                ),
                //SizedBox(height: MediaQuery.of(context).size.height/20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Add to cart'), null, ()async=> await _addToCart(_itemId), color: MyColors.mainColor, textColor: MyColors.white),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                  ],
                ),
              ]
          ),
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

  _addToCart(pIId) async{
    setState((){
      pleaseWait = true;
    });
    bool s = false;
    !guestType? s = await MyAPI(context: context).addShopCart(token: token, pIId: pIId, quantity: _quantity)
    :s = await MyAPI(context: context).addShopCartGuest(pIId: pIId, quantity: _quantity);
    //addCart(id: cartList.length+1, name: name, size: _size, color: _selectedColor, quantity: _quantity, price: price);
    if(s) {
      //cartList.clear();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MainScreen()), (route) => false);
    }
    setState((){
      pleaseWait = false;
    });

  }

  _horisintalListColor(){
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: _colors.length,
      itemBuilder: (BuildContext context, int i) {
        return GestureDetector(
          onTap: ()=> setState((){
            _quantity = 1;
            _selectedColor = i;
            _itemId = product['items'][product['items'].indexWhere((element) => element['color'] == _colors[_selectedColor])]['PIId'];
            _size = product['items'][product['items'].indexWhere((element) => element['color'] == _colors[_selectedColor])]['size'];
          }),
          child: _m!.colorContainer(_colors[i], _selectedColor==i? true: false),
        );
      },
    );
  }

  final List<String>  _sizes = <String> ['Type1', 'Type2', 'Type3'];
  var _size = 'country';

  _dropDown(){
    _sizes.clear();
    for(int i = 0; i< product['items'].length; i++){
      bool newww = false;
      if(product['items'][i]['color'] == _colors[_selectedColor]) newww = true;
      if(newww) _sizes.add(product['items'][i]['size']);
    }
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
      //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
        decoration: BoxDecoration(
            color: MyColors.white,
           borderRadius: BorderRadius.all(Radius.circular(100))
        ),
        //width: width,
        //height: MediaQuery.of(context).size.width/6.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _m!.bodyText1(_size.toString(), align: TextAlign.start,scale: 1.25, padding: 0.0),
                DropdownButton<String>(
                  //key: _dropDownKey,
                    underline: DropdownButtonHideUnderline(child: Container(),),
                    icon: const Icon(Icons.keyboard_arrow_down_outlined,),
                    dropdownColor: MyColors.white.withOpacity(0.9),
                    //value: 'Type1',
                    items: _sizes.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.gray,
                              fontFamily: 'SairaMedium'),
                        ))).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return _sizes.map((e) => Text(e.toString())).toList();
                    },
                    onChanged: (chosen){
                      setState(() {
                        _quantity = 1;
                        _size = chosen.toString();
                        _itemId = product['items'][product['items'].indexWhere((element) => element['color'] == _colors[_selectedColor] && element['size'].toString() == _size)]['PIId'];
                        print(chosen.toString() + _itemId);
                      });
                    }
                ),
              ],
            ),
            //_m!.driver(color: _error && _countryId == '-1'?MyColors.red: Colors.grey),
          ],
        )
    );
  }

  _deleteFromCart(productId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).deleteWishlist(token: token, productId: productId);
    setState(() {
      pleaseWait = false;
    });
  }

}

