// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction()
      ..guestType = fields[0] as bool
      ..ordersList = (fields[1] as List).cast<dynamic>()
      ..productList = (fields[2] as List).cast<dynamic>()
      ..categoryList = (fields[3] as List).cast<dynamic>()
      ..subCategoryList = (fields[4] as List).cast<dynamic>()
      ..salesList = (fields[5] as List).cast<dynamic>()
      ..brandsList = (fields[6] as List).cast<dynamic>()
      ..shippingMethodsList = (fields[7] as List).cast<dynamic>()
      ..shopNowList = (fields[8] as List).cast<dynamic>()
      ..newArrivalList = (fields[9] as List).cast<dynamic>()
      ..homeSection1List = (fields[10] as List).cast<dynamic>()
      ..cartList = (fields[11] as List).cast<dynamic>()
      ..cartListTotal = (fields[12] as Map).cast<String, dynamic>()
      ..wishList = (fields[13] as List).cast<dynamic>()
      ..myAddress = (fields[14] as List).cast<dynamic>()
      ..selectedAddress = fields[15] as int
      ..countries = (fields[16] as List).cast<dynamic>()
      ..currency = (fields[17] as List).cast<dynamic>()
      ..currencyValue = (fields[18] as Map).cast<String, dynamic>()
      ..paymentCard = (fields[19] as List).cast<dynamic>()
      ..notificationAndEmail = fields[20] as bool
      ..userData = (fields[21] as Map).cast<dynamic, dynamic>()
      ..userInfo = (fields[22] as Map).cast<dynamic, dynamic>();
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.guestType)
      ..writeByte(1)
      ..write(obj.ordersList)
      ..writeByte(2)
      ..write(obj.productList)
      ..writeByte(3)
      ..write(obj.categoryList)
      ..writeByte(4)
      ..write(obj.subCategoryList)
      ..writeByte(5)
      ..write(obj.salesList)
      ..writeByte(6)
      ..write(obj.brandsList)
      ..writeByte(7)
      ..write(obj.shippingMethodsList)
      ..writeByte(8)
      ..write(obj.shopNowList)
      ..writeByte(9)
      ..write(obj.newArrivalList)
      ..writeByte(10)
      ..write(obj.homeSection1List)
      ..writeByte(11)
      ..write(obj.cartList)
      ..writeByte(12)
      ..write(obj.cartListTotal)
      ..writeByte(13)
      ..write(obj.wishList)
      ..writeByte(14)
      ..write(obj.myAddress)
      ..writeByte(15)
      ..write(obj.selectedAddress)
      ..writeByte(16)
      ..write(obj.countries)
      ..writeByte(17)
      ..write(obj.currency)
      ..writeByte(18)
      ..write(obj.currencyValue)
      ..writeByte(19)
      ..write(obj.paymentCard)
      ..writeByte(20)
      ..write(obj.notificationAndEmail)
      ..writeByte(21)
      ..write(obj.userData)
      ..writeByte(22)
      ..write(obj.userInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
