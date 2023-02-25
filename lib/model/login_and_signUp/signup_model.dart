import 'package:bidbot/const/widget.dart';

class LoginSignUpValue {
  String subscriptionId;
  String verticalId;
  LoginSignUpValue({this.verticalId, this.subscriptionId});
}

class SignUpRequest {
  String subscriptionId;
  String verticalId;
  String name;
  String phone;
  String company;
  String email;
  String password;

  SignUpRequest(
      {this.name,
      this.password,
      this.company,
      this.email,
      this.phone,
      this.verticalId,
      this.subscriptionId});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "subscriptionId": "${GlobalValues.subscriptionId}", //"7686051",
      "verticalId": "324", //"324",
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
      "company": company,
      "address": "",
      "city": "",
      "countryId": "",
      "stateId": "",
      "zipCode": "",
      "businessTypeId": "",
      "url": "",
    };
    return map;
  }
}
