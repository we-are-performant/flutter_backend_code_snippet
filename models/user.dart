//User object class
class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? contactNo;
  String? email;
  String? deviceToken;
  int? emailVerification;
  String? lang;

  //User constructor pass data fields
  User(
      {this.userId, this.firstName, this.lastName, this.contactNo, this.email,this.deviceToken,this.emailVerification});
  

  //Convert json response to user object
  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactNo = json['contact_no'];
    email = json['email'];
    emailVerification = json['email_verified'];
    lang = json['lang'];
  }

  //Convert user object to json object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['contact_no'] = contactNo;
    data['email'] = email;
    data['email_verified'] = emailVerification;
    data['lang'] = lang;
    return data;
  }
}
