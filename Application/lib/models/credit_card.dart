import 'package:hive/hive.dart';

part 'credit_card.g.dart';

@HiveType(typeId: 1)
class CreditCard {
  @HiveField(0)
  final String number;
  @HiveField(1)
  final String holderName;
  @HiveField(2)
  final String expDate;

  CreditCard({
    required this.number,
    required this.holderName,
    required this.expDate,
  });
}
