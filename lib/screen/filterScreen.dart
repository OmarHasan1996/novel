import 'dart:math';

import 'package:novel/MyWidget.dart';
import 'package:novel/color/MyColors.dart';
import 'package:novel/localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_balloon_slider/flutter_balloon_slider.dart';
import '../api.dart';
import '../const.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  var _maxPrice = 0.0, _minPrice = 0.0;

  late MyWidget _m;
  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: initScreen(context),
      backgroundColor: MyColors.gray,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topHeader.clear();
    for(int i=0; i< categoryList.length; i++){
      topHeader.add({'text': getCategoryName(i), "click": ()async=> await _clickHeader(categoryList[i]['CATId '])});
    }
    List ccc = productList.where((element) => true).toList();
    ccc.sort((a, b) {
      return a['price'].toString().toLowerCase().compareTo(b['price'].toString().toLowerCase());
    });
    _minPrice = double.parse(ccc.first['price']);
    _maxPrice = double.parse(ccc.last['price']);
    maxPrice = _maxPrice;
    _clickHeader(categoryNum);
  }
  var topHeader = [];
  initScreen(BuildContext context) {

    var c = MediaQuery.of(context).size.width/10;
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.width/10,),
        Container(
          padding: EdgeInsets.symmetric(vertical: c/2, horizontal: c),
          height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.width/10,
          decoration: BoxDecoration(
            color: MyColors.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(c),
                topRight: Radius.circular(c),
              )
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
          children: [
            CloseButton(),
            _m.bodyText1(AppLocalizations.of(context)!.translate('Filter'), scale: 1.2),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: ()=> _clear(),
              child: _m.bodyText1(AppLocalizations.of(context)!.translate('Clear'), scale: 1.2, color: MyColors.novelBlue),
            ),
          ],
        ),
                Container(
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.width/10-MediaQuery.of(context).size.width/2.5,
                  child:
                      SingleChildScrollView(
                        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width/20,
        ),
        _m.headText(AppLocalizations.of(context)!.translate('Section')),
        SizedBox(
          height: MediaQuery.of(context).size.width/10,
          child: _horisintalListHeader(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width/40,
        ),
        _m.headText(AppLocalizations.of(context)!.translate('categories')),
        _category(),
        SizedBox(
          height: MediaQuery.of(context).size.width/40,
        ),
        _m.headText(AppLocalizations.of(context)!.translate('Price')),
        _price(),
        _m.headText(AppLocalizations.of(context)!.translate('Rating')),
        _rate(),
      ],
    ),
                      ),
                ),
                _m.raisedButton(MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Search'), null, ()=>_search()),
              ],
            ),
          ),
      ],
    );
  }

  _horisintalListHeader(){
    return ListView.builder(
      padding: EdgeInsets.all(0.1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: topHeader.length,
      itemBuilder: (BuildContext context, int i) {
        return GestureDetector(
          onTap: ()async=> await topHeader[i]['click'],
          child: _m.bodyText1(topHeader[i]['text'], color: categoryNum == i+1 ? MyColors.novelBlue : MyColors.card, scale: 1.3, padding: MediaQuery.of(context).size.width/35, padV: 0.0),
        );
      },
    );
  }

  _clickHeader(num) async{
    setState((){
      pleaseWait =true;
      categoryNum = num;
    });
    await MyAPI(context: context).getSubCategories(token, num);
    setState((){
      pleaseWait =false;
      categoryNum = num;
      subCategorySelectNum = 0;
    });

  }

  _category(){
    if(pleaseWait){
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
      return SizedBox(
        height: min(MediaQuery.of(context).size.width/7 * subCategoryList.length,MediaQuery.of(context).size.height/3.7),
        child: Container(
          color: MyColors.white,
          //width: MediaQuery.of(context).size.width/2,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return
                Row(
                  children: [
                    Checkbox(
                      value: index == subCategorySelectNum? true:false,
                      onChanged: (value) {_selectSubCategory(index);},
                      activeColor: MyColors.novelBlue,
                      checkColor: MyColors.white,
                      //checkColor: MyColors.orange,
                    ),
                    _m.headText(lng == 0?subCategoryList[index]['name_en']:subCategoryList[index]['name_ar'], color: index == subCategorySelectNum? MyColors.novelBlue:MyColors.bodyText1,
                        paddingV: MediaQuery.of(context).size.height/100,
                        scale: 0.75,
                        paddingH: MediaQuery.of(context).size.width/30,
                        align: TextAlign.start),
                  ],
                );
            },
          ),
        ),
      );
    }
  }

  _selectSubCategory(int index) {
    setState(() {
      subCategorySelectNum = index;
    });
  }

  _price(){
    return
    Column(
      children: [
        BalloonSlider(
            value: (maxPrice - _minPrice) / (_maxPrice - _minPrice),
            ropeLength: MediaQuery.of(context).size.width/10,
            showRope: true,
            onChanged: (val) {
              setState(() {
                maxPrice = val * (_maxPrice - _minPrice) + _minPrice;
              });
            },
            color: MyColors.novelBlue
        ),
        _m.bodyText1(maxPrice.toString().substring(0,min(6,maxPrice.toString().length))),
        Row(
          children: [
            Checkbox(
                value: highToLowPriceFilter,
                activeColor: MyColors.novelBlue,
                checkColor: MyColors.white,
                onChanged: (val){
                  setState(() {
                    highToLowPriceFilter = val!;
                  });
                }
            ),
            _m.bodyText1(AppLocalizations.of(context)!.translate('High > Low'))
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: !highToLowPriceFilter,
                activeColor: MyColors.novelBlue,
                checkColor: MyColors.white,
                onChanged: (val){
                  setState(() {
                    highToLowPriceFilter = !val!;
                  });
                }
            ),
            _m.bodyText1(AppLocalizations.of(context)!.translate('Low > High'))
          ],
        ),
      ],
    );
  }

  _rate(){
    return
    Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: highToLowRateFilter,
                activeColor: MyColors.novelBlue,
                checkColor: MyColors.white,
                onChanged: (val){
                  setState(() {
                    highToLowRateFilter = val!;
                  });
                }
            ),
            _m.bodyText1(AppLocalizations.of(context)!.translate('High > Low'))
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: !highToLowRateFilter,
                activeColor: MyColors.novelBlue,
                checkColor: MyColors.white,
                onChanged: (val){
                  setState(() {
                    highToLowRateFilter = !val!;
                  });
                }
            ),
            _m.bodyText1(AppLocalizations.of(context)!.translate('Low > High'))
          ],
        ),
      ],
    );
  }

  _search(){
    filter = true;
    Navigator.of(context).pop();
  }

  _clear(){
    filter = false;
    Navigator.of(context).pop();
  }


}
