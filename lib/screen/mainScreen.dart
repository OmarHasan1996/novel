import 'package:novel/api.dart';
import 'package:novel/screen/filterScreen.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:swipe_deck/swipe_deck.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key,}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(() {
      setState(() {
        if(_searchController.text.isNotEmpty){
          _search = true;
          if(_categoryNum == 0){
            _internalProduct = productList.where((element) =>
                element['name_ar'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_en'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_fr'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
            ).toList();
          }else{
            /*_internalProduct = _internalProduct.where((element) =>
            element['name_ar'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_en'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_fr'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
            ).toList();*/
          }
        }
        else _search = false;
      });
    });
  }

  TextEditingController _searchController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  List _internalProduct = [];
  List _subCategoryList = [];
  List topHeader = [];
  var _categoryNum = 0;
  bool _main = true;
  bool _search = false;
  var _brandId = '1';


  @override
  Widget build(BuildContext context) {
    topHeader.clear();
    topHeader.add({'CATId': 0,'text': AppLocalizations.of(context)!.translate('All'), "click": _main? ()async=> await _clickHeader(0):null});
    for(int i=0; i< categoryList.length; i++){
      topHeader.add({'CATId': int.parse(categoryList[i]['CATId'].toString()),'text': getCategoryName(i), "click": ()async=> await _clickHeader(i+1)});
    }
    _subCategoryList.clear();
    _subCategoryList.add({'text':AppLocalizations.of(context)!.translate('All')});
    for(int i=0; i< subCategoryList.length; i++){
      _subCategoryList.add(subCategoryList[i]);
    }
    if(!homeNotCategory && _categoryNum ==0 && topHeader.length>2) _clickHeader(1);
    salesList.shuffle();
    _m = MyWidget(context);
    if(filter){
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.isEmpty) break;
        if(productList[i]['CATId'].toString() == categoryNum.toString() &&
            productList[i]['SCId'].toString() == _subCategoryList[subCategorySelectNum]['SCId'].toString() &&
            double.parse(productList[i]['price'].toString()) <= maxPrice
        ){
            _internalProduct.add(productList[i]);
        }
      }
      _internalProduct.sort((a, b) {
        if(!highToLowPriceFilter) return a['price'].toString().toLowerCase().compareTo(b['price'].toString().toLowerCase());
        else return b['price'].toString().toLowerCase().compareTo(a['price'].toString().toLowerCase());
      });
      _internalProduct.sort((a, b) {
        if(!highToLowRateFilter) return a['rating'].toString().toLowerCase().compareTo(b['rating'].toString().toLowerCase());
        else return b['rating'].toString().toLowerCase().compareTo(a['rating'].toString().toLowerCase());
      });
    }
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
        backgroundColor: MyColors.white,
        body: initScreen(context),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  var _password = true;

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
              flex: 4,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height/5/2,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/100),
                      color: MyColors.white,
                      child: Row(
                        children: [
                          _m!.comimaniaLogo(scale: 0.55, color: true),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.notificationButton(),
                          //SizedBox(height: MediaQuery.of(context).size.height / 25,),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height/5/2,
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5/2),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/170*0),
                        color: MyColors.novelBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Flexible(
                              flex: 2,
                              child: _horisintalListHeader(),
                            ),
                          ],
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/5,
                        //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4/2),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/80),
                        //color: MyColors.orange,
                        child: Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: _container(curve,
                                TextField(
                                  //obscureText: password,
                                  //readOnly: readOnly,
                                  //maxLines: password? 1: null,
                                  //validator: requiredValidator,
                                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                                  //keyboardType: password? TextInputType.visiblePassword: number?  TextInputType.number : TextInputType.text,

                                  controller: _searchController,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/22,
                                      color: MyColors.black,
                                      fontFamily: 'SairaMedium'),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.search, color: MyColors.mainColor,),
                                    border: InputBorder.none,

                                    //labelText: titleText,
                                    hintText: AppLocalizations.of(context)!.translate('Search '),
                                    hintStyle: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: MyColors.mainColor,
                                        fontFamily: 'SairaLight'),
                                    errorStyle: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/2400,
                                    ),
                                  ),
                                ), borderColor: MyColors.mainColor),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/30,),
                            Expanded(
                                flex:1,
                                child: _container(
                                  curve,
                                  IconButton(
                                    padding: EdgeInsets.all(0.1),
                                    icon: Icon(Icons.filter_alt_outlined, color: !filter?MyColors.mainColor:MyColors.novelBlue, size: MediaQuery.of(context).size.width/12,),
                                    onPressed: ()=> Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => FilterScreen(),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            final tween = Tween(begin: begin, end: end);
                                            final offsetAnimation = animation.drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                            },
                                        )
                                    //    MaterialPageRoute(builder: (context)=> FilterScreen())
                                    ).then((value) => setState((){
                                      if(!filter)_clickHeader(_categoryNum);
                                      else _categoryNum = categoryNum;
                                    })),
                                  ),borderColor: MyColors.mainColor
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 14,
              child:
                  RefreshIndicator(
                    onRefresh: ()=> _onRefresh(),
                    child: _categoryNum == 0 && _main && !_search ?
                    ListView(
                      children: [
                        _fanSlider(curve),
                        _fourCards(curve/2),
                        _swipCard3(curve),
                        homeSection4List.length>2?_threeTapCard(curve, homeSection4List.getRange(0, 3).toList()):SizedBox(),
                        homeSection4List.length>5?_threeTapCard(curve, homeSection4List.getRange(3, 6).toList()):SizedBox(),
                        homeSection4List.length>8?_threeTapCard(curve, homeSection4List.getRange(6, 9).toList()):SizedBox(),
                        _sales(color: MyColors.orange1),
                        _brands(homeSection6List),
                        _newArrivals(),
                        homeSection8List.length>4?_fiveTapCard(curve, homeSection8List):SizedBox(),
                        _swiper(),
                        _brands(homeSection10List),
                        //_mostPopulars(),
                         _stairingGridCard(curve),
                        //_m!.cardMain(sale: 30),
                      ],
                    )
                        : _categoryNum == 0 || homeNotCategory || filter?
                        Column(
                          children: [
                            Flexible(
                              flex: 1,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width/40, left: MediaQuery.of(context).size.width/40,right: MediaQuery.of(context).size.width/40),
                                  itemCount: _subCategoryList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: _containerText(index == _subCategorySelectNum? MyColors.mainColor:MyColors.bodyText1,index == 0? _subCategoryList[index]['text'] : lng == 0?_subCategoryList[index]['name_en']:_subCategoryList[index]['name_ar']),
                                      onTap: ()=> _selectCategory(index),
                                    );
                                  },
                                ),
                            ),
                            Flexible(
                              flex: 10,
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                                  itemCount: _internalProduct.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2),
                                  itemBuilder: (BuildContext context, int index) {
                                    return _m!.cardMain(
                                      height: MediaQuery.of(context).size.width/1.58,
                                      name: getProduct_name(_internalProduct[index]),
                                      starRate: double.parse(_internalProduct[index]['rating'].toString()),
                                      price: double.parse(_internalProduct[index]['price'].toString()),
                                      sale: int.parse(_internalProduct[index]['discount'].toString()),
                                      image: _internalProduct[index]['photoUrls'][0]['name'],
                                      select: ()=> _select(_internalProduct[index]),
                                      favoraite: getIfFavorite(_internalProduct[index]['PROId']),
                                      favorite: ()async=> await _addOrDeleteWishlist(_internalProduct[index]['PROId']),
                                    );
                                  },
                                )),

                            ],
                        )
                        :
                    _category(),
                  ),
            ),
            Flexible(
              flex: 2,
              child: _m!.bottomContainer(homeNotCategory?0:1, curve*0, bottomConRati: 0.1, setState: ()=>_setState()),
            ),
          ],
        )  ,
        Align(
          alignment: Alignment.center,
          child: pleaseWait?
          _m!.progress()
              :
          const SizedBox(),
        ),
      ],
    )
      ;
  }

  _horisintalListHeader(){
    return ListView.builder(
      padding: EdgeInsets.all(0.1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: topHeader.length,
      itemBuilder: (BuildContext context, int i) {
        return GestureDetector(
          onTap: ()async=> await _clickHeader(topHeader[i]['CATId']),
          child: _m!.bodyText1(topHeader[i]['text'], color: _categoryNum == 0&& !_main? MyColors.whiteNight : _categoryNum == topHeader[i]['CATId'] ? MyColors.white : MyColors.whiteNight, scale: 1.3, padding: MediaQuery.of(context).size.width/35, padV: 0.0),
        );
      },
    );
  }

  _container(curve, _child,{borderColor}){
    borderColor??= MyColors.white;
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white.withOpacity(0.99),
        /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
        border: Border.all(
          color: borderColor,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(curve/2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: curve/2),
      child: _child,
    );
  }

  _fanSlider(curve){
    List<String> sampleImages = [];
    for(var image in homeSection1List){
      sampleImages.add(image['photoUrls']);
    }
    return FanCarouselImageSlider(
      imageRadius: curve,
      sliderHeight: MediaQuery.of(context).size.height/2.6,
      imagesLink: sampleImages,
      isAssets: false,
      autoPlay: true,

    );
  }

  /*_fourCards(curve){
    var h = MediaQuery.of(context).size.height/4.8;
    var w = MediaQuery.of(context).size.width/2.34;
    var textScale = 0.8;
    return Padding(padding: EdgeInsets.all(curve*2),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: h/3),
                        width: 3,
                        color: MyColors.mainColor,
                        height: h/1.5),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: curve/3), child:
                          Image.asset(lng ==2?homeSection2List[0]['image_en']:homeSection2List[0]['image_ar'], fit: BoxFit.cover, height: h /1.5, ),//homeSection2List[0]['image_en']),
                          ),
                          MyWidget(context).headText(AppLocalizations.of(context)!.translate("Modern furniture"), color: MyColors.mainColor, scale: textScale),
                        ],
                      ),),
                    Container(
                        width: 3,
                        color: MyColors.mainColor,
                        height: h/1.5),

                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(vertical: curve),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child:
                        MyWidget(context).headText(AppLocalizations.of(context)!.translate("Exclusive furniture"), color: MyColors.white, scale: textScale, paddingV: 0.0, paddingH: 0.0),
                        ),
                        Container(
                            width: w/5,
                            color: MyColors.white,
                            height: 3),
                      ],
                    ),
                    Expanded(
                      child:
                          Padding(padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2), child:
                          Image.asset(lng ==2?homeSection2List[1]['image_en']:homeSection2List[1]['image_ar'], fit: BoxFit.cover, height: h /1.5, ),//homeSection2List[0]['image_en']),
                          ),
                        ),
                    Container(
                        width: w/2,
                        color: MyColors.white,
                        height: 3),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height/50,),
          Row(
            children: [
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(vertical: curve),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: w/4,
                            color: MyColors.white,
                            height: 3),
                        Expanded(child:
                        MyWidget(context).headText(AppLocalizations.of(context)!.translate("Best deal"), color: MyColors.white, scale: textScale, paddingV: 0.0, paddingH: 0.0),
                        ),
                      ],
                    ),
                    Expanded(
                      child:
                      Padding(padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2), child:
                      Image.asset(lng ==2?homeSection2List[2]['image_en']:homeSection2List[2]['image_ar'], fit: BoxFit.cover, height: h /1.5, ),//homeSection2List[0]['image_en']),
                      ),
                    ),
                    Container(
                        width: w/2,
                        color: MyColors.white,
                        height: 3),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: h/3),
                        width: 3,
                        color: MyColors.mainColor,
                        height: h/1.5),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyWidget(context).headText(AppLocalizations.of(context)!.translate("Comfort furniture"), color: MyColors.mainColor, scale: textScale),
                          Padding(padding: EdgeInsets.symmetric(horizontal: curve/3), child:
                          Image.asset(lng ==2?homeSection2List[3]['image_en']:homeSection2List[3]['image_ar'], fit: BoxFit.cover, height: h /1.5, ),//homeSection2List[0]['image_en']),
                          ),
                        ],
                      ),),
                    Container(
                        width: 3,
                        color: MyColors.mainColor,
                        height: h/1.5),

                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }*/
  _fourCards(curve){
    var h = MediaQuery.of(context).size.height/4.8;
    var w = MediaQuery.of(context).size.width/2.34;
    var textScale = 0.8;
    return Padding(padding: EdgeInsets.all(curve*2),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(lng !=2 ? homeSection2List[1]['image_en']:homeSection2List[1]['image_ar']),
                        fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
              ),
              Expanded(child: SizedBox()),
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(lng !=2 ? homeSection2List[0]['image_en']:homeSection2List[0]['image_ar']),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height/50,),
          Row(
            children: [
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(lng !=2 ? homeSection2List[2]['image_en']:homeSection2List[2]['image_ar']),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
              ),
              Expanded(child: SizedBox()),
              Container(
                height: h,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: curve),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(lng !=2 ? homeSection2List[3]['image_en']:homeSection2List[3]['image_ar']),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(curve)),
                  color: MyColors.mainColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _swipCard3(curve){
     try{
       var w1 = homeSection3List
           .asMap().map((index, e) => MapEntry(index, GestureDetector(
         onTap: () {
           _selectPro(e['PROId']);
         },
         child: Stack(
           children: [
             Align(
               alignment: Alignment.center,
               child:ClipRRect(
                 borderRadius: BorderRadius.all(Radius.circular(curve)),
                 child: Image.network(
                   e['ImageUrl'],
                   fit: BoxFit.cover,
                 ),
             ),
             ),
             Align(
               alignment: Alignment.bottomLeft,
               child:Container(
                   child : MyWidget(context).bodyText1((index+1).toString() + '/' + homeSection3List.length.toString(), color: MyColors.white),
                 //padding: EdgeInsets.symmetric(horizontal: curve/2),
                 margin: EdgeInsets.all(curve/2),
                 decoration: BoxDecoration(
                   color: MyColors.card,
                   borderRadius: BorderRadius.all(Radius.circular(curve/2))
                 ),
                 
               ),
             )
           ],
         )
         
       ))).values.toList();
       return Container(
         padding: EdgeInsets.all(curve),
        child: SwipeDeck(
          startIndex: 0,
          emptyIndicator: Container(
            child: Center(
              child: Text("Nothing Here"),
            ),
          ),
          cardSpreadInDegrees: 30, // Change the Spread of Background Cards
          onSwipeLeft: (){
           // print("USER SWIPED LEFT -> GOING TO NEXT WIDGET");
          },
          onSwipeRight: (){
            //print("USER SWIPED RIGHT -> GOING TO PREVIOUS WIDGET");
          },
          onChange: (index){
            //print(IMAGES[index]);
          },
          widgets: w1,
        ),
      );
    }
    catch(e){


    }
    return SizedBox();

  }

  _threeTapCard(curve, homeSectoin4){
    sectionContainer(image, text, curve){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/4.5,
        decoration: BoxDecoration(image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover)),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(curve/2),
          decoration: BoxDecoration(
              border: Border.all(color: MyColors.white, width: 3)
          ),
          child: Center(child: MyWidget(context).headText(text, color: MyColors.white, scale: 1.4)),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(curve),
      child: Column(
        children:[
          sectionContainer(homeSectoin4[0]['ImageUrl'], 'text', curve),
          SizedBox(height: curve/2,),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: sectionContainer(homeSectoin4[1]['ImageUrl'], 'text', curve),
              ),
              SizedBox(width: curve/2,),
              Flexible(
                  flex: 1,
                  child: sectionContainer(homeSectoin4[2]['ImageUrl'], 'text', curve),
              ),
            ],
          )
        ]
      )
    );
  }
  
  _sales({color}){
    var sales = homeSection5List[0];
    var pad = MediaQuery.of(context).size.height/80;
    return Column(
      children: [
        SizedBox(height: pad,),
        _m!.cardSales(
    backgroundColor: color,
    head: getProductTitle(sales),
    name: getProductName(sales),
    supName: getProductDesc(sales),
    //head: _internalProduct[index]['price'],
    image: sales['ImageUrl'],
    viewAll: ()=> setState((){
      _main = false;
      _internalProduct.clear();
      for(int i =0; i < salesList.length; i++){
        _internalProduct.add(salesList[i]);
      }
    }),
    ),
        SizedBox(height: pad,),
      ],
    );
  }

  _brands(homeSection6List){
    var pad = MediaQuery.of(context).size.height/80;
    var hight = MediaQuery.of(context).size.width/1.9 + pad*2;
    return Container(
        height: hight,
        width: MediaQuery.of(context).size.width,
        color: MyColors.color1,
        margin: EdgeInsets.symmetric(vertical: pad),
        padding: EdgeInsets.symmetric(vertical: pad),
        child: Column(
          children: [
            //_m!.bodyText1(AppLocalizations.of(context)!.translate("Today's Popular Brands")),
            Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: homeSection6List.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      /*onTap: ()=> setState((){
                      _main = false;
                      _brandId = brand[i]['brandId'];
                    }),*/
                      child: _m!.cardBrand(
                        image: homeSection6List[i]['ImageUrl'],
                        brandName: AppLocalizations.of(context)!.translate('key'),
                        select: ()=> setState((){
                          _main = false;
                          //_brandId = homeSection6List[i]['PROId'];
                          _selectPro(homeSection6List[i]['PROId']);
                          // categoryNum = 11111;
                        }),
                      ),

                    );
                  },
                )
            ),
          ],
        )
    );

  }

  _newArrivals(){
    List newArrivals = homeSection7List.where((element) => true).toList();
    var pad = MediaQuery.of(context).size.height/70;
    var hight = MediaQuery.of(context).size.width/1.5 + pad*2;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      color: MyColors.white,
        margin: EdgeInsets.symmetric(vertical: pad),
        padding: EdgeInsets.symmetric(vertical: pad),
        child: Column(
        children: [
          /*Row(
            children: [
              _m!.bodyText1(AppLocalizations.of(context)!.translate('New Arrivals')),
              //_m!.bodyText1(AppLocalizations.of(context)!.translate('وصل حديثا')),
              Expanded(child: SizedBox()),
              GestureDetector(
                child: _m!.bodyText1(AppLocalizations.of(context)!.translate('View All')),
                onTap: ()=> setState((){
                  _main = false;
                  _internalProduct.clear();
                  for(int i =0; i < newArrivals.length; i++){
                    _internalProduct.add(getProduct(newArrivals[i]['PROId']));
                  }             //_brandId = brand[i]['brandId'];
                  // categoryNum = 11111;
                }),
              ),

            ],
          ),*/
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: newArrivals.length,
                itemBuilder: (BuildContext context, int i) {
                  return _m!.cardMain(
                    height: hight-MediaQuery.of(context).size.width/8 - pad*2,
                    //select: ()=> _select(i),
                    name: newArrivals[i][lng==0?'name_en':lng==1?'name_fr':'name_ar'],
                    price: double.parse(newArrivals[i]['price'].toString()),
                    sale: int.parse(newArrivals[i]['discount'].toString()),
                    image: newArrivals[i]['photoUrls'],
                    select: ()=> _select(getProduct(newArrivals[i]['PROId'])),
                    favoraite: getIfFavorite(newArrivals[i]['PROId']),
                    favorite: ()async=> await _addOrDeleteWishlist(newArrivals[i]['PROId']),
                    starRate: double.parse(newArrivals[i]['rating'].toString()),
                  );
                },
              )
          ),
        ],
      )
    );
  }

  _fiveTapCard(curve, homeSectoin8){
    sectionContainer(image, text, curve){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/4.5,
        decoration: BoxDecoration(image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: curve),
            color: MyColors.white.withOpacity(0.7),
              child: MyWidget(context).bodyText1(text, scale: 1.4),
          ),
        ),
      );
    }
    return Padding(
        padding: EdgeInsets.all(curve),
        child: Column(
            children:[
              sectionContainer(homeSectoin8[0]['ImageUrl'], getProduct_name(homeSectoin8[0]), curve),
              SizedBox(height: curve/2,),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: sectionContainer(homeSectoin8[1]['ImageUrl'], getProduct_name(homeSectoin8[1]), curve),
                  ),
                  SizedBox(width: curve/2,),
                  Flexible(
                    flex: 1,
                    child: sectionContainer(homeSectoin8[2]['ImageUrl'], getProduct_name(homeSectoin8[2]), curve),
                  ),
                ],
              ),
              SizedBox(height: curve/2,),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: sectionContainer(homeSectoin8[3]['ImageUrl'], getProduct_name(homeSectoin8[3]), curve),
                  ),
                  SizedBox(width: curve/2,),
                  Flexible(
                    flex: 1,
                    child: sectionContainer(homeSectoin8[4]['ImageUrl'], getProduct_name(homeSectoin8[4]), curve),
                  ),
                ],
              ),
            ]
        )
    );
  }

  _swiper(){
    return
    Container(
      height: MediaQuery.of(context).size.height/4,
      child:
      Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
             child: Image.network(
            homeSection9List[index]['ImageUrl'],
            fit: BoxFit.fill,
          ),
            onTap: ()=>_selectPro(homeSection9List[index]['PROId']),
          );
        },
        indicatorLayout: PageIndicatorLayout.SCALE,
        autoplay: true,
        autoplayDelay: 5000,
        itemCount: homeSection9List.length,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
        fade: 1.0,
        viewportFraction: 0.85,
      ) ,
    );
  }

  _stairingGridCard(curve){
    column(index){
      return GestureDetector(
        onTap: ()=> _selectPro(homeSection11List[index]['PROId']),
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(curve)),
            child: Image.network(
              homeSection11List[index]['photoUrls'],
              fit: BoxFit.cover,
            ),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyWidget(context).headText('...', color: MyColors.mainColor, scale: 1, paddingH: 0.0, paddingV: 0.0),
              Expanded(child: SizedBox(width: curve,)),
              MyWidget(context).bodyText1(getProduct_name(homeSection11List[index]), color: MyColors.mainColor, align: TextAlign.end, padding: 5.0),
            ],
          )
        ],
      ),
      );
      
    }
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: curve*1.5),
                child: Column(
                  children: [
                    column(0),
                    SizedBox(height: curve,),
                    column(2),
                  ],
                ),
              )),

          SizedBox(width: curve,),
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  column(1),
                  SizedBox(height: curve,),
                  column(3),
                ],
              ),
          ),
        ],
      ),
    );
  }
/*
  _mostPopulars(){
    List mostPopular = mostPopularList.where((element) => true).toList();
    var hight = MediaQuery.of(context).size.width/1.5;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      color: MyColors.white,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80),
      child: Column(
        children: [
          Row(
            children: [
              _m!.bodyText1(AppLocalizations.of(context)!.translate('The Most Popular')),
              Expanded(child: SizedBox()),
              _m!.bodyText1(AppLocalizations.of(context)!.translate('View All')),
            ],
          ),
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: mostPopular.length,
                itemBuilder: (BuildContext context, int i) {
                  return _m!.cardMain(height: hight-MediaQuery.of(context).size.width/8, sale: 20, select: ()=> _select(i));
                },
              )
          ),

        ],
      )
    );

  }
*/
 
  _shopNow(){
    List shopNow = homeSection4List.where((element) => true).toList();
    var pad = MediaQuery.of(context).size.height/80;
    var hight = MediaQuery.of(context).size.width/2.5 + pad * 2;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      //color: MyColors.white,
      margin: EdgeInsets.symmetric(vertical: pad),
      child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: shopNow.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: ()=> null,
                    child: _m!.cardShopNow(height: hight,
                        image: shopNow[i]['ImageUrl'],
                      name: getProductName(getProduct(shopNow[i]['PROId'])),
                      supName: '',
                      select: ()=> _select(getProduct(shopNow[i]['PROId'])),
                    ),
                  );
                },
              )
    );

  }

  _clickHeader(num) async{
    setState((){
      pleaseWait =true;
      _categoryNum = num;
    });
    if(num !=0) {await MyAPI(context: context).getSubCategories(token, num);
    _subCategoryList.clear();
    _subCategoryList.add({'text':AppLocalizations.of(context)!.translate('All')});
    for(int i=0; i< subCategoryList.length; i++) {
      _subCategoryList.add(subCategoryList[i]);
    }
    }
    else _main = true;
    setState((){
      pleaseWait =false;
      _categoryNum = num;
      _subCategorySelectNum = 0;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.length==1) break;
        if(_subCategorySelectNum == 0 && productList[i]['CATId'].toString()==_categoryNum.toString()){
          _internalProduct.add(productList[i]);
        }
        else if(productList[i]['CATId'].toString()==_categoryNum.toString() && productList[i]['SCId'].toString()==_subCategoryList[_subCategorySelectNum]['SCId'].toString()){
          _internalProduct.add(productList[i]);
        }
        /*if(homeNotCategory){
          if(productList[i]['CATId'].toString() == _categoryNum.toString()){
            _internalProduct.add(productList[i]);
          }
        }else{
          if(productList[i]['CATId'].toString() == _categoryNum.toString() && productList[i]['SCId'].toString() == _subCategoryList[_subCategorySelectNum]['SCId'].toString()){
            _internalProduct.add(productList[i]);
          }
        }*/
      }
    });

  }

  _select(i){
    //print(i.toString());
    if(i['items'].isEmpty){
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Items is empty in this product'));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProductDetails(i)
      ),);
  }

  _selectPro(prdId){
    //print(i.toString());
    var i = productList[productList.indexWhere((element) => element['PROId'] == prdId)];
    if(i['items'].isEmpty){
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Items is empty in this product'));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProductDetails(i)
      ),);
  }

  var _subCategorySelectNum = 0;
  _category(){
    return Row(
      children: [
        Container(
          color: MyColors.white,
          width: MediaQuery.of(context).size.width/7*2,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: _subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _m!.headText(index==0?_subCategoryList[index]['text']:lng == 0?_subCategoryList[index]['name_en']:_subCategoryList[index]['name_ar'], color: index == _subCategorySelectNum? MyColors.novelBlue:MyColors.bodyText1, paddingV: MediaQuery.of(context).size.height/100, scale: 0.75, paddingH: MediaQuery.of(context).size.width/30),
                ),
                onTap: ()=> _selectCategory(index),
              );
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/7*5,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: _internalProduct.length,
            itemBuilder: (BuildContext context, int index) {
              return _m!.cardMainHorizental(height: MediaQuery.of(context).size.width/2.99,
                  name: getProductName(_internalProduct[index]),
                  starRate: double.parse(_internalProduct[index]['rating'].toString()),
                  price: double.parse(_internalProduct[index]['price'].toString()),
                  sale: int.parse(_internalProduct[index]['discount'].toString()),
                  image: _internalProduct[index]['photoUrls'][0]['name'],
                  select: ()=> _select(_internalProduct[index]),
                favoraite: getIfFavorite(_internalProduct[index]['PROId']),
                favorite: ()async=> await _addOrDeleteWishlist(_internalProduct[index]['PROId'])
              );
            },
          ),
        ),
      ],
    );
  }

  _selectCategory(i) {
    setState((){
      _subCategorySelectNum = i;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.length==1) break;
        if(_subCategorySelectNum == 0 && productList[i]['CATId'].toString()==_categoryNum.toString()){
          _internalProduct.add(productList[i]);
        }
        else if(productList[i]['CATId'].toString()==_categoryNum.toString() && productList[i]['SCId'].toString()==_subCategoryList[_subCategorySelectNum]['SCId'].toString()){
          _internalProduct.add(productList[i]);
        }
      }
    });
  }

  _addToWishlist(productId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).addWishlist(token: token, productId: productId);
    setState(() {
      pleaseWait = false;
    });
  }

  _deleteWishlist(productId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).deleteWishlist(token: token, productId: productId);
    setState(() {
      pleaseWait = false;
    });
  }

  _addOrDeleteWishlist(productId) async{
    if(!getIfFavorite(productId)){
      await _addToWishlist(productId);
    }
    else{
      await _deleteWishlist(productId);
    }
  }

  _onRefresh() async{
    await Future.wait([
      MyAPI(context: context).getHomeSection1(),
      MyAPI(context: context).getHomeSection2(),
      MyAPI(context: context).getHomeSection3(),
      MyAPI(context: context).getHomeSection4(),
      MyAPI(context: context).getHomeSection5(),
      MyAPI(context: context).getHomeSection6(),
      MyAPI(context: context).getHomeSection7(),
      MyAPI(context: context).getHomeSection8(),
      MyAPI(context: context).getHomeSection9(),
      MyAPI(context: context).getHomeSection10(),
      MyAPI(context: context).getHomeSection11(),
    MyAPI(context: context).getProducts(),
    MyAPI(context: context).getCategories(),
    MyAPI(context: context).getBrands(),
    MyAPI(context: context).getShopCartGuest(),
    MyAPI(context: context).getCurrency(),
    ]);
    setState(() {

    });
  }

  _setState(){
    setState((){
      pleaseWait =false;
      _subCategorySelectNum = 0;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.isEmpty) break;
        if(homeNotCategory){
          if(productList[i]['CATId'].toString() == _categoryNum.toString()){
            _internalProduct.add(productList[i]);
          }
        }else{
          if(productList[i]['CATId'].toString() == _categoryNum.toString() && productList[i]['SCId'].toString() == _subCategoryList[_subCategorySelectNum]['SCId'].toString()){
            _internalProduct.add(productList[i]);
          }
        }
      }
    });
  }

  _containerText(color, text){
    var pad = MediaQuery.of(context).size.width/60;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(pad)),
          color: MyColors.white,
          border: Border.all(color: color == MyColors.mainColor? color: MyColors.bodyText1),
        ),
        padding: EdgeInsets.all(pad),
        margin: EdgeInsets.symmetric(horizontal: pad/2),
        child: _m!.bodyText1(text, padV: 0.0,padding: 0.0, color: color),
      ),
    );
  }

}