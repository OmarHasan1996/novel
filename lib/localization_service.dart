import 'package:novel/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'localizations.dart';

class LocalizationService extends Translations{
  static const local =Locale('en','US');
  static const fallBackLocale = Locale('en','US');
  static  List<String> langs =['English','France','Arabic','Turkish'];
  static String MyLang = 'English';
  static final locales = [
    const Locale('en','US'),
    const Locale('fr','FR'),
    const Locale('ar','AR'),
    const Locale('tr','TR'),
  ];


  changeLocale(int lang, context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(lang == 0) {
      AppLocalizations.delegate.load(const Locale('en','US'));
      MyLang = 'English';
      langs =['English','France','Arabic','Turkish'];
    }else if(lang == 1){
      AppLocalizations.delegate.load(const Locale('fr','FR'));
      MyLang = 'France';
      langs =['English','France','Arab','Turkish'];
    }else if(lang == 2){
      AppLocalizations.delegate.load(const Locale('ar','AR'));
      MyLang = 'العربية';
      langs =['الإنكليزية','الفرنسية','العربية','التركية'];
    }
    else{
      AppLocalizations.delegate.load(const Locale('en','US'));
      MyLang = 'English';
      langs =['English','France','Arabic'];
    }
    //langs =[AppLocalizations.of(context)!.translate('english'),AppLocalizations.of(context)!.translate('france'),AppLocalizations.of(context)!.translate('arabic')];
    final locale =getLocaleFromLanguage(lang);
    lng = lang;
    await MyAPI(context: context).updateUserLang(token, locale!.languageCode);
    sharedPreferences.setInt('lng', lng);
    Get.updateLocale(locale);
  }

  static Locale? getLocaleFromLanguage(int lang) {

    return locales[lang];

    return Get.locale;
  }

  static Locale getCurrentLocale(){
    final box = GetStorage();
    Locale defaultLocale;
    if(box.read('lng')!= null){
      final locale = getLocaleFromLanguage(box.read('lng'));
      defaultLocale = locale!;
    }
    else{
      defaultLocale=const Locale('en','US');
    }
    return defaultLocale;
  }

  String getCurrentLang(){
    final box = GetStorage();
    return box.read('lng') ?? 'English';
}

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => throw UnimplementedError();

}