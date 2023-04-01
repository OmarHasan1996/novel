import 'package:novel/api.dart';
import 'package:novel/screen/productDetails.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
import 'package:novel/screen/subbmitOrder.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'mainScreen.dart';
class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(paymentCard.isNotEmpty){
      _cardNameController.text = paymentCard[0]['name'];
      _cardNumController.text = paymentCard[0]['cardNumber'];
      _cardCVVController.text = paymentCard[0]['securityCode'];
      _cardDateController.text = paymentCard[0]['expirationDate'];
    }
    _cardNameController.addListener(() {setState(() {});});
    _cardNumController.addListener(() {setState(() {});});
    _cardCVVController.addListener(() {setState(() {});});
    _cardDateController.addListener(() {setState(() {});});
  }

  TextEditingController _messageController = TextEditingController();
  TextEditingController _cardNameController= new TextEditingController();
  TextEditingController _cardNumController= new TextEditingController();
  TextEditingController _cardDateController= new TextEditingController();
  TextEditingController _cardCVVController= new TextEditingController();
  TextEditingController _cardNameControllerDipet = new TextEditingController();
  TextEditingController _cardNumControllerDipet= new TextEditingController();
  TextEditingController _cardDateControllerDipet = new TextEditingController();
  TextEditingController _cardCVVControllerDipet= new TextEditingController();
  TextEditingController _cardNameControllerCridet = new TextEditingController();
  TextEditingController _cardNumControllerCridet= new TextEditingController();
  TextEditingController _cardDateControllerCridet = new TextEditingController();
  TextEditingController _cardCVVControllerCridet= new TextEditingController();
  TextEditingController _cardNameControllerUPI = new TextEditingController();
  TextEditingController _cardNumControllerUPI= new TextEditingController();
  TextEditingController _cardDateControllerUPI = new TextEditingController();
  TextEditingController _cardCVVControllerUPI= new TextEditingController();
  MyWidget? _m;

  //card : 0, cash : 4
  var _selectCard = 0;
  var _openCard = 0;
  var _error = false;
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
                          _m!.returnIcon(color: MyColors.white),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Payment Methods'), padding: 0.0, color: MyColors.white, scale: 1.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 30,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //_rowCard(curve, AppLocalizations.of(context)!.translate('Debit Card'), 1, _cardNameControllerDipet, _cardNumControllerDipet, _cardCVVControllerDipet, _cardDateControllerDipet),
                    //_rowCard(curve, AppLocalizations.of(context)!.translate('Credit Card'), 2, _cardNameControllerCridet, _cardNumControllerCridet, _cardCVVControllerCridet, _cardDateControllerCridet),
                    //_rowCard(curve, AppLocalizations.of(context)!.translate('UPI'), 3, _cardNameControllerUPI, _cardNumControllerUPI, _cardCVVControllerUPI, _cardDateControllerUPI),
                    _rowCard(curve, AppLocalizations.of(context)!.translate('Card Information'), 0, _cardNameController, _cardNumController, _cardCVVController, _cardDateController),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: curve/2),
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(curve/4))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: ()=> slectCard(4),
                                icon: SvgPicture.asset('assets/images/point.svg', color: _selectCard == 4? MyColors.novelBlue: MyColors.card,),),
                              Expanded(
                                child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Cash On Delivery'), scale: 1.2, align: TextAlign.start, padding: 0.0, color: MyColors.black),
                              ),
                            ],

                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: curve,)
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
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, paymentCard.isEmpty?AppLocalizations.of(context)!.translate('Save Card'):AppLocalizations.of(context)!.translate('Update Card'), null, ()=> _save(), color: MyColors.mainColor),
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

  _rowCard(curve, head, num, _cardName, _cardNum, _cardCVV, _cardDate){
    bool select = false;
    bool open = false;
    if(_selectCard == num) select = true;
    if(_openCard == num) open = true;
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: curve/2),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/2),
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.all(Radius.circular(curve/4))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: ()=> slectCard(num),
                icon: SvgPicture.asset('assets/images/point.svg', color: select? MyColors.novelBlue: MyColors.card,),),
              Expanded(
                  child: _m!.bodyText1(head, scale: 1.2, align: TextAlign.start, padding: 0.0, color: MyColors.black),
              ),
              IconButton(
                  onPressed: ()=> openCard(num),
                  icon: Icon(open?Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined))
            ],
          ),
          open? Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: curve/2),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15*0, vertical: curve/4),
            decoration: BoxDecoration(
                color: MyColors.metal,
                borderRadius: BorderRadius.all(Radius.circular(curve/4)),
                border: Border.all(color: _error && _cardName.text.toString().isEmpty?MyColors.red:MyColors.metal),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _m!.bodyText1(AppLocalizations.of(context)!.translate('Name On Card'), align: TextAlign.start, padding: 0.0),
                TextField(
                  maxLines: 1,
                  //validator: requiredValidator,
                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: _cardName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/22,
                      color: MyColors.gray,
                      fontFamily: 'SairaMedium'),
                  //textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //labelText: titleText,
                    //hintText: AppLocalizations.of(context)!.translate('Type your message'),
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/25,
                        color: MyColors.bodyText1,
                        fontFamily: 'SairaLight'),
                    errorStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/2400,
                    ),
                  ),

                ),
              ],
            ),
          ):SizedBox(),
          open? Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: curve/2),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15*0, vertical: curve/4),
            decoration: BoxDecoration(
                color: MyColors.metal,
                borderRadius: BorderRadius.all(Radius.circular(curve/4)),
              border: Border.all(color: _error && _cardNum.text.toString().isEmpty?MyColors.red:MyColors.metal),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _m!.bodyText1(AppLocalizations.of(context)!.translate('Card Number'), align: TextAlign.start, padding: 0.0),
                TextField(
                  maxLines: 1,
                  //validator: requiredValidator,
                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(19),
                    // ignore: deprecated_member_use
                    //WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onChanged: (k){
                   {
                      k = k.replaceAll(' ', '');
                      k = k.replaceAll('  ', '');
                      k = k.replaceAll('   ', '');
                      List siplt = [];
                      for(int i = 4; i < k.length; i++){
                        if(i % 4 == 0){
                          siplt.add(k.substring(i-4,i));
                        }
                      }
                      for(int i = 0; i < siplt.length; i++){
                        k = k.replaceRange(i*5, i*5+4, siplt[i] + ' ');
                      }
                      _cardNumController.text = k;
                      _cardNumController.selection = TextSelection.fromPosition(TextPosition(offset: _cardNumController.text.length));
                      print(k);
                    }
                    //controller.text=k;
                  },
                  keyboardType: TextInputType.number,
                  controller: _cardNum,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/22,
                      color: MyColors.gray,
                      fontFamily: 'SairaMedium'),
                  //textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    //labelText: titleText,
                    //hintText: AppLocalizations.of(context)!.translate('Type your message'),
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/25,
                        color: MyColors.bodyText1,
                        fontFamily: 'SairaLight'),
                    errorStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/2400,
                    ),
                  ),

                ),
              ],
            ),
          ):SizedBox(),
          open? Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: curve/2),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15*0, vertical: curve/4),
            decoration: BoxDecoration(
                color: MyColors.metal,
                borderRadius: BorderRadius.all(Radius.circular(curve/4)),
              border: Border.all(color: _error && _cardCVV.text.toString().isEmpty?MyColors.red:MyColors.metal),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _m!.bodyText1(AppLocalizations.of(context)!.translate('CVV Code'), align: TextAlign.start, padding: 0.0),
                TextField(
                  maxLines: 1,
                  //validator: requiredValidator,
                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controller: _cardCVV,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/22,
                      color: MyColors.gray,
                      fontFamily: 'SairaMedium'),
                  //textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    //labelText: titleText,
                    //hintText: AppLocalizations.of(context)!.translate('Type your message'),
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/25,
                        color: MyColors.bodyText1,
                        fontFamily: 'SairaLight'),
                    errorStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/2400,
                    ),
                  ),
                ),
              ],
            ),
          ):SizedBox(),
          open? Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: curve/2),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15*0, vertical: curve/4),
            decoration: BoxDecoration(
                color: MyColors.metal,
                borderRadius: BorderRadius.all(Radius.circular(curve/4)),
              border: Border.all(color: _error && _cardCVV.text.toString().isEmpty?MyColors.red:MyColors.metal),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _m!.bodyText1(AppLocalizations.of(context)!.translate('Exp Date'), align: TextAlign.start, padding: 0.0),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: TextFormField(
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
                    //textAlign: TextAlign.left,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _cardDateController,
                    onSaved: (String?val) {/*_setDate = val;*/},
                    decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.only(top: 0.0)),
                  ),
                ),
                /*TextField(
                  maxLines: 1,
                  //validator: requiredValidator,
                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: _cardDate,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/22,
                      color: MyColors.gray,
                      fontFamily: 'SairaMedium'),
                  //textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    //labelText: titleText,
                    //hintText: AppLocalizations.of(context)!.translate('Type your message'),
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/25,
                        color: MyColors.bodyText1,
                        fontFamily: 'SairaLight'),
                    errorStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/2400,
                    ),
                  ),

                ),*/
              ],
            ),
          ):SizedBox(),
        ],
      ),
    );
  }

  DateTime? selectedDate = DateTime.now();


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate as DateTime,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null)

      setState(() {
        selectedDate = picked;
        print("this is the Date");
        //print(selectedDate.toString().split(' ')[0].split('-')[0].substring(2) + '-' + selectedDate.toString().split(' ')[0].split('-')[1]);
        print(selectedDate);
        print("timeZone");
        print(DateTime.now().timeZoneName);
        print(DateTime.now().timeZoneOffset);
        //_dateController.text = DateFormat.yMMMM().format(selectedDate as DateTime);
        _cardDateController.text = selectedDate.toString().split(' ')[0].split('-')[0].substring(2) + ' / ' + selectedDate.toString().split(' ')[0].split('-')[1];
      });
  }

  slectCard(num) {
    setState((){
      _selectCard = num;
    });
  }

  openCard(num) {
    setState((){
      if(_openCard == num) _openCard = 10000;
      else _openCard = num;
    });
  }

  _save() async{
    if(_cardNumController.text.isEmpty || _cardNameController.text.isEmpty || _cardCVVController.text.isEmpty || _cardDateController.text.isEmpty){
      setState(() {
        _error = true;
      });
      return;
    }
    setState(() {
      pleaseWait = true;
    });

    if(paymentCard.isEmpty) await MyAPI(context: context).createPaymentMethod(token: token, name: _cardNameController.text, cardNum: _cardNumController.text, securityCode: _cardCVVController.text, expDate: _cardDateController.text);
    else await MyAPI(context: context).updatePaymentMethod(pcId: paymentCard[0]['PCId'],token: token, name: _cardNameController.text, cardNum: _cardNumController.text, securityCode: _cardCVVController.text, expDate: _cardDateController.text);

    setState(() {
      pleaseWait = false;
    });

  }

}
