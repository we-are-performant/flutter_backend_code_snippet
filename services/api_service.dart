import 'dart:async';
import 'dart:convert';
import '../models/address_model/address_model.dart';
import '../models/login_response/User.dart';
import '../models/login_response/login_response.dart';
import '../models/package_model/package_list.dart';
import '../models/payment_model/payment_model.dart';
import '../utils/golbal_function_veriables.dart';
import '../utils/url.dart';
import 'package:http/http.dart' as http;

//This class handles all http requests
class ApiService{


  //Function to login
  Future<User> userLogin( String email, String password, String userType) async {

    //Initializing header for request
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    //Initializing body for rquest
    final body = jsonEncode({
      'email': email,
      'password': password,
      'user_type': userType});

    try {
      //fetching response from API
      final response = await http.post(Uri.parse(Url.Login_URL), headers: headers, body: body);

      //Handling response
      if (response.statusCode == 200) {
        final loginResponse =
        LoginResponse.fromJson(jsonDecode(response.body));

        if (loginResponse.status == "1" || loginResponse.status == "2") {
          // Successful login
          return loginResponse.user!;
        } else {
          throw Exception('Login failed: ${loginResponse.message}');
        }
      } else if (response.statusCode == 422) {
        throw Exception('Invalid request');
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during login: $e');
    }
  }



  //Function to register new user
  Future<User> registerUser(User user,String password) async {

    //Initializing header
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    //Initialize request body
    final body = jsonEncode({
      'first_name': user.firstName,
      'last_name': user.lastName,
      'email': user.email,
      'contact_no':user.contactNo,
      'passowrd':password
    });

    try {
      //fetching response from API
      final response = await http.post(Uri.parse(Url.Registration_URL), headers: headers, body: body);

      if (response.statusCode == 200) {
        //Success get registered user and auto login

        final loginResponse =
        LoginResponse.fromJson(jsonDecode(response.body));

        //Check response status and return corresponding response
        if (loginResponse.status == "1") {
          // Successful registred
          //Return User Object
          return loginResponse.user!;
        } else {
          throw Exception('Login failed: ${loginResponse.message}');
        }
      } else if (response.statusCode == 422) {
        throw Exception('Invalid request');
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during login: $e');
    }
  }





  //Function to update password
  //This function old and current password to API which checks if old password matches and updates new pasword
  Future<String> updatePassword(String bearerToken, String oldPass,String newPass) async {
    //Initialize http client
      var client = http.Client();

      try {
        var response = await client.post(
            Uri.parse(Url.RESET_PASSWORD),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $bearerToken',
            },
            body: jsonEncode({
              'dec_pwd': oldPass,
              'new_password':newPass,
            })
        );

        //Check http response
        if (response.statusCode >= 200 && response.statusCode <= 200) {
          //decode json object and convert to map
          Map<String, dynamic> data = json.decode(response.body);
          //Check status of response and handle message
          if(data["status"] == "1"){
           return "Password updated succesfully" ;
          }else{
            //throws exception this message returned from API
            throw Exception('${data['message']}');
          }
        }else{
          throw Exception('Failed to update password ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('An error occurred during password update: $e');
      }
    }


    //This function places order and saves users payment method if users has checked save payment method
  Future<int> placeOrder(context,PaymentModel paymentModel,String paymentMethod,String? encryptedCardNumber,String? encryptedDate,String? nameOnCard,bool savePaymentMethod) async {

    //Converts customers slected packages into json encoded list
      String packageList = jsonEncode(PackageList.packageList.map((e) => e.toJson()).toList());
      var client = http.Client();

      //fetch users current address from shared preferences
      Address address = await getAddress();

      try{
        var response;
        //Check if user wants to save payment method
        if(savePaymentMethod){

          response = await client.post(
              Uri.parse(Url.ADD_ORDER),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${PackageList.token}',
              },
              //Encode data to json
              body: jsonEncode({
                "pickup_type":PackageList.packageType,
                "payment_method":paymentMethod,
                "pickup_date":convertDateToString(PackageList.date!),
                "pickup_time_id":PackageList.time,
                "pickup_address":address.address,
                "pickup_lat":address.lattitude,
                "pickup_lng":address.longitude,
                "street_no":address.streetNo,
                "appartment_no":address.appartmentNo,
                "total_customer_amt":PackageList.totalCustomerAmount,
                "total_partner_amt":PackageList.totalPartnerAmount,
                "payment_id":paymentModel.payment_id,
                "paypal_amount":paymentModel.paypal_amount,
                "currency":paymentModel.currency,
                "payment_status":paymentModel.payment_status,
                "package_details":packageList,
                "card_name":nameOnCard,
                "card_no":encryptedCardNumber!,
                "address_id":address.addId,
                "card_exp_date":encryptedDate,


              })
          );}else{
          response = await client.post(
              Uri.parse(Url.ADD_ORDER),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${PackageList.token}',
              },
              body: jsonEncode({
                "pickup_type":PackageList.packageType,
                "payment_method":paymentMethod,
                "pickup_date":PackageList.date,
                "pickup_time_id":PackageList.time,
                "pickup_address":address.address,
                "pickup_lat":address.lattitude,
                "pickup_lng":address.longitude,
                "street_no":address.streetNo,
                "appartment_no":address.appartmentNo,
                "total_customer_amt":PackageList.totalCustomerAmount,
                "total_partner_amt":PackageList.totalPartnerAmount,
                "payment_id":paymentModel.payment_id,
                "paypal_amount":paymentModel.paypal_amount,
                "currency":paymentModel.currency,
                "payment_status":paymentModel.payment_status,
                "package_details":packageList,
                "address_id":address.addId,


              })
          ).timeout(const Duration(seconds: 20));
        }

        //Check response status of http call and correspond accordingly
        if(response.statusCode >= 200 && response.statusCode <= 299){
          //Convert json response into map
          Map<String, dynamic> map = jsonDecode(response.body); // import 'dart:convert';
          //Get message from response
          String message = map['message'];


          if(message == "Added Successfully"){
            int orderNo = map['order_no'];
            return orderNo;

          }else{
            //Throw exception with message
            throw Exception(message);
          }
        }else{
          //http request failed throw exception with status code to handle in UI
          throw Exception(response.statusCode);
        }

      } catch(e){
        //throw exception and send error to handle in UI
        throw Exception(e);
      }

    }



}
