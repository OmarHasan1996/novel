import 'dart:convert';

import 'package:novel/screen/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:get/get.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyWidget.dart';
import '../api.dart';
import '../color/MyColors.dart';
import '../localizations.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';


bool chVer = false;
// ignore: must_be_immutable
class Verification extends StatefulWidget {
  var value;
  String email;
  String password;
  String verCode;

//  Data":[{"Id":"ec9316ec-d4c7-478b-10f4-08da195f8290","Name":"omar hsn","LastName":"last name","Mobile":"+97493802534","Email":"omar.suhail.hasan@gmail.com","Password":"123456","VerificationCode":"241280","IsVerified":false,"Type":0,"Dob":null,"ImagePath":null,"File":null,"EventDate":null,"FBKey":null,"Lang":null,"GroupUsers":[]}],"Total":1,"AggregateResults":null,"Errors":null

  Verification({required this.value, required this.email, required this.password, required this.verCode});
  @override
  _VerificationState createState() =>
      _VerificationState(value, email, password, verCode);
}

class _VerificationState extends State<Verification> {
  var value;
  String email;
  String password;
  bool newPassword = false;

  _VerificationState(this.value, this.email, this.password, this.verCode){
    password  != ''? newPassword = true: newPassword = false;
  }

  int codeLength = 0;
  String code = "";
  var verCode;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var requiredValidator = RequiredValidator(errorText: 'Required'.tr);
  final bool _secureText = true;

  MyAPI? myAPI;
  MyWidget? _m;

  @override
  void initState() {
    super.initState();
    chVer = false;
  }

  @override
  Widget build(BuildContext context) {
    myAPI = MyAPI(context: context);
    requiredValidator = RequiredValidator(errorText: AppLocalizations.of(context)!.translate('Required'));
    _m = MyWidget(context);
    var curve = MediaQuery.of(context).size.height/30;
    Null Function()? active;
    if (codeLength == 6) {
      active = () {
        print(value);
        ver();
      };
    } else {
      active = null;
    }
    var heightSpace = MediaQuery.of(context).size.height/40;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            MyColors.topGradiant,
            MyColors.white,
            MyColors.topGradiant,
          ],
            transform: GradientRotation(3.14 / 4),),
        ),
        /*
        const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/lets_background.png"), fit: BoxFit.cover)),*/
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40, horizontal: MediaQuery.of(context).size.width/20),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*!newPassword?
                        SvgPicture.asset(
                          'assets/images/Logo1.png',
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/3,
                        ):*/
                        SizedBox(
                          height: MediaQuery.of(context).size.height/3,
                        ),
                        SizedBox(
                          height: heightSpace*1,
                        ),
                        Column(
                          //height: MediaQuery.of(context).size.height/5,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 0, horizontal: MediaQuery.of(context).size.width/20),
                              child: _m!.headText(
                                  AppLocalizations.of(context)!.translate("Enter the 6-digit code sent to your email"),
                                  scale: 0.9, maxLine: 2, color: MyColors.bodyText1
                              ),
                            ),
                            SizedBox(
                              height: heightSpace,
                            ),
                            buildCodeBox(first: true, last: false),
                          ],
                        ),
                        //Expanded(child: Container()),
                        SizedBox(
                          height: heightSpace*9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _m!.bodyText1(
                                AppLocalizations.of(context)!.translate("Didn't receive the code?"),
                                padding: 0.0, color: MyColors.bodyText1
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: ()=> resend(),
                              child: _m!.headText(
                                  AppLocalizations.of(context)!.translate('Resend'),
                                  scale: 0.9, color: MyColors.novelBlue
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heightSpace,
                        ),
                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.4, AppLocalizations.of(context)!.translate('Confirm'), 'assets/images/user_profile.svg', active),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: chVer?
                  _m!.progress()
                      :
                  const SizedBox(),
                )
              ],
            ),
            snackBar:  SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('Tap back again to leave')),
          ),
        ),
      ),
    ),
    );
  }

  Widget buildCodeBox({required bool first, last}) {
    return Center(
        child: OTPTextField(
          spaceBetween: MediaQuery.of(context).size.width/40,
          //contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
          keyboardType: TextInputType.number,
          otpFieldStyle: OtpFieldStyle(
            borderColor: MyColors.bodyText1,
            focusBorderColor: MyColors.mainColor,
            disabledBorderColor: MyColors.bodyText1,
            enabledBorderColor: MyColors.bodyText1,
          ),
          length: 6,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.center,
          fieldWidth:  MediaQuery.of(context).size.width/9,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: MediaQuery.of(context).size.height/90,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/15,
            color: MyColors.mainColor,
            fontFamily: 'Gotham'
          ),
          onChanged: (pin) {
            codeLength = pin.length;
            code = pin;
          },
          onCompleted: (pin) {
          },

        )

      /*TextField(
          autofocus: true,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,color: Colors.white),
              borderRadius: BorderRadius.circular(12),

            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,color: Colors.yellow),
              borderRadius: BorderRadius.circular(12),
            )
          ),
        ),*/

    );
  }

  Future ver() async {
    setState(() => chVer = true);
    if(newPassword){
      _newPasswordVer();
    }else{
      _firstVer();
    }
  }

  _firstVer() async{
    http.Response response = await myAPI!.ver(value, code);

    if (response.statusCode == 200 && jsonDecode(response.body)['status'].toString() == 200.toString()) {
      print(response.body);
/*      try {
        if (jsonDecode(response.body)["Data"][0]['txtParam'].toString() ==
            code) {

          http.Response response = await http.post(
              Uri.parse('https://mr-service.online/api/Auth/login'),
              body: jsonEncode({"UserName": email, "Password": password}),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json",
              });
          if (response.statusCode == 200) {
            print(response.body);
            setState(() {
              if (jsonDecode(response.body)['error_des'] == "") {
               var tokenn =
                    jsonDecode(response.body)["content"]["Token"].toString();
                getServiceData(tokenn);

              }
            });
          }
        }
      } catch (e) {
        if (jsonDecode(response.body)['success'].toString() == "false") {
          setState(() => chVer = false);

          Flushbar(
            icon: Icon(
              Icons.error_outline,
              size: 32,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: 'Wrong Code'.tr,
          ).show(context);
        }
      }*/
      // Navigator.of(context).pushNamed('sign_in');
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('email', email);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder:(context)=>SignINScreen()),
            (Route<dynamic> route) => false,
      );
    }
    else if(jsonDecode(response.body)['status'] == 424){
      //Navigator.of(context).pushNamed('main_screen');
      MyAPI(context: context).flushBar('Confirm code is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    }
    else if(jsonDecode(response.body)['status'] == 423){
      //Navigator.of(context).pushNamed('main_screen');
      MyAPI(context: context).flushBar('User id is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    } else {
      //Navigator.of(context).pushNamed('main_screen');
      //MyAPI(context: context).flushBar('Confirm code is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    }
    setState(() => chVer = false);
  }

  _newPasswordVer() async{
    http.Response response = await myAPI!.resetPassword(value, code, password);

    if (response.statusCode == 200 && jsonDecode(response.body)['status'] == 200) {
      print(response.body);
/*      try {
        if (jsonDecode(response.body)["Data"][0]['txtParam'].toString() ==
            code) {

          http.Response response = await http.post(
              Uri.parse('https://mr-service.online/api/Auth/login'),
              body: jsonEncode({"UserName": email, "Password": password}),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json",
              });
          if (response.statusCode == 200) {
            print(response.body);
            setState(() {
              if (jsonDecode(response.body)['error_des'] == "") {
               var tokenn =
                    jsonDecode(response.body)["content"]["Token"].toString();
                getServiceData(tokenn);

              }
            });
          }
        }
      } catch (e) {
        if (jsonDecode(response.body)['success'].toString() == "false") {
          setState(() => chVer = false);

          Flushbar(
            icon: Icon(
              Icons.error_outline,
              size: 32,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: 'Wrong Code'.tr,
          ).show(context);
        }
      }*/
      // Navigator.of(context).pushNamed('sign_in');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder:(context)=>SignINScreen()),
            (Route<dynamic> route) => false,
      );
    }
    else if(jsonDecode(response.body)['status'] == 424){
      //Navigator.of(context).pushNamed('main_screen');
      MyAPI(context: context).flushBar('Confirm code is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    }
    else if(jsonDecode(response.body)['status'] == 423){
      //Navigator.of(context).pushNamed('main_screen');
      MyAPI(context: context).flushBar('User id is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    } else {
      //Navigator.of(context).pushNamed('main_screen');
      //MyAPI(context: context).flushBar('Confirm code is invalid!');
      print(response.statusCode);
      print('A network error occurred');
    }
    setState(() => chVer = false);
  }

  void resend() async{
    setState(() => chVer = true);
    //await myAPI!.resend(value);
    await myAPI!.sendPushMessage(verCode, 'Activate Code', null);
    setState(() => chVer = false);
  }

}
