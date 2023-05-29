import 'package:delayno/models/package_model/package_model.dart';
import 'package:intl/intl.dart';
class PackageList{
  static DateTime? date;
  static int index = 0;
  static String? packageType;
  static String? time;
  static String? address;
  static List<PackageModel> packageList = [];
  static double totalCustomerAmount = 0;
  static double totalPartnerAmount = 0;
  static String? token;

  //Convert PackageList object to json
  static Map<String, dynamic> toJson() => {
    "date": DateFormat('dd-MM-yyyy').format(date!),
    "time": time,
    "total_cost":totalCustomerAmount,
    "packages": packageList.map((e) => e.toJson()).toList(),
  };
}
