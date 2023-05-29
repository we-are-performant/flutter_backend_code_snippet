
import 'dart:convert' show json;

List<Address> addressFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

//Address model class 
class Address {
  int? addId;
  int? userId;
  String? address;
  String? streetNo;
  String? appartmentNo;
  String? lattitude;
  String? longitude;
  bool? primaryAddress = false;

  Address(
      {this.addId,this.userId,this.address, this.streetNo, this.appartmentNo, this.lattitude, this.longitude,this.primaryAddress});

  //Convert json object to Address object
  Address.fromJson(Map<String, dynamic> json) {
    addId = json['add_id'];
    userId = json['user_id'];
    address = json['address'];
    streetNo = json['street_no'];
    appartmentNo = json['appartment_no'];
    lattitude = json['latitude'];
    longitude = json['longitude'];
    primaryAddress =((json['primary_address']) == 1)?true:false;
  }

  //Convert Address object to json object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['add_id'] = addId;
    data['user_id'] = userId;
    data['address'] = address;
    data['street_no'] = streetNo;
    data['appartment_no'] = appartmentNo;
    data['latitude'] = lattitude;
    data['longitude'] = longitude;
    data['primary_address'] = primaryAddress;
    return data;
  }
}
