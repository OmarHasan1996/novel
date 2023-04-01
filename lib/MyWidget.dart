// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:novel/screen/cartScreen.dart';
import 'package:novel/screen/mainScreen.dart';
import 'package:novel/screen/myProfileScreen.dart';
import 'package:novel/screen/wishlistScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

//import 'api.dart';
import 'color/MyColors.dart';
import 'const.dart';
import 'localizations.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

import 'screen/signInScreen.dart';

class MyWidget{
  BuildContext context;
  MyWidget(this.context);

  Color fromHex(String hexString) {
    hexString = hexString.replaceAll('H-', '');
    var red = hexString.substring(0,1);
    var green = hexString.substring(1,2);
    var blue = hexString.substring(2,3);
    hexString = red + 'f' + green + 'f' + blue + 'f';
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  colorContainer(color, bool select){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: select? MyColors.novelBlue : MyColors.metal),
        color: MyColors.metal,
      ),
      width: MediaQuery.of(context).size.width/12,
      height: MediaQuery.of(context).size.width/12,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width/75),
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/20),
      child: Container(
        color: fromHex(color),
        width: MediaQuery.of(context).size.width/12,
        height: MediaQuery.of(context).size.width/12,
        //child: Expanded(child: SizedBox(),),
      ),
    );
  }

  comimaniaLogo({scale, color, isWhite}){
    scale??=1.0;
    color??= false;
    isWhite??= false;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        !isWhite? Image.asset('assets/images/logo_main_screen.png', width: MediaQuery.of(context).size.width/1.65*scale,)
            :
        SvgPicture.asset('assets/images/comimania.svg', width: MediaQuery.of(context).size.width/1.7*scale,color: MyColors.white,)
      ],
    );
  }

  empty(){
    return Center(
      child: bodyText1(AppLocalizations.of(context)!.translate('Empty!'), scale: 1.7),
    );
  }
  returnIcon({color, click}){
    color??= MyColors.icon;
    click??= ()=>{
      Navigator.of(context).pop()
    };
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.all(0.0),
          icon: Icon(Icons.keyboard_backspace_outlined, color: color,size: MediaQuery.of(context).size.width/14,),//SvgPicture.asset('assets/images/back_icon.svg', color: color, height: MediaQuery.of(context).size.width/14, ),
          onPressed: ()=> click(),
        ),
      ],
    ) ;
  }

  orDriver(){
    return Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40*0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          driver(width: MediaQuery.of(context).size.width/3),
          bodyText1(AppLocalizations.of(context)!.translate('OR'), color: MyColors.icon, padding: MediaQuery.of(context).size.width/50, scale: 1.1),
          driver(width: MediaQuery.of(context).size.width/3),
        ],
      ),
    );
  }

  showSDialog(title, optionchild1, optionChild2,){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/22,
                    color: MyColors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gotham'),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      optionchild1,
                      const Expanded(child: SizedBox()),
                      optionChild2,
                      /*
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Pick From Gallery'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Take A New Picture'),
                    ),
                    */
                    ],
                  ),
                ),

              ]);
        });
  }

  headText(text,{double? scale, color, paddingV, paddingH, align, maxLine}){
    scale ??= 1.0;
    color ??= MyColors.headText;
    paddingV ??= 0.0;
    paddingH ??= 0.0;
    align ??= TextAlign.center;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
//        softWrap: false,
        //textDirection: TextDirection.rtl,
        textAlign: align, maxLines: maxLine,
        style: TextStyle(
            fontSize: lng==2?MediaQuery.of(context).size.width/25 * scale:MediaQuery.of(context).size.width/20 * scale,
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: lng==2?'OmarBold':'SairaBold'),
      ),
    );
  }

  bodyText1(text,{double? scale, padding, padV, maxLine,bool? baseLine, color, align}){
    scale ??= 1.0;
    padding??= MediaQuery.of(context).size.width/20;
    maxLine??=2;
    baseLine??=false;
    padV??=0.0;
    color??= MyColors.bodyText1;
    align ??= TextAlign.center;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: lng==2?padV/2*0:padV),
      child: Text(
        text,
        overflow: TextOverflow.visible,
        maxLines: maxLine,
        textAlign:align,
        softWrap: true,
        style: TextStyle(
            fontSize: lng==2?MediaQuery.of(context).size.width/30 * scale:MediaQuery.of(context).size.width/25 * scale,
            color: color,
            decoration: baseLine? TextDecoration.lineThrough: TextDecoration.none,
            fontFamily: lng==2?'OmarMedium':'SairaMedium'),
      ),
    )
    ;
  }

  dialogText1(text,{double? scale, align}){
    scale ??= 1.0;
    align ??= Alignment.center;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
      child: Text(text,
        // textAlign: TextAlign.center,
        maxLines: 5,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/23 * scale,
            color: MyColors.white,
            fontFamily: 'Gotham'),
      ),);
  }

  drawerButton(_scaffoldKey){
    return IconButton(
      icon: Align(
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset('assets/images/drawer.svg', height: MediaQuery.of(context).size.width/30, fit: BoxFit.contain,),),
      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
    );
  }

  notificationButton(){
    return GestureDetector(
        child: Icon(Icons.notification_add_outlined, color: thereNotification? MyColors.orange2 :MyColors.mainColor, size: MediaQuery.of(context).size.width/15,),
        // ignore: avoid_returning_null_for_void
        onTap: () =>null/* Navigator.of(context).push(MaterialPageRoute(builder:(context)=> NotificationScreen())),*/
    );
  }

  driver({width, padH, padV, color}){
    width??= double.infinity;
    padH??= 0.0;
    padV??= MediaQuery.of(context).size.height/200;
    color??= Colors.grey;
    return Container(
      height: MediaQuery.of(context).size.height/400,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      color: color,
    );
  }

  _logout() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //   sharedPreferences.setString('email', _emailController.text);
    sharedPreferences.setString('password', '');
    /*Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Sign_in(true),),
          (Route<dynamic> route) => false,
    );*/
  }

  changePassword(Function() restPassword) {
    Widget _no(){
      return IconButton(
          onPressed: ()=> Navigator.of(context).pop(), icon: const Icon(Icons.close_outlined, color: MyColors.mainColor,));
    }
    Widget _ok(){
      return IconButton(
        onPressed: ()=> {
          Navigator.of(context).pop(),
          restPassword(),
        }, icon: const Icon(Icons.check, color: MyColors.mainColor,),

      );
    }

    showSDialog(AppLocalizations.of(context)!.translate('Change Your Password?'), _no(), _ok());
  }

  _resetPass(Function() _setState, _scaffoldKey) async{
    _scaffoldKey.currentState!.closeDrawer();
    pleaseWait = true;
    _setState();
/*    var response = await MyAPI(context: context).requestResetPassword(userInfo['email']);
    if(response[0]){
      //var value = jsonDecode(x)["data"][0]["id"].toString();
      var verCode = response[1].toString();
      // final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      // sharedPreferences.setString('Id',response.body[1].toString());
      //
      // if(sharedPreferences.getString('Id') != null){
      bool sent = await MyAPI(context: context).sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'),  userInfo['email']);
      pleaseWait = false;
      _setState();
      if(!sent){
        return;
      }
      //_save();
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ResetPassword(userInfo['email'], verCode: response[1].toString(),)));
    }else{
      pleaseWait = false;
      _setState();
    }*/
    pleaseWait = false;
    _setState();
  }

  toast(String text) {

  }

  textFiled(curve, Color containerColor, textColor,TextEditingController controller, hintText, icon, { height, click ,bool? number, bool? password, double? width, double? blurRaduis, bool? boxShadow, RequiredValidator? requiredValidator, String? val,bool? withoutValidator, bool? readOnly, bool? error, paddV}){
    readOnly??=false;
    withoutValidator??=false;
    requiredValidator??= RequiredValidator(errorText: AppLocalizations.of(context)!.translate('required'));
    password??= false;
    boxShadow??= false;
    number??= false;
    width??= MediaQuery.of(context).size.width/1.2;
    blurRaduis??= 5.0;
    var errorText = requiredValidator.errorText;
    val??= '';
    if(val != '') errorText = "text didn't match";
    error??= false;
    if(controller.text != '') error = false;
    if(val != '' && controller.text != val) error = true;
    height??=  MediaQuery.of(context).size.width/6.5;
    paddV??= MediaQuery.of(context).size.height/80;

    if(withoutValidator) error = false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: paddV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child:
                TextField(
                  obscureText: password,
                  readOnly: readOnly,
                  maxLines: password? 1: null,
                  //validator: requiredValidator,
                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                  keyboardType: password? TextInputType.visiblePassword: number?  TextInputType.number : TextInputType.text,
                  controller: controller,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: lng == 2? MediaQuery.of(context).size.width/26: MediaQuery.of(context).size.width/22,
                      color: textColor,
                      fontFamily: lng==2?'OmarMedium':'SairaMedium'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //labelText: titleText,

                    hintText: hintText,
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/25,
                        color: textColor,
                        fontFamily: lng==2?'OmarLight':'SairaLight'),
                    errorStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/2400,
                    ),
                  ),
                  onTap: readOnly? () => click() : null,
                ),
              ),
              IconButton(
                icon: Icon(icon, color: textColor,),
                onPressed: ()=> click(),
              ),
            ],
          ),
          driver(padV: paddV/3, color: error? MyColors.red : Colors.grey),
          ///error? bodyText2(errorText): const SizedBox(height: 0,),
        ],
      ),
    )
    ;
  }

  textFiledBorder(curve, Color containerColor, textColor,TextEditingController controller, hintText, icon, { height, click ,bool? number, bool? password, double? width, double? blurRaduis, bool? boxShadow, RequiredValidator? requiredValidator, String? val,bool? withoutValidator, bool? readOnly}){
    readOnly??=true;
    withoutValidator??=false;
    requiredValidator??= RequiredValidator(errorText: AppLocalizations.of(context)!.translate('required'));
    password??= false;
    boxShadow??= false;
    number??= false;
    width??= MediaQuery.of(context).size.width/1.2;
    blurRaduis??= 5.0;
    var errorText = requiredValidator.errorText;
    val??= '';
    if(val != '') errorText = "text didn't match";
    bool error = true;
    if(controller.text != '') error = false;
    if(val != '' && controller.text != val) error = true;
    height??=  MediaQuery.of(context).size.width/7;

    if(withoutValidator) error = false;
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: MyColors.metal,
          borderRadius: BorderRadius.all(Radius.circular(curve)),
          border: Border.all(color: MyColors.gray)
      ),
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2*0),
      margin: EdgeInsets.symmetric(horizontal: curve*0, vertical: curve/3*2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child:
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          //stepWidth: 1000,
          child: TextField(
            obscureText: password,
            readOnly: readOnly,
            maxLines: null,
            //validator: requiredValidator,
            //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.multiline,
            controller: controller,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: lng == 2? MediaQuery.of(context).size.width/28: MediaQuery.of(context).size.width/22,
                color: textColor,
                fontFamily: lng==2?'OmarMedium':'SairaMedium'),
            decoration: InputDecoration(
              border: InputBorder.none,
              //labelText: titleText,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25,
                  color: textColor,
                  fontFamily: 'SairaLight'),
              errorStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width/2400,
              ),
            ),

          )
        ),
      )
              ,),
            ],
          ),
          //driver(),
          ///error? bodyText2(errorText): const SizedBox(height: 0,),
        ],
      ),
    )
    ;
  }

  listTextFiled(curve, controller, Function() pressIcon, containerColor, textColor, hintText, iconColor, {width, bool? boxShadow, bool? withOutValidate}){
    withOutValidate??=true;
    width??= MediaQuery.of(context).size.width/1.6;
    boxShadow??=false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //SizedBox(width: MediaQuery.of(context).size.width/50,),
        //iconButton(MediaQuery.of(context).size.height/35, 'assets/images/filter.svg', () => pressIcon(), curve: curve, color: containerColor, iconColor: iconColor),
      ],
    );

  }

  raisedButton(double curve, double width, String text, icon, click,{double? iconHight, height, color, borderSide, textColor}) {
    height??= MediaQuery.of(context).size.width/7.2;
    iconHight??=height/1.9;
    color??= MyColors.darkBlue;
    borderSide??= color;
    textColor??= MyColors.lightBlue;
    return ButtonTheme(
      minWidth: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          //color: MyColors.yellow,
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(curve/2),
            side: BorderSide(color: borderSide),
          ),
          padding: EdgeInsets.symmetric(vertical: lng==2?curve/10*0:curve/3, horizontal: curve/2),
          primary: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon == null? const SizedBox(width: 0,) :SvgPicture.asset(icon, height: iconHight, color: MyColors.white,),
            SizedBox(width: icon == null? 0 :curve/2,),
            Text(text, style: TextStyle(
              color: textColor,
              fontSize: min(min(width/5, height-curve), lng==2?MediaQuery.of(context).size.width/30:MediaQuery.of(context).size.width/20),
              fontFamily: lng==2?'OmarMedium':'SairaMedium',
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
        onPressed: click,
      ),
    );
  }

  iconButton(double height, icon, Function() click, {width, double? curve, color, iconColor}) {
    width??= height;
    curve??= 0.0;
    color??= MyColors.black;
    iconColor??= MyColors.white;
    return Padding(padding: EdgeInsets.only(top: curve, bottom: 0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width/6.7,
        padding: EdgeInsets.symmetric(vertical: height/3, horizontal: height/3),
        height: MediaQuery.of(context).size.width/6.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            //color: MyColors.yellow,
            minimumSize: Size(width, height),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height/2)
            ),
            primary: color,
          ),
          child: Icon(Icons.face, size: height,),//SvgPicture.asset(icon, height: height, width: height, fit: BoxFit.contain, color: iconColor,),
          onPressed: () {
            click();
          },
        ),
      ),
    )
    ;
  }

  iconText(icon, text, color, {double? scale, bool? vertical, paddingH, revers, Function()? click}){
    scale??=0.9;
    scale= scale*1.1;
    vertical??= false;
    paddingH??= MediaQuery.of(context).size.width/20;
    revers??= false;
    if(!vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: MediaQuery.of(context).size.height/100*0),
        child: !revers?
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: ()=> click!(),
              child: SvgPicture.asset(icon ,height: MediaQuery.of(context).size.width/13*scale, fit: BoxFit.contain,),
            ),
            SizedBox(width: MediaQuery.of(context).size.width/20*scale,),
            bodyText1(text, scale: 0.8*scale, padding: 0.0, align: TextAlign.left)
          ],
        ):
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headText(text, scale: 0.4 * scale, paddingV: 0.0, color: color),
            SizedBox(width: MediaQuery.of(context).size.width/80*scale,),
            SvgPicture.asset(icon ,height: MediaQuery.of(context).size.width/22*scale, fit: BoxFit.cover,),
          ],
        )
        ,
      );
    } else{
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/50,),
        child: GestureDetector(
          onTap: ()=> click!(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //textDirection: TextDirection.rtl,
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon ,size: MediaQuery.of(context).size.width/15*scale, color: color,),
              bodyText1(text, scale: 1.0*scale, color: color, padV: MediaQuery.of(context).size.width/80*0, padding: 0.0),
            ],
          ),
        ),
      );
    }
  }

  _navigateFarmList(farms){
    /*if(farms.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FarmList(farms[0]['Type']),),);
    } else {
      toast(AppLocalizations.of(context)!.translate('first add new farm'));
    }*/
  }

  guestDialog() {
    var curve = MediaQuery.of(context).size.width/20;
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve),), //this right here
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(curve)),
          color: MyColors.mainColor,
        ),
        height: MediaQuery.of(context).size.width/2,
        width: MediaQuery.of(context).size.width/3*2,
        padding: EdgeInsets.all(curve),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: MyColors.white, size: MediaQuery.of(context).size.width/10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: bodyText1(AppLocalizations.of(context)!.translate('You should signIn to get this service'), maxLine: 2, color: MyColors.white, scale: 1.2),
                  )
                ],
              ),
            ),
            Row(
              children: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                    child: bodyText1(AppLocalizations.of(context)!.translate('Later!'),  color: MyColors.white)),
                Expanded(child: SizedBox()),
                TextButton(onPressed: () {
                  guestType = true;
                  editTransactionGuestType();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignINScreen()));
                },
                    child: bodyText1(AppLocalizations.of(context)!.translate('SignIn'), color: MyColors.novelBlue))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  dialog(text) async{
    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text, textAlign: TextAlign.right,
              style: const TextStyle(color: MyColors.bodyText1, fontSize: 18),),
            /*actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context)!.translate('no'),
                    style: const TextStyle(color: MyColors.mainColor, fontSize: 18),),
                  onPressed: () {
                    Navigator.of(context).pop;
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context)!.translate('yesExit'),
                    style: const TextStyle(color: MyColors.mainColor, fontSize: 18),),
                  onPressed: (){
                    Navigator.of(context).pop;
                  },
                ),
              ],*/
          );
        }
    );
    return value == true;
  }

  bottomContainer(number, curve, {bottomConRati, setState()?}){
    bottomConRati??= bottomConRatio;
    _catego(bool set){
      homeNotCategory = false;
      if(!set) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainScreen()));
      }
      else{
        setState!();
      }
    }
    _main(bool set){
      homeNotCategory = true;
      if(!set) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainScreen()));
      }
      else{
        setState!();
      }
    }
    if(bottomConRati == 0.0) {
      return const SizedBox(height: 0,);
    } else {
      return Container(
        //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/100),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * bottomConRati,
        width: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
        decoration: BoxDecoration(
          color: MyColors.bottomCon,
          boxShadow: const [
            BoxShadow(
              color: MyColors.card,
              offset: Offset(1, 1),
              blurRadius: 1,
            ), BoxShadow(
              color: MyColors.card,
              offset: Offset(1, 1),
              blurRadius: 3,
            )],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconText(Icons.home_outlined, AppLocalizations.of(context)!.translate('Home'), number == 0? MyColors.novelBlue : MyColors.bodyText1, vertical: true, click: number ==0? null: number ==1? ()=>_main(true): ()=> _main(false),),
            iconText(Icons.category_outlined, AppLocalizations.of(context)!.translate('categories'), number == 1? MyColors.novelBlue : MyColors.bodyText1, vertical: true, click: number ==1? null:
            number ==0? ()=> _catego(true)
                : ()=> _catego(false)
            ,),
            iconText(Icons.shopping_cart_outlined, AppLocalizations.of(context)!.translate('cart'), number == 2? MyColors.novelBlue : MyColors.bodyText1, vertical: true, click: number ==2? null: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> CartScreen())),),
            iconText(Icons.favorite_border_outlined, AppLocalizations.of(context)!.translate('wishlist'), number == 3? MyColors.novelBlue : MyColors.bodyText1, vertical: true, click: number ==3? null: guestType? ()=> guestDialog() : ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> WishlistScreen())),),
            iconText(Icons.person_outline, AppLocalizations.of(context)!.translate('my Profile'), number == 4? MyColors.novelBlue : MyColors.bodyText1, vertical: true, click: number ==4? null: guestType? ()=> guestDialog() : ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyProfileScreen())),scale: 1),
            /*Flexible(
                      //flex: 1,
                      child: _m!.iconText(Icons.home_outlined, AppLocalizations.of(context)!.translate('Home'), MyColors.orange, vertical: true),
                    ),
                    Flexible(
                      //flex: 2,
                      child: _m!.iconText(Icons.category_outlined, AppLocalizations.of(context)!.translate('categories'), MyColors.orange, vertical: true),
                    ),
                    Flexible(
                      //flex: 1,
                      child: _m!.iconText(Icons.shopping_cart_outlined, AppLocalizations.of(context)!.translate('cart'), MyColors.orange, vertical: true),
                    ),
                    Flexible(
                      //flex: 1,
                      child: _m!.iconText(Icons.favorite_border_outlined, AppLocalizations.of(context)!.translate('wishlist'), MyColors.orange, vertical: true),
                    ),
                    Flexible(
                      //flex: 1,
                      child: _m!.iconText(Icons.person_outline, AppLocalizations.of(context)!.translate('my Profile'), MyColors.orange, vertical: true),
                    ),*/
          ],
        ),
      );
    }
  }

  mainChildrenBottomContainer(curve, Function() clickT1, Function() clickT2, Function() clickT3, tapNumber){

    return ToggleSwitch(
      radiusStyle: true,
      animate: true,
      curve: Curves.fastOutSlowIn,
      minWidth: MediaQuery.of(context).size.width/2.4,
      fontSize: MediaQuery.of(context).size.width/20,
      iconSize: MediaQuery.of(context).size.width/13,
      initialLabelIndex: tapNumber-1,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: MyColors.bottomCon,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: [tapNumber == 1? AppLocalizations.of(context)!.translate('HOME'): '',tapNumber==2? AppLocalizations.of(context)!.translate('Profile'): ''],
      icons: const [Icons.home_outlined,  Icons.person_outline],
      activeBgColors: const [[MyColors.mainColor],[MyColors.mainColor]],
      onToggle: (index) {
        if(index==0){
          clickT1();
        }
        if(index==1){
          clickT2();
        }
        print('switched to: $index');
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: tapNumber == 1 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              AppLocalizations.of(context)!.translate('HOME'),
              'assets/images/home.svg', () => clickT1(),
              //iconHight: MediaQuery.of(context).size.height / 18,
              height: MediaQuery.of(context).size.width/10
          ): GestureDetector(
            child: SvgPicture.asset('assets/images/home.svg'),
            onTap: ()=> clickT1(),
          ),
        ),
        Expanded(
          flex: 1,
          child: tapNumber == 2 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              '',
              'assets/images/true_bag.svg', () => clickT2(),
              height: MediaQuery.of(context).size.width / 10):
          GestureDetector(
            child: SvgPicture.asset('assets/images/true_bag.svg'),
            onTap: ()=> clickT2(),
          ),
        ),
        Expanded(
          flex: 1,
          child: tapNumber == 3 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              '',
              'assets/images/user_profile.svg', () => clickT3(),
              height: MediaQuery.of(context).size.width / 10):
          GestureDetector(
            child: SvgPicture.asset('assets/images/user_profile.svg'),
            onTap: ()=> clickT3(),
          ),
        ),
      ],
    );
  }

  cardMaterial(curve, height, _starRate, bool favorait, materialName, materialType, _salePrice, price, Function() _select){
    var width = height*0.63-4;
    return Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: MyColors.card,
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
          color: MyColors.white,
          borderRadius: BorderRadius.all(Radius.circular(curve),),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
        child: Stack(
          children: [
          Align(
          alignment: Alignment.center,
          child: Column(
              children: [
          Container(
          padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
          height: height/5*3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.white,
                MyColors.metal,
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  miniContainer(iconText('assets/images/star.svg', _starRate, MyColors.white, revers: true, paddingH: 0.0, scale: 0.75), MediaQuery.of(context).size.height/35),
                  const Expanded(
                    child: Align(

                    ),
                  ),
                  favorait? SvgPicture.asset('assets/images/heart_red.svg', color: MyColors.mainColor, height: curve,):SvgPicture.asset('assets/images/heart.svg', color: MyColors.black,)

                ],
              ),
              Expanded(child: SvgPicture.asset('assets/images/group2.svg'))
            ],
          ),
        ),
        //SizedBox(height: curve/2+1,),
        Container(
          padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve, bottom: curve/2,),
          height: height/5*2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: bodyText1(materialName,scale: 0.7,color: MyColors.mainColor, padding: 0.0, align: TextAlign.start),
              ),
              Expanded(
                  flex: 3,
                  child: Align(alignment: Alignment.centerLeft,
                    child: bodyText1(materialType,scale: 0.5, padding: 0.0, align: TextAlign.start),
                  )
              ),
              //SizedBox(height: curve/4,),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                      headText(currencyValue['CurMark'] + ' ' + _salePrice.toString(),scale: 0.5),
                  bodyText1(currencyValue['CurMark'] + ' '  + price.toString(),scale: 0.6, padding: MediaQuery.of(context).size.width/60, align: TextAlign.start, baseLine: true),
            ],
          ),
        )
    ),


    ],
    ),
    ),
    ],
    )
    ),
    Align(
    alignment: Alignment.centerRight,
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: curve/2),
    child: iconButton(curve, 'assets/images/shopping_cart_add.svg', () => _select(), curve: height/5, color: MyColors.mainColor,),
    )
    ),
    ],
    ),
    );
  }

  cardMain(
      {curve,
        height,
        starRate,
        bool? favoraite,
        sale,
        image,
        name,
        price,
        Function()? select,
        Function()? favorite,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2;
    var width = height*0.8;
    starRate??= 3;
    favoraite??= false;
    var isSale = false;
    if(sale != null && sale != 0) isSale = true;
    name??="T_shirt Summer Vibes";
    price??= 119.99;
    var backgroundColor = MyColors.color1;
    return GestureDetector(
      child: Container(
        //alignment: Alignment.centerLeft,
          height: height,
          width: width,

          decoration: BoxDecoration(
            color: MyColors.white,
            boxShadow: [
              BoxShadow(
                color: MyColors.card.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            /*border: Border.all(
              color: MyColors.card,
            ),*/
          ),
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40, vertical: MediaQuery.of(context).size.width/40),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
                width: width,
                height: height - MediaQuery.of(context).size.width/5,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
                  NetworkImage(image.toString()) as ImageProvider,
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(curve*0),),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        isSale? miniContainer(bodyText1(sale.toString() + '%', color: MyColors.white, padding: 0.0, padV: 0.0, scale: 0.9), curve*2,): SizedBox(),
                        const Expanded(
                          child: Align(
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=> favorite!(),
                          child: SvgPicture.asset(favoraite?'assets/images/heart_red.svg':'assets/images/heart.svg', /*color: MyColors.mainColor,*/ height: curve*2,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //SizedBox(height: curve/2+1,),
              Container(
                padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve/2*0, bottom: curve/2*0,),
                height: MediaQuery.of(context).size.width/5,
                width: width,
                //color: MyColors.backGround,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: bodyText1(name.toString(),scale: 0.9, padding: 0.0, align: TextAlign.start, maxLine: 1),
                    ),
                     Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: isSale?[
                              headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, sale),color: MyColors.novelBlue, scale: 0.7),
                              Expanded(child: SizedBox()),
                              bodyText1(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0),scale: 0.7, padding: MediaQuery.of(context).size.width/60, align: TextAlign.start, baseLine: true),
                            ]:[
                              headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0).toString(),scale: 0.7),
                            ],
                          ),
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child: starRow(width/2, starRate),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
      onTap: ()=> select!(),
    );
  }

  cardMainHorizental(
      {curve,
        height,
        starRate,
        bool? favoraite,
        sale,
        image,
        name,
        price,
        Function()? select,
        Function()? favorite,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2;
    var width = height*0.7;
    if(starRate == null || starRate == 0) starRate = 3;
    favoraite??= false;
    var isSale = false;
    if(sale != null && sale!=0) isSale = true;
    name??="T_shirt Summer Vibes";
    price??= 119.99;
    var backgroundColor = MyColors.color1;
    return GestureDetector(
        child: Container(
          //alignment: Alignment.centerLeft,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: MyColors.white,
            /*border: Border.all(
              color: MyColors.card,
            ),*/
          ),
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25, vertical: MediaQuery.of(context).size.width/50),
          //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/50, vertical: MediaQuery.of(context).size.width/50),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
                margin: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
                width: width,
                height: height - curve,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
                  NetworkImage(image.toString()) as ImageProvider,
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(curve*0),),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        isSale? miniContainer(bodyText1(sale.toString() + '%', color: MyColors.white, padding: 0.0, padV: 0.0, scale: 0.9), curve*1.7,): SizedBox(),
                        const Expanded(
                          child: Align(
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async=> await favorite!(),
                          child: SvgPicture.asset(favoraite?'assets/images/heart_red.svg':'assets/images/heart.svg', /*color: MyColors.mainColor,*/ height: curve*1.7,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //SizedBox(height: curve/2+1,),
              Container(
                  padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve/2, bottom: curve/2,),
                  height: height,
                  width: width*1.31,
                  //color: MyColors.backGround,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                    flex: 2,
                    child: bodyText1(name.toString(),scale: 1,/*color: MyColors.orange,*/ padding: 0.0, align: TextAlign.start),
                  ),
                  Expanded(
                    flex: 1,
                    child: starRow(width/2, starRate),
                  ),
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: lng ==2?Alignment.bottomRight:Alignment.bottomLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: isSale?[
                              bodyText1(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0),scale: 0.8, padding: MediaQuery.of(context).size.width/60*0.0, align: TextAlign.start, baseLine: true, ),
                          headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, sale),scale: 0.8, color: MyColors.novelBlue),
                      ]:[
                        SizedBox(height: MediaQuery.of(context).size.width/30,),
                  headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0),scale: 0.8),
            ],
          ),
        )
    ),
    ],
    ),
    ),
    ],
    )
    ),
    onTap: ()=> select!(),
    );
  }

  cardBrand(
      {curve,
        height,
        image,
        brandName,
        Function()? select,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.7;
    var width = height;
    brandName??= "COMIMANIA";
    return Container(
        alignment: Alignment.topCenter,
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
          NetworkImage(image.toString()) as ImageProvider,
              fit: BoxFit.cover),
          borderRadius: BorderRadius.all(Radius.circular(curve*0),),
          color: MyColors.color2,
          boxShadow: const [
            BoxShadow(
              color: MyColors.card,
              offset: Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40, vertical: MediaQuery.of(context).size.height/100),
        padding: EdgeInsets.symmetric(horizontal: curve/2*0, vertical: height/7),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
                width: width,
                height: height / 4,
                decoration: BoxDecoration(
                  color: MyColors.white,
                ),
                child: headText(brandName, color: MyColors.black, scale: 0.9),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(top: height/4- curve/4),
                //width: width,
                height: height / 2.45,
                child: raisedButton(curve, width/2.5, AppLocalizations.of(context)!.translate('Shop Now'), null, ()=> select!(), color: MyColors.orange2, textColor: MyColors.white),
              ),
            ),
            //SizedBox(height: curve/2+1,),
          ],
        )
    );
  }

  cardShopNow(
      {curve,
        height,
        image,
        supName,
        name,
        backgroundColor,
        Function()? select,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.7;
    var width = MediaQuery.of(context).size.width/3;
    backgroundColor??= MyColors.color1;
    name??= "Sun Glasses";
    supName??= "New Collections";

    return Container(
        alignment: Alignment.topCenter,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(curve*0),),
          color: backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: MyColors.card,
              offset: Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40, vertical: MediaQuery.of(context).size.height/100),
        padding: EdgeInsets.symmetric(horizontal: curve/2*0, vertical: curve/2),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: bodyText1(supName, scale: 0.7),
            ),
            Flexible(
              flex: 3,
              child: headText(name, scale: 0.9),
            ),
            Flexible(
              flex: 3,
              child: raisedButton(curve, width/2.5, AppLocalizations.of(context)!.translate('Shop Now'), null, ()=> select!(), color: MyColors.novelBlue),
            ),
            Flexible(
              flex: 6,
              child: image == null ? Image.asset('assets/images/lets.png', fit : BoxFit.contain) :
              Image.network(image.toString(), fit: BoxFit.cover,) ,
            ),
            //SizedBox(height: curve/2+1,),
          ],
        )
    );
  }

  cardSales(
      {curve,
        height,
        image,
        head,
        name,
        supName,
        backgroundColor,
        Function()? select,
        Function()? viewAll,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.0;
    var width = MediaQuery.of(context).size.width;
    name??= "Men's Collection";
    supName??= "Mid Season Sale";
    head??=AppLocalizations.of(context)!.translate('Sale');
    backgroundColor??= MyColors.color2;
    return Container(
      //alignment: Alignment.centerLeft,
        height: height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        margin: EdgeInsets.symmetric(vertical: curve/2,),
        child: Row(
          children: [
            Container(
              //padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
              width: width / 2,
              height: height,
              decoration: BoxDecoration(
                //color: backgroundColor,
                image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
                NetworkImage(image.toString()) as ImageProvider,
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(curve*0),),
              ),
            ),
            //SizedBox(wt: curve/2+1,),
            Container(
              padding: EdgeInsets.only(left: curve, right: curve, top: curve, bottom: curve*2,),
              height: height,
              width: width/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: headText(head, color: MyColors.orange2),
                  ),
                  Expanded(
                    flex: 1,
                    child: bodyText1(name.toString(),scale: 1.1,color: MyColors.black, padding: 0.0, align: TextAlign.start),
                  ),
                  Expanded(
                    flex: 3,
                    child: bodyText1(supName.toString(),scale: 0.9,color: MyColors.bodyText1, padding: 0.0, align: TextAlign.start, padV: height/25),
                  ),
                  Expanded(
                    flex: 2,
                    child: raisedButton(curve, width/5, AppLocalizations.of(context)!.translate('View All'), null, ()=> viewAll!(), height: MediaQuery.of(context).size.height/20, color: MyColors.white, textColor: MyColors.orange2),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  cardCart(
      {curve,
        height,
        image,
        head,
        name,
        size,
        price,
        sale,
        backgroundColor,
        quantity,
        Function()? delete,
        Function()? quantityMin,
        Function()? quantityAdd,
      }){
    quantity??= 1;
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.8;
    var width = MediaQuery.of(context).size.width;
    head??= "Trendyol";
    name??= "T-shirt Summer VIB";
    price??=119.99;
    size??= 'XL';
    bool isSale = false;
    if(sale != null && sale != 0) {
      isSale = true;
    }else{
      sale = 0;
    }
    backgroundColor??= MyColors.white;
    return Container(
      //alignment: Alignment.centerLeft,
      height: height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: curve/2,),
      padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve/2, bottom: curve/2,),
      child: Row(
        children: [
      Container(
      margin: EdgeInsets.symmetric(horizontal: curve,),
      //padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
      width: width / 3,
      height: height,
      decoration: BoxDecoration(
        color: MyColors.metal,
        image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
        NetworkImage(image.toString()) as ImageProvider,
            fit: BoxFit.contain),
        borderRadius: BorderRadius.all(Radius.circular(curve*0),),
      ),
    ),
    //SizedBox(height: curve/2+1,),
    Container(
    height: height,
    width: width*2/3 - curve*4,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    flex: 1,
    child: Row(
    children: [
    headText(head, color: MyColors.black),
    Expanded(child: SizedBox()),
    IconButton(onPressed: ()=> delete!(), icon: Icon(Icons.clear, color: MyColors.bodyText1,))

    ],
    ),
    ),
    Expanded(
    flex: 1,
    child: bodyText1(name.toString(),scale: 1.1, padding: 0.0, align: TextAlign.start),
    ),
    Expanded(
    flex: 1,
    child: bodyText1(AppLocalizations.of(context)!.translate('Size:') + ' $size',scale: 0.9,color: MyColors.bodyText1, padding: 0.0, align: TextAlign.start, padV: height/10*0),
    ),
    Expanded(
    flex: 2,
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Container(
    width: MediaQuery.of(context).size.width/3.5,
    height: MediaQuery.of(context).size.width/9,
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
    onPressed: quantity == 1? null : ()=> quantityMin!(),
    ),),
    Expanded(
    flex: 1,
    child: headText(quantity.toString(), color: MyColors.black),
    ),
    Expanded(
    flex: 1,
    child: IconButton(
    icon: Icon(Icons.add_outlined),
    onPressed: quantityAdd== null? null : ()async=> await quantityAdd(),
    ),),
    ],
    ),
    ),
    Expanded(child: SizedBox()),
    Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    isSale? bodyText1(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0),scale: 0.8, padding: MediaQuery.of(context).size.width/60*0, align: TextAlign.start, baseLine: true) : SizedBox(height: 0.0,),
    headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, sale),scale: 0.8, color: isSale? MyColors.novelBlue: MyColors.black),
    ],
    )
    ],
    )
    ),
    ],
    ),
    ),
    ],
    )
    );
  }

  cardWishlist(
      {curve,
        height,
        image,
        head,
        name,
        size,
        price,
        sale,
        backgroundColor,
        quantity,
        Function()? delete,
        Function()? addToCArt,
      }){
    quantity??= 1;
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/3;
    var width = MediaQuery.of(context).size.width;
    head??= "Trendyol";
    name??= "T-shirt Summer VIB";
    price??=119.99;
    size??= 'XL';
    bool isSale = false;
    if(sale == null || sale==0) {
      sale = 0;
    }else{
      isSale = true;
    }
    backgroundColor??= MyColors.white;
    return Container(
      //alignment: Alignment.centerLeft,
      height: height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: curve/2,),
      padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve/2, bottom: curve/2,),
      child: Row(
        children: [
      Container(
      margin: EdgeInsets.symmetric(horizontal: curve,),
      //padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
      width: width / 3,
      height: height,
      decoration: BoxDecoration(
        color: MyColors.metal,
        image: DecorationImage(image: image == null ? AssetImage('assets/images/lets.png') as ImageProvider:
        NetworkImage(image.toString()) as ImageProvider,
            fit: BoxFit.contain),
        borderRadius: BorderRadius.all(Radius.circular(curve*0),),
      ),
    ),
    //SizedBox(height: curve/2+1,),
    Container(
    height: height,
    width: width*2/3 - curve*4,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    flex: 1,
    child: Row(
    children: [
    headText(head, color: MyColors.black),
    Expanded(child: SizedBox()),
    IconButton(onPressed: ()=> delete!(), icon: Icon(Icons.clear, color: MyColors.bodyText1,))
    ],
    ),
    ),
    Expanded(
    flex: 1,
    child: bodyText1(name.toString(),scale: 1.1, padding: 0.0, align: TextAlign.start),
    ),
    Expanded(
    flex: 3,
    child:
    Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    isSale? bodyText1(currencyValue['CurMark'] + ' '  + getPriceFit(price, 0.0),scale: 0.9, padding: MediaQuery.of(context).size.width/60*0, align: TextAlign.start, baseLine: true) : SizedBox(height: 0.0,),
    headText(currencyValue['CurMark'] + ' '  + getPriceFit(price, sale),scale: 0.9, color: isSale? MyColors.novelBlue : MyColors.gray, paddingH: isSale? MediaQuery.of(context).size.width/60:0.0, paddingV: 0.0),
    ],
    ),
    GestureDetector(
    child: Container(
    width: MediaQuery.of(context).size.width/4,
    height: height/3.5,
    decoration: BoxDecoration(
    color: MyColors.white,
    border: Border.all(
    color: MyColors.mainColor
    ),
    borderRadius: BorderRadius.all(Radius.circular(curve/2)),
    ),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    bodyText1(AppLocalizations.of(context)!.translate('Shop now'), color: MyColors.mainColor, padding: 0.0),
    ],
    )
    ),
    onTap: ()=> addToCArt!(),
    ),
    // raisedButton(curve, width/4, AppLocalizations.of(context)!.translate('Add to cart'), null, ()=> addToCArt!(), height: height/5,)
    ],
    )
    ),
    ],
    ),
    ),
    ],
    )
    );
    }


  cardAddress(
      {curve,
        height,
        mobile,
        name,
        location,
        backgroundColor,
        Function()? delete,
        Function()? edit,
        bool? selected,
      }){
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/3;
    var width = MediaQuery.of(context).size.width;
    name??= "Omar Hasan";
    mobile??='963 938 025 347';
    location??= 'ST (street), CT (court), AVE (avenue), BLVD (boulevard).';
    backgroundColor??= MyColors.white;
    selected??=false;
    return Container(
      //alignment: Alignment.centerLeft,
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: backgroundColor,
          border: Border.all(color: selected ? MyColors.mainColor: backgroundColor, width: 2),
        ),
        margin: EdgeInsets.symmetric(vertical: curve/2, horizontal: curve),
        padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
        child: Column(
          children: [
            Row(
              children: [
                headText(name, color: MyColors.black),
                Expanded(child: SizedBox()),
                IconButton(onPressed: ()=> edit!(), icon: Icon(Icons.edit_outlined, color: MyColors.mainColor,)),
                IconButton(onPressed: ()=> delete!(), icon: Icon(Icons.delete_outline, color: MyColors.novelBlue,)),
                //SizedBox(height: curve/2+1,),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Icon(Icons.call_outlined),
                ),
                SizedBox(width: curve,),
                Flexible(
                  flex: 5,
                  child: bodyText1(mobile.toString(),scale: 1.1, align: TextAlign.start, padding: 0.0),
                )
              ],
            ),
            SizedBox(height: curve/2,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Icon(Icons.location_on_outlined),
                ),
                SizedBox(width: curve,),
                Flexible(
                  flex: 5,
                  child: bodyText1(location.toString(),scale: 1.1, align: TextAlign.start, padding: 0.0),
                )
              ],
            ),

          ],
        )
    );
  }

  cardOrder(
      {curve,
        height,
        date,
        name,
        product,
        status,
        total,
        backgroundColor,
        Function()? delete,
        Function()? edit,
        bool? selected,
      }){
    _row(txtLeft, txtRight){
      return Row(
        children: [
          bodyText1(txtLeft, color: MyColors.card),
          Expanded(child: SizedBox()),
          bodyText1(txtRight, color: MyColors.black),
        ],
      );
    }
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.5;
    var width = MediaQuery.of(context).size.width;
    name??= "Omar Hasan";
    backgroundColor??= MyColors.white;
    selected??=false;
    return Container(
      //alignment: Alignment.centerLeft,
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: selected ? MyColors.mainColor: backgroundColor, width: 2),
        ),
        margin: EdgeInsets.symmetric(vertical: curve/2, horizontal: curve),
        padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
        child: Column(
          children: [
            Row(
              children: [
                headText(name, color: MyColors.black, paddingH: MediaQuery.of(context).size.width/20),
                Expanded(child: SizedBox()),
                //IconButton(onPressed: ()=> delete!(), icon: Icon(Icons.close, color: MyColors.card,)),
                //SizedBox(height: curve/2+1,),
              ],
            ),
            _row(AppLocalizations.of(context)!.translate('Product'),product.toString()),
            _row(AppLocalizations.of(context)!.translate('Status'),status.toString()),
            _row(AppLocalizations.of(context)!.translate('Total'),currencyValue['CurMark'] + ' ' + total.toString()),
            Row(
              children: [
                bodyText1(date, color: MyColors.black),
                Expanded(child: SizedBox()),
                IconButton(onPressed: ()=> edit!(), icon: Icon(Icons.remove_red_eye_outlined, color: MyColors.card,)),
              ],
            ),
          ],
        )
    );
  }

  cardOrderInformation(
      {curve,
        height,
        date,
        name,
        paymentMethod,
        shippingMethod,
        location,
        backgroundColor,
        Function()? delete,
        Function()? edit,
        bool? selected,
      }){
    _row(txtLeft, txtRight){
      return Row(
        children: [
          bodyText1(txtLeft, color: MyColors.card),
          Expanded(child: SizedBox()),
          bodyText1(txtRight, color: MyColors.black),
        ],
      );
    }
    curve??= MediaQuery.of(context).size.width/30;
    height??= MediaQuery.of(context).size.width/2.1;
    var width = MediaQuery.of(context).size.width;
    name??= "Omar Hasan";
    backgroundColor??= MyColors.white;
    selected??=false;
    return Container(
      //alignment: Alignment.centerLeft,
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: selected ? MyColors.mainColor: backgroundColor, width: 2),
        ),
        margin: EdgeInsets.symmetric(vertical: curve/2, horizontal: curve),
        padding: EdgeInsets.only(left: curve, right: curve, top: curve/2, bottom: curve/2,),
        child: Column(
          children: [
            Row(
              children: [
                headText(name, color: MyColors.black, paddingH: MediaQuery.of(context).size.width/20),
                Expanded(child: SizedBox()),
                bodyText1(date.toString(), color: MyColors.black),
                //SizedBox(height: curve/2+1,),
              ],
            ),
            _row(AppLocalizations.of(context)!.translate('Payment Method'),paymentMethod.toString()),
            _row(AppLocalizations.of(context)!.translate('Shipping Method'),shippingMethod.toString()),
            driver(padV: MediaQuery.of(context).size.width/30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, size: MediaQuery.of(context).size.width/13, color: MyColors.bodyText1,),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.3,
                  child: bodyText1(location, align: TextAlign.start),
                ),
              ],
            )
          ],
        )
    );
  }

  miniContainer(_child, height){
    //if(lng==2)height = height*1.2;
    var curve = height / 2;
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2*0),
      decoration: BoxDecoration(
        color: MyColors.novelBlue,
        borderRadius: BorderRadius.all(Radius.circular(curve)),
      ),
      child: _child,
    );
  }

  progress(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.white.withOpacity(0.5),
      ),
      //color: MyColors.red,
      child: GradientProgressIndicator(
        radius: MediaQuery.of(context).size.width/4,
        duration: 5,
        strokeWidth: MediaQuery.of(context).size.width/40,
        gradientStops: const [
          0.2,
          0.8,
        ],
        gradientColors: const [
          Color(0x8e000eff),
          Color(0xff00159d),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JumpingText('.......',
              //end: Offset(0.5, -0.1),

              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/18,
                color: MyColors.mainColor,
                fontFamily: 'SairaBold',
                // fontStyle: FontStyle.italic,
              ),

            ),
          ],
        ),
      ),
    );
  }

  starRow(raduis, _starNum, {marginLeft}){
    marginLeft??=raduis*1.1;
    return Container(
      //margin: EdgeInsets.only(left: marginLeft),
      padding: EdgeInsets.symmetric(horizontal: raduis/16*0, vertical: raduis/30),
      width: raduis/5*5.7,
      //alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Icon(_starNum >= 1 ? Icons.star: Icons.star_outline,color: MyColors.novelBlue, size: raduis/5,),
          Icon(_starNum >= 2 ? Icons.star: Icons.star_outline,color: MyColors.novelBlue, size: raduis/5,),
          Icon(_starNum >= 3 ? Icons.star: Icons.star_outline,color: MyColors.novelBlue, size: raduis/5,),
          Icon(_starNum >= 4 ? Icons.star: Icons.star_outline,color: MyColors.novelBlue, size: raduis/5,),
          Icon(_starNum >= 5 ? Icons.star: Icons.star_outline,color: MyColors.novelBlue, size: raduis/5,),
        ]
        /*[
          Icon(Icons.star,color: _starNum >= 1 ? MyColors.orange: MyColors.gray, size: raduis/5,),
          Icon(Icons.star,color: _starNum >= 2 ? MyColors.orange: MyColors.gray, size: raduis/5,),
          Icon(Icons.star,color: _starNum >= 3 ? MyColors.orange: MyColors.gray, size: raduis/5,),
          Icon(Icons.star,color: _starNum >= 4 ? MyColors.orange: MyColors.gray, size: raduis/5,),
          Icon(Icons.star,color: _starNum >= 5 ? MyColors.orange: MyColors.gray, size: raduis/5,),
        ]*/
        ,
      ),
      /*decoration: BoxDecoration(
        color: MyColors.mainColor,
        borderRadius: BorderRadius.circular(raduis/7),
      ),*/
    );
  }

  showImage(src){
    showImageViewer(
        context, src
    );
  }
/*
  pickFileAsBase64String() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      type: FileType.custom
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      final bytes = await File(file.path!).readAsBytesSync();
      String vbase= await base64Encode(bytes);
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      if(file.extension == 'pdf') await createPdf(vbase.toString());
      return vbase.toString();
    } else {
      // User canceled the picker
      return null;
    }
  }
*/
  cardOffers(curve, {logo, toolImage, disacount, toolName, companyName}){
    var raduis = MediaQuery.of(context).size.width/12;
    disacount??= '40';
    toolName??= 'motors and vans';
    companyName??= 'Hasan engineering';
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: curve*5.7,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(top: raduis*4/3,left: raduis/4, right: raduis/4),
                child: CircleAvatar(
                  child: headText(disacount.toString() + '%', color: MyColors.white, scale: 0.6),
                  radius: curve,
                  backgroundColor: MyColors.mainColor,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(image: toolImage == null ? AssetImage("assets/images/background.png") : NetworkImage(toolImage) as ImageProvider, fit: BoxFit.cover),
                  //color: containerColor.withOpacity(0.8),
                  /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                  border: Border.all(
                    color: MyColors.mainColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(curve),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundImage: logo == null
                    ? const AssetImage('assets/images/Logo1.png') as ImageProvider
                    : NetworkImage(logo),
                child: ClipOval(
                  child: logo == null
                      ? Image.asset('assets/images/Logo1.png')
                      : Image.network(logo),
                ),
                radius: raduis,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
        headText(toolName + AppLocalizations.of(context)!.translate(' Kit ') + disacount.toString() + ' % ' + AppLocalizations.of(context)!.translate('OFF'),scale: 0.45, maxLine: 2, paddingV: MediaQuery.of(context).size.height/100, paddingH: raduis/4),
        bodyText1(companyName.toString(),color: MyColors.red),

      ],
    )
    ;

  }
/*
  createPdf(base64String) async {
    var bytes = base64Decode(base64String.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/lastOpenedOffer.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    doc = await PDFDocument.fromFile(file);
    //return file;
  }
*/
  String getBase64FileType(String base64String) {
    print('ccc');
    switch (base64String.characters.first) {
      case '/':
      //return 'jpeg';
        return _typeImage;
      case 'i':
      //return 'png';
        return _typeImage;
      case 'R':
      //return 'gif';
        return _typeImage;
      case 'U':
        return 'webp';
      case 'J':
      //return 'pdf';
        return _typePdf;
      default:
        return 'unknown';
    }
  }

  static const _typeImage = 'image';
  static const _typePdf = 'pdf';
/*
  viewFileBase64(base64String) {
    widget(String type){
      switch (type) {
        case _typeImage:{
          var src = Image.memory(base64Decode(base64String),fit: BoxFit.cover,);
          return Container( width: double.infinity,child: src,);
        }
        case _typePdf:{
          return Center(child: PDFViewer(document: doc));
        }
      }
    }
    return widget(getBase64FileType(base64String));
  }
  */
}

