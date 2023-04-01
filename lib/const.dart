//import 'boxes.dart';
//import 'model/transaction.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';

//import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'boxes.dart';
import 'model/transaction.dart';
import 'package:url_launcher/url_launcher.dart';
var categoryNum = 1;
var subCategorySelectNum = 0;
var maxPrice = 0.0;
bool highToLowPriceFilter = false;
bool highToLowRateFilter = false;
bool guestType = false;
bool filter = false;
List ordersList = [];
List productList = [];
List categoryList = [];
List subCategoryList = [];
List salesList = [];
List brandsList = [1,2,3];
List shippingMethodsList = [1,2,3];
List homeSection4List = [1,2,3,4];
List homeSection2List = [1,2,3,4];
List homeSection1List = [1,2,3];
List homeSection3List = [1,2,3];
List homeSection5List = [1,2,3];
List homeSection6List = [1,2,3];
List homeSection7List = [1,2,3];
List homeSection8List = [1,2,3];
List homeSection9List = [1,2,3];
List homeSection10List = [1,2,3];
List homeSection11List = [1,2,3];
List cartList = [];
Map<String,dynamic> cartListTotal = {};
List wishList = [];
List myAddress = [{'sale': 0}, {'sale': 20}, {'sale': 40}];
var selectedAddress=0;
List countries = [];
List currency = [];
Map<String,dynamic> currencyValue = {};//{"CurId": "5", "CurName": "Emirati Dirham", "CurShortname": "AED", "CurMark": "AED", "CurValue": "1"};
List paymentCard = [];
bool notificationAndEmail = false;
Map userData = {};
Map userInfo = {'email': 'omar.suhail.hasan@gmail.com','name': 'Omar Hasan', 'image': 'assets/images/Logo1.png', 'mobile': '+963 0938025347', 'city' : 'Syria', 'aboutYou': 'aboutYou'};
var lng = 0;
var bottomConRatio = 0.0;
var lastOrderCheckout;
bool pleaseWait = false;
bool thereNotification = false;
bool loading = false;
bool homeNotCategory = true;

//PDFDocument doc = new PDFDocument();

var timeDiff = const Duration(seconds: 0);

var token = '';


getFromApi(bool guest, context) async{
  if(!guest){
    await Future.wait([
        MyAPI(context: context).getProducts(),
        MyAPI(context: context).getCategories(),
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
    MyAPI(context: context).getWishlist(token),
    MyAPI(context: context).getShopCart(token),
    MyAPI(context: context).getPaymentMethod(token),
    MyAPI(context: context).getCurrency(),
    MyAPI(context: context).getShippingMethods(),
    MyAPI(context: context).getBrands(),
    MyAPI(context: context).getUserCountries(userData['token']),
    MyAPI(context: context).getUserAddress(userData['token']),
    ]);

  }
  else{
    await Future.wait([
    MyAPI(context: context).getProducts(),
    MyAPI(context: context).getCategories(),
    MyAPI(context: context).getBrands(),
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
      MyAPI(context: context).getShopCartGuest(),
    MyAPI(context: context).getCurrency(),
    ]);

  }
}

getIfFavorite(productId){
  bool tt = false;
  for(int i = 0; i < wishList.length; i++){
    if(wishList[i]['PROId'].toString()==productId.toString()){
      i = wishList.length;
      tt = true;
    }

  }
  return tt;
}
/*
changeProductPrice(List _productList){
  for(int i=0; i<_productList.length; i++){
    _productList[i]['price'] = (double.parse(_productList[i]['price'].toString()) * double.parse(currencyValue['CurValue'].toString())).toString();
  }
}
*/

getPriceFit(price, sale){
  var t = ((price - price * sale/100) * double.parse(currencyValue['CurValue'].toString())).toString()
      .substring(0,min(6,
      ((price - price * sale/100) * double.parse(currencyValue['CurValue'].toString())).toString().length));
  return t;
}

getProduct(productId){
  return productList[productList.indexWhere((element) => element['PROId'].toString() == productId.toString())];
}

getCategoryName(i){
  var name ='';
  lng == 0? name = categoryList[i]['name_en'] : name = categoryList[i]['name_ar'];
  return name;
}

getBrandName(brandId){
  var name ='';
  lng == 0? name = brandsList[brandsList.indexWhere((element) => element['brandId'].toString()==brandId.toString())]['name_en'] : name = brandsList[brandsList.indexWhere((element) => element['brandId'].toString()==brandId.toString())]['name_ar'];
  return name;
}

getProductTitle(product){
  var name ='';
  lng == 0? name = product['Title_en'] :lng == 1? name = product['Title_fr'] : name = product['Title_ar'];
  return name;
}

getProductName(product){
  var name ='';
  lng == 0? name = product['Name_en'] :lng == 1? name = product['Name_fr'] : name = product['Name_ar'];
  return name;
}

getProduct_name(product){
  var name ='';
  lng == 0? name = product['name_en'] :lng == 1? name = product['name_fr'] : name = product['name_ar'];
  return name;
}

getProductDesc(product){
  var name ='';
  lng == 0? name = product['Description_en']: lng==1? name = product['Description_fr'] : name = product['Description_ar'];
  return name;
}

getProduct_desc(product){
  var name ='';
  lng == 0? name = product['description_en']: lng==1? name = product['description_fr'] : name = product['description_ar'];
  return name;
}

animateList(_scrollController) async {
  _scrolTo(){
    return Timer(const Duration(milliseconds: 1000), ()=> { _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn),
    });
  }
  var duration = const Duration(milliseconds: 200);
  return Timer(duration, ()=> {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn),
    _scrolTo(),
  });
}

/*List<Transaction>? transactions;

Future addTransaction(farms, spare1, spare2, spare3) async {
  final transaction = Transaction()
    ..farms = farms
    ..spare1 = spare1
    ..spare2 = spare2
    ..spare3 = spare3
   ;

  final box = Boxes.getTransactions();
  box.add(transaction);
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransactionFarms(Transaction transaction, farms) async{
  try{
    transaction.farms = farms;
    transaction.save();
  }catch(e){
    await addTransaction([], [], [], []);
    transactions![0].farms = farms;
    transactions![0].save();
  }
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);
  transaction.delete();
  //setState(() => transactions.remove(transaction));
}

backMethod() async{
  //refresh farms
  for(int i=0; i<myFarms.length; i++){
    myFarms[i]['Age'] = myFarms[i]['StartDate'] + DateTime.now().difference(myFarms[i]['InsertDate']).inDays;
  }
  //chickenNotification
  for(int i=0; i<myFarms.length; i++){
    if(myFarms[i]['Type'] == 3){
    }
  }
}
*/
intParse(text){
  var rrr = 0.0;
  try{
    rrr = double.parse(text);
  }catch(e){
    rrr = 0.0;
  }
  return rrr;
}

List<Transaction>? transactions;

Future addTransaction() async {
  final transaction = Transaction()
  ..guestType = guestType
  ..ordersList = ordersList
  ..productList = productList
  ..categoryList = categoryList
  ..subCategoryList = subCategoryList
  ..salesList = salesList
  ..brandsList = brandsList
  ..shippingMethodsList = shippingMethodsList
  ..shopNowList = homeSection4List
  ..newArrivalList = homeSection2List
  ..homeSection1List = homeSection1List
  ..cartList = cartList
  ..cartListTotal = cartListTotal
  ..wishList = wishList
  ..myAddress = myAddress
  ..selectedAddress = selectedAddress
  ..countries = countries
  ..currency = currency
  ..currencyValue = currencyValue
  ..paymentCard = paymentCard
  ..notificationAndEmail = notificationAndEmail
  ..userData = userData
  ..userInfo = userInfo
  ;

  final box = Boxes.getTransactions();
  await box.add(transaction);
  transactions = box.values.toList();
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransactionUserData() async{
  try{
    transactions![0].userData = userData;
  }catch(e){
    await addTransaction();
    transactions![0].userData = userData;
  }
  transactions![0].save();
}

editTransactionUserInfo() async{
  try{
    transactions![0].userInfo = userInfo;
  }catch(e){
    await addTransaction();
    transactions![0].userInfo = userInfo;
  }
  transactions![0].save();
}

void editTransactionGuestType() async{
  try{
    transactions![0].guestType = guestType;
  }catch(e){
    await addTransaction();
    transactions![0].guestType = guestType;
  }
  transactions![0].save();
}

void editTransactionOrderList() async{
  try{
    transactions![0].ordersList = ordersList;
  }catch(e){
    await addTransaction();
    transactions![0].ordersList = ordersList;
  }
  transactions![0].save();
}

void editTransactionProductList() async{
  try{
    transactions![0].productList = productList;
  }catch(e){
    await addTransaction();
    transactions![0].productList = productList;
  }
  transactions![0].save();
}

void editTransactionCategory() async{
  try{
    transactions![0].categoryList = categoryList;
  }catch(e){
    await addTransaction();
    transactions![0].categoryList = categoryList;
  }
  transactions![0].save();
}

void editTransactionSubCategory() async{
  try{
    transactions![0].subCategoryList = subCategoryList;
  }catch(e){
    await addTransaction();
    transactions![0].subCategoryList = subCategoryList;
  }
  transactions![0].save();
}

void editTransactionSalesList() async{
  try{
    transactions![0].salesList = salesList;
  }catch(e){
    await addTransaction();
    transactions![0].salesList = salesList;
  }
  transactions![0].save();
}

void editTransactionBrandList() async{
  try{
    transactions![0].brandsList = brandsList;
  }catch(e){
    await addTransaction();
    transactions![0].brandsList = brandsList;
  }
  transactions![0].save();
}

void editTransactionShippingMethodList() async{
  try{
    transactions![0].shippingMethodsList = shippingMethodsList;
  }catch(e){
    await addTransaction();
    transactions![0].shippingMethodsList = shippingMethodsList;
  }
  transactions![0].save();
}

void editTransactionShopNow() async{
  try{
    transactions![0].shopNowList = homeSection4List;
  }catch(e){
    await addTransaction();
    transactions![0].shopNowList = homeSection4List;
  }
  transactions![0].save();
}

void editTransactionNewArrivales() async{
  try{
    transactions![0].newArrivalList = homeSection2List;
  }catch(e){
    await addTransaction();
    transactions![0].newArrivalList = homeSection2List;
  }
  transactions![0].save();
}

void editTransactionHomeSection() async{
  try{
    transactions![0].homeSection1List = homeSection1List;
  }catch(e){
    await addTransaction();
    transactions![0].homeSection1List = homeSection1List;
  }
  transactions![0].save();
}

void editTransactionCartList() async{
  try{
    transactions![0].cartList = cartList;
  }catch(e){
    await addTransaction();
    transactions![0].cartList = cartList;
  }
  transactions![0].save();
}

void editTransactionCartListTotal() async{
  try{
    transactions![0].cartListTotal = cartListTotal;
  }catch(e){
    await addTransaction();
    transactions![0].cartListTotal = cartListTotal;
  }
  transactions![0].save();
}

void editTransactionWishlist() async{
  try{
    transactions![0].wishList = wishList;
  }catch(e){
    await addTransaction();
    transactions![0].wishList = wishList;
  }
  transactions![0].save();
}

void editTransactionMyAddress() async{
  try{
    transactions![0].myAddress = myAddress;
  }catch(e){
    await addTransaction();
    transactions![0].myAddress = myAddress;
  }
  transactions![0].save();
}

void editTransactionSelectedAddress() async{
  try{
    transactions![0].selectedAddress = selectedAddress;
  }catch(e){
    await addTransaction();
    transactions![0].selectedAddress = selectedAddress;
  }
  transactions![0].save();
}

void editTransactionCountries() async{
  try{
    transactions![0].countries = countries;
  }catch(e){
    await addTransaction();
    transactions![0].countries = countries;
  }
  transactions![0].save();
}

void editTransactionCurrency() async{
  try{
    transactions![0].currency = currency;
  }catch(e){
    await addTransaction();
    transactions![0].currency = currency;
  }
  transactions![0].save();
}

void editTransactionCurrencyVale() async{
  try{
    transactions![0].currencyValue = currencyValue;
  }catch(e){
    await addTransaction();
    transactions![0].currencyValue = currencyValue;
  }
  transactions![0].save();
}

void editTransactionPaymentCard() async{
  try{
    transactions![0].paymentCard = paymentCard;
  }catch(e){
    await addTransaction();
    transactions![0].paymentCard = paymentCard;
  }
  transactions![0].save();
}

void editTransactionNoteficationAndEmail() async{
  try{
    transactions![0].notificationAndEmail = notificationAndEmail;
  }catch(e){
    await addTransaction();
    transactions![0].notificationAndEmail = notificationAndEmail;
  }
  transactions![0].save();
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);
  transaction.delete();
  //setState(() => transactions.remove(transaction));
}
