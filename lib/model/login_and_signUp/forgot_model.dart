class ForgotRequest {
  String emailAddress;
  String subscriptionId;
  String verticalId;
  String appId;

  ForgotRequest(
      {this.emailAddress, this.subscriptionId, this.verticalId, this.appId});

  /* ForgotRequest.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    appId = json['appId'];
  }*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "emailAddress": emailAddress,
      "subscriptionId": "7686051",
      "verticalId": "324",
      "appId": "2421",
    };
    return map;
    /* final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress;
    data['subscriptionId'] = "7686051";
    data['verticalId'] = "324";
    data['appId'] = "2421";
    return data;*/
  }
}

class ForgotResponse {
  bool status;
  String message;
  var data;

  ForgotResponse({this.status, this.message, this.data});

  ForgotResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}
