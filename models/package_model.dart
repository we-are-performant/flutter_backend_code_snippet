List<PackageModel> packageFromJson(List<dynamic> str) => List<PackageModel>.from(str.map((x) => PackageModel.fromJson(x)));
class PackageModel{


  String? serviceName;
  String? packageSize;
  String? scanData;
  String? type = "barcode";
  double? packageCost = 0;
  double? partnerAmt = 0;
  String? storeName ;
  String? remarks;

  double? get getPartnerAmt => partnerAmt;

  set setPartnerAmt(double? partnerAmt) {
    partnerAmt = partnerAmt;
  }

  PackageModel({
    this.serviceName,
    this.packageSize,
    this.packageCost,
    this.partnerAmt,
    this.scanData,
    this.storeName,
    this.type,
    this.remarks
  });

  String? get getServiceName => serviceName;

  set setServiceName(String? serviceName) {
    serviceName = serviceName;
  }

  double? get getPackageCost => packageCost;

  set setPackageCost(double packageCost) {
    packageCost = packageCost;
  }

  String? get getPackageSize => packageSize;

  set setPackageSize(String? packageSize) {
    packageSize = packageSize;
  }

  String? get getType => type;

  set setType(String? type) {
    type = type;
  }


  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    serviceName: json["service_name"],
    packageSize: json["package_size"],
    packageCost: double.parse(json["customer_amt"]),
    partnerAmt: double.parse(json["partner_amt"]),
    scanData: json["tracking_no"],
    storeName: json["store_name"],
    type: json["scan_type"],
    remarks: json["remarks"]
  );

  Map<String, dynamic> toJson() => {
    "shipping_service": serviceName,
    "package_size": packageSize,
    "customer_amt": packageCost,
    "partner_amt": partnerAmt,
    "tracking_no": scanData,
    "store_name": storeName,
    "scan_type": type,
    "remarks": remarks,
  };
}