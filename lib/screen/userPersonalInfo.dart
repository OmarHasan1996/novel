import 'package:novel/screen/confirmPassword.dart';
import 'package:novel/screen/resetPasswordScreen.dart';
import 'package:novel/screen/signUpScreen.dart';
//import 'package:date_time_picker/date_time_picker.dart';
//import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
class UserPersonalInfo extends StatefulWidget {
  const UserPersonalInfo({Key? key}) : super(key: key);

  @override
  State<UserPersonalInfo> createState() => _UserPersonalInfoState();
}

class _UserPersonalInfoState extends State<UserPersonalInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.addListener(() {setState((){});});
    _lastNameController.addListener(() {setState((){});});
    _phoneNumberController.addListener(() {setState((){});});
    _passwordController.addListener(() {setState((){});});
    _dateOfBearthController.addListener(() {setState((){});});
    _emailController.addListener(() {setState((){});});
  }

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _dateOfBearthController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _ageRangController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;

  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.topGradiant,
          MyColors.white,
          MyColors.topGradiant,
        ],
          transform: GradientRotation(3.14 / 4),),
      ),
      child: Scaffold(
        backgroundColor: MyColors.trans,
        body: initScreen(context),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  var _password = true;

  initScreen(BuildContext context) {
    var curve = MediaQuery.of(context).size.width/20;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: MediaQuery.of(context).size.height/40),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _m!.returnIcon(),
            SizedBox(height: MediaQuery.of(context).size.height/25,),
            /*_m!.comimaniaLogo(),*/
            SizedBox(height: MediaQuery.of(context).size.height/25,),
            _m!.bodyText1(AppLocalizations.of(context)!.translate('Your personal info'), color: MyColors.mainColor, scale: 1.2, padV: MediaQuery.of(context).size.height/40*0, align: TextAlign.start, padding: 0.0),
            Flexible(
              flex: 1,
                child:SingleChildScrollView(
                  child: Column(
                  children: [
                    _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _firstNameController, AppLocalizations.of(context)!.translate('First Name'), Icons.person_outline, error: _error),
                    _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _lastNameController, AppLocalizations.of(context)!.translate('Last Name'), Icons.person_outline, error: _error),
                    _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _emailController, AppLocalizations.of(context)!.translate('E-mail'), Icons.email_outlined, error: _error),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10*0, right: MediaQuery.of(context).size.width/10*0, top:  MediaQuery.of(context).size.width/20),
                      child: IntlPhoneField(
                        //keyboardType: TextInputType.number,
                        //validator: requiredValidator,
                        invalidNumberMessage: '',
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        //controller: phoneController,
                        style: TextStyle(color: MyColors.black, fontSize: MediaQuery.of(context).size.width/20),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.translate('Mobile Number'),
                          hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/25,
                            color: MyColors.gray,
                          ),
                          errorStyle: TextStyle(
                              fontSize:MediaQuery.of(context).size.width/24
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(curve/2),
                              borderSide: BorderSide(color: _error && _phoneNumberController.text.isEmpty?MyColors.red:Colors.grey , width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(curve/2),
                            borderSide:  BorderSide(color: _error && _phoneNumberController.text.isEmpty?MyColors.red:Colors.grey, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(curve/2),
                            borderSide: const BorderSide(color: MyColors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(curve/2),
                            borderSide: const BorderSide(color: MyColors.red, width: 2),
                          ),
                        ),
                        initialCountryCode: WidgetsBinding.instance.window.locale.countryCode,
                        onChanged: (phone) {
                          _phoneNumberController.text =  phone.completeNumber;
                          print(phone.completeNumber);
                        },
                      ),
                      /* buildContainer(phoneController, AppLocalizations.of(context)!.translate('Phone Number'),
                                      TextInputType.number, requiredValidator,false),*/
                    ),
                    //_m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _phoneNumberController, AppLocalizations.of(context)!.translate('Phone number'), !_password? Icons.remove_red_eye_outlined:Icons.phone_outlined, password: _password, click: ()=> _showPassword()),
                    _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _passwordController, AppLocalizations.of(context)!.translate('Password'), !_password? Icons.remove_red_eye_outlined:Icons.remove_red_eye, password: _password, click: ()=> _showPassword(), error: _error),
                    //_datePick(),
                    _m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _dateOfBearthController, AppLocalizations.of(context)!.translate('Date of birth'), Icons.calendar_today, readOnly: true, click: ()=> _datePick(), error: _error),
                    _dropDownAge(),
                    SizedBox(height: MediaQuery.of(context).size.height/60,),
                    _dropDown(),
                    SizedBox(height: MediaQuery.of(context).size.height/60,),
                  ],
                ),
                )
            ),
            MediaQuery.of(context).viewInsets.bottom == 0 ?
            _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Next'), null, ()=> _next(), color: MyColors.mainColor):
            SizedBox(height: MediaQuery.of(context).size.height/100*0,),
            //SizedBox(height: MediaQuery.of(context).size.height/10,),
            //_m!.orDriver(),
          ],
        ),
    );
  }

  signUp() {

  }

  continueAsGuest() {}

  logIn() {}

  _showPassword() {
    setState(() {
      _password = !_password;
    });
  }
/*
  _datePick(){
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime(1996).toString(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      icon: Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      /*selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }

        return true;
      },*/
      onChanged: (val) => _dateOfBearthController.text = val.toString(),
      validator: (val) {
        _dateOfBearthController.text = val.toString();
        print(val);
        return null;
      },
      onSaved: (val) => _dateOfBearthController.text = val.toString().split(' ').first,
    );
  }
*/
  _datePick() async{
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(1996),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      dateFormat: "dd-MM",
      //locale: DateTimePickerLocale.en_us,
      looping: true,
    );
    if (datePicked != null) {
      _dateOfBearthController.text = datePicked.toString().split(' ').first.substring(5);
    }
  }
  final List<String>  _genderName = <String> ['Type1', 'Type2', 'Type3'];
  final List<String>  _ageRange = <String> ['Type1', 'Type2', 'Type3'];
  var _gender = -1;
  String gender = 'gender';

  _maleOrFemale(curve) {
    change(gender){
      setState(() {
        _gender = gender;
      });
    }
    container(bool, text, click()){
      var color = MyColors.card;
      bool? color = MyColors.novelBlue: color = MyColors.card;
      return GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width/2.9,
          height: MediaQuery.of(context).size.width/4,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color, offset: Offset(0, 0),
                blurRadius: 5,
              ),
            ],
            //border: BoxBorder(color),
            color: MyColors.white,
            borderRadius: BorderRadius.all(Radius.circular(curve),),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Column(
            children: [
              Icon(Icons.check_box, color: color,size: MediaQuery.of(context).size.width/10,),
              Expanded(child: SizedBox()),
              _m!.bodyText1(text, color: color, scale: 1.5),
            ],
          ),
        ),
        onTap: ()=> click(),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: [
          container(_gender == 0? true:false, AppLocalizations.of(context)!.translate('Male'), ()=> change(0)),
          Expanded(child: SizedBox()),
          container(_gender == 1? true:false,AppLocalizations.of(context)!.translate('Female'), ()=> change(1)),
        ],
      ),
    );
  }

  final GlobalKey _dropDownKey = GlobalKey();
  final GlobalKey _dropDownKeyAge = GlobalKey();

  _dropDown(){
    var curve = MediaQuery.of(context).size.height/100;
    _genderName.clear();
    _genderName.add(AppLocalizations.of(context)!.translate('Male'));
    _genderName.add(AppLocalizations.of(context)!.translate('Female'));
    _genderName.add(AppLocalizations.of(context)!.translate('I prefer not to say'));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: curve),
      //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
        decoration: BoxDecoration(
            color: MyColors.white,
            border: Border.all(color: _error && _genderController.text.isEmpty?MyColors.red:MyColors.card),
            borderRadius: BorderRadius.all(Radius.circular(curve))
        ),
        //width: width,
        //height: MediaQuery.of(context).size.width/6.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                      TextField(
                        readOnly: true,
                        maxLines: null,
                        //validator: requiredValidator,
                        //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        controller: _genderController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: lng == 2? MediaQuery.of(context).size.width/26: MediaQuery.of(context).size.width/22,
                            color: MyColors.fieldText,
                            fontFamily: lng==2?'OmarMedium':'SairaMedium'),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //labelText: titleText,

                          hintText: AppLocalizations.of(context)!.translate('gender'),
                          hintStyle: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.fieldText,
                              fontFamily: lng==2?'OmarLight':'SairaLight'),
                          errorStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/2400,
                          ),
                        ),
                        onTap: ()=> _openList(_dropDownKey),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_gender==0?Icons.male_outlined:_gender==1?Icons.female_outlined:Icons.arrow_forward_ios_outlined,
                        color: MyColors.fieldText,),
                      onPressed: ()=> _openList(_dropDownKey),
                    ),
                  ],
                ),

                //_m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _genderController, AppLocalizations.of(context)!.translate('gender'), _gender==0?Icons.male_outlined:_gender==1?Icons.female_outlined:Icons.arrow_forward_ios_outlined, readOnly: true, click: ()=> _openList(_dropDownKey), error: _error),
                DropdownButton<String>(
                    key: _dropDownKey,
                    underline: DropdownButtonHideUnderline(child: Container(),),
                    icon: Icon(_gender==0?Icons.male_outlined:_gender==1?Icons.female_outlined:Icons.arrow_forward_ios_outlined, size: 0.0001,),
                    dropdownColor: MyColors.white.withOpacity(0.9),
                    //value: 'Type1',
                    items: _genderName.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.gray,
                              fontFamily: 'SairaMedium'),
                        ))).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return _genderName.map((e) => Text(e.toString())).toList();
                    },
                    onChanged: (chosen){
                      setState(() {
                        _genderController.text = chosen.toString();
                        gender = chosen.toString();
                        gender == AppLocalizations.of(context)!.translate('Male') ? _gender = 0 :
                        gender == AppLocalizations.of(context)!.translate('Female') ? _gender = 1: _gender=2;
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

  _dropDownAge(){
    var curve = MediaQuery.of(context).size.height/100;
    _ageRange.clear();
    _ageRange.add(' < 10');
    _ageRange.add('10 - 20');
    _ageRange.add('21 - 30');
    _ageRange.add('31 - 40');
    _ageRange.add(' > 40');
    return Container(
        padding: EdgeInsets.symmetric(horizontal: curve),
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve*2),
        decoration: BoxDecoration(
            color: MyColors.white,
            border: Border.all(color:  _error && _ageRangController.text.isEmpty?MyColors.red:MyColors.card),
            borderRadius: BorderRadius.all(Radius.circular(curve))
        ),
        //width: width,
        //height: MediaQuery.of(context).size.width/6.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                      TextField(
                        readOnly: true,
                        maxLines: null,
                        //validator: requiredValidator,
                        //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        controller: _ageRangController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: lng == 2? MediaQuery.of(context).size.width/26: MediaQuery.of(context).size.width/22,
                            color: MyColors.fieldText,
                            fontFamily: lng==2?'OmarMedium':'SairaMedium'),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //labelText: titleText,

                          hintText: AppLocalizations.of(context)!.translate('Age Range'),
                          hintStyle: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.fieldText,
                              fontFamily: lng==2?'OmarLight':'SairaLight'),
                          errorStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/2400,
                          ),
                        ),
                        onTap: ()=> _openList(_dropDownKeyAge),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined,
                        color: MyColors.fieldText,),
                      onPressed: ()=>_openList(_dropDownKeyAge),
                    ),
                  ],
                ),
                //_m!.textFiled(0.0, MyColors.white, MyColors.fieldText, _ageRangController, AppLocalizations.of(context)!.translate('Age Range'), Icons.arrow_forward_ios_outlined, readOnly: true, click: ()=> _openList(_dropDownKeyAge), error: _error),
                DropdownButton<String>(
                    key: _dropDownKeyAge,
                    underline: DropdownButtonHideUnderline(child: Container(),),
                    icon: Icon(Icons.arrow_forward_ios_outlined, size: 0.0001,),
                    dropdownColor: MyColors.white.withOpacity(0.9),
                    //value: 'Type1',
                    items: _ageRange.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              color: MyColors.gray,
                              fontFamily: 'SairaMedium'),
                        ))).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return _ageRange.map((e) => Text(e.toString())).toList();
                    },
                    onChanged: (chosen){
                      setState(() {
                        _ageRangController.text = chosen.toString();
                        //gender = chosen.toString();
                        //gender == AppLocalizations.of(context)!.translate('Male') ? _gender = 0 :
                        //gender == AppLocalizations.of(context)!.translate('Female') ? _gender = 1: _gender=2;
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

  bool _error = false;
  _next() {
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || _emailController.text.isEmpty || _phoneNumberController.text.isEmpty || _passwordController.text.isEmpty || _dateOfBearthController.text.isEmpty || _gender == -1 || _ageRangController.text.isEmpty){
      setState((){
        _error = true;
      });
      return;
    }
    var user = {'FirstName':_firstNameController.text,
      'LastName':_lastNameController.text,
      'Phone':_phoneNumberController.text,
      'Email':_emailController.text,
      'Password':_passwordController.text,
      'Date':_dateOfBearthController.text + ' / ' +_ageRangController.text,
      'ageRange':_ageRangController.text,
      'gender':_gender == 1? 'female': _gender == 0?'male': 'I prefer not to say',
    };
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPassword(user),
        ));
  }

  _openList(_dropDownKey) {
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


}

