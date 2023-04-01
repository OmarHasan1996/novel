import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late bool guestType = false;

  @HiveField(1)
  late List ordersList = [];

  @HiveField(2)
  late List productList = [];

  @HiveField(3)
  late List categoryList = [];

  @HiveField(4)
  late List subCategoryList = [];

  @HiveField(5)
  late List salesList = [];

  @HiveField(6)
  late List brandsList = [1,2,3];

  @HiveField(7)
  late List shippingMethodsList = [1,2,3];

  @HiveField(8)
  late List shopNowList = [1,2,3,4];

  @HiveField(9)
  late List newArrivalList = [1,2,3,4];

  @HiveField(10)
  late List homeSection1List = [1,2,3];

  @HiveField(11)
  late List cartList = [];

  @HiveField(12)
  late Map<String,dynamic> cartListTotal = {};

  @HiveField(13)
  late List wishList = [];

  @HiveField(14)
  late List myAddress = [{'sale': 0}, {'sale': 20}, {'sale': 40}];

  @HiveField(15)
  late var selectedAddress=0;

  @HiveField(16)
  late List countries = [];

  @HiveField(17)
  late List currency = [];

  @HiveField(18)
  late Map<String,dynamic> currencyValue = {};//{"CurId": "5", "CurName": "Emirati Dirham", "CurShortname": "AED", "CurMark": "AED", "CurValue": "1"};

  @HiveField(19)
  late List paymentCard = [];

  @HiveField(20)
  late bool notificationAndEmail = false;

  @HiveField(21)
  late Map userData = {};

  @HiveField(22)
  late Map userInfo = {'email': 'omar.suhail.hasan@gmail.com','name': 'Omar Hasan', 'image': 'assets/images/Logo1.png', 'mobile': '+963 0938025347', 'city' : 'Syria', 'aboutYou': 'aboutYou'};

}