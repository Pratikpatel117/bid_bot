// class LoginResponce {
//   LoginResponce({
//     this.status,
//     this.message,
//     this.data,
//   });
//   bool status;
//   String message;
//   List<Data> data;
//
//   LoginResponce.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     /*json.keys.contains('data');
//     if("data" == null){
//       data = [];
//     }*/
//     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
//   }
// }
//
// class Data {
//   Data({
//     this.employees,
//     this.mfa,
//     this.userToken,
//     this.token,
//   });
//   List<Employees> employees;
//   String mfa;
//   String userToken;
//   String token;
//
//   Data.fromJson(Map<String, dynamic> json) {
//     employees =
//         List.from(json['employees']).map((e) => Employees.fromJson(e)).toList();
//     mfa = json['mfa'].toString();
//     userToken = json['userToken'].toString();
//     token = json['token'].toString();
//   }
// }
//
// class Employees {
//   Employees({
//     this.employeeId,
//     this.name,
//     this.sphereId,
//     this.sphere,
//     this.sphereTypeId,
//     this.sphereType,
//     this.isFidoEnable,
//     this.customerId,
//     this.customerName,
//     this.contactId,
//     this.title,
//     this.sphereImage,
//   });
//   String employeeId;
//   String name;
//   String sphereId;
//   String sphere;
//   String sphereTypeId;
//   String sphereType;
//   String isFidoEnable;
//   String customerId;
//   String customerName;
//   String contactId;
//   String title;
//   String sphereImage;
//
//   Employees.fromJson(Map<String, dynamic> json) {
//     employeeId = json['employeeId'].toString();
//     name = json['name'].toString();
//     sphereId = json['sphereId'].toString();
//     sphere = json['sphere'].toString();
//     sphereTypeId = json['sphereTypeId'].toString();
//     sphereType = json['sphereType'].toString();
//     isFidoEnable = json['isFidoEnable'].toString();
//     customerId = json['customerId'].toString();
//     customerName = json['customerName'].toString();
//     contactId = json['contactId'].toString();
//     title = json['title'].toString();
//     sphereImage = json['sphereImage'].toString();
//   }
// }

class CustomerModel {
  String subscriptionId;
  String verticalId;
  String name;
  String appId;
  String sphereUrl;

  CustomerModel(
      {this.subscriptionId,
      this.verticalId,
      this.appId,
      this.name,
      this.sphereUrl});
}

class LoginRequest {
  String username;
  String password;
  String subscriptionId;
  String verticalId;
  String appId;
  String sphereUrl;
  LoginRequest(
      {this.password,
      this.username,
      this.subscriptionId,
      this.verticalId,
      this.appId,
      this.sphereUrl});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "subscriptionId": subscriptionId,
      "verticalId": verticalId,
      "username": username,
      "password": password,
      "appId": appId,
      "sphereTypeUrl": sphereUrl,
    };
    return map;
  }
}

/*class Customers {
    static var items: [CustomerData] = [
        CustomerData.init(subscriptionId: 9329, verticalId: 18, appId: 2421, sphereUrl: "bidlist-app.htm"),
        CustomerData.init(subscriptionId: 7686051, verticalId: 324, appId: 2421, sphereUrl: "bidlist-app.htm"),
    ]
}
*/

class ResponseModel {
  bool status;
  String message;
  List<LoginModel> data;

  ResponseModel({this.status, this.message, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LoginModel>[];
      json['data'].forEach((v) {
        data.add(new LoginModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginModel {
  List<Employees> employees;
  int mfa;
  String userToken;
  String token;

  LoginModel({this.employees, this.mfa, this.userToken, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees.add(new Employees.fromJson(v));
      });
    }
    mfa = json['mfa'];
    userToken = json['userToken'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employees != null) {
      data['employees'] = this.employees.map((v) => v.toJson()).toList();
    }
    data['mfa'] = this.mfa;
    data['userToken'] = this.userToken;
    data['token'] = this.token;
    return data;
  }
}

class Employees {
  int employeeId;
  String name;
  int sphereId;
  String sphere;
  int sphereTypeId;
  String sphereType;
  int isFidoEnable;
  int customerId;
  String customerName;
  String contactId;
  String title;
  String sphereImage;
  String office;
  int officeId;
  List<TermsAgreement> registrationConfidentialityAgreementTerms;

  Employees(
      {this.employeeId,
      this.name,
      this.sphereId,
      this.sphere,
      this.sphereTypeId,
      this.sphereType,
      this.isFidoEnable,
      this.customerId,
      this.customerName,
      this.contactId,
      this.title,
      this.sphereImage,
      this.office,
      this.officeId,
      this.registrationConfidentialityAgreementTerms});

  Employees.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    name = json['name'];
    sphereId = json['sphereId'];
    sphere = json['sphere'];
    sphereTypeId = json['sphereTypeId'];
    sphereType = json['sphereType'];
    isFidoEnable = json['isFidoEnable'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    contactId = json['contactId'].toString();
    title = json['title'];
    sphereImage = json['sphereImage'];
    office = json['office'];
    officeId = json['officeId'];
    if (json['registrationConfidentialityAgreementTerms'] != null) {
      registrationConfidentialityAgreementTerms = [];
      json['registrationConfidentialityAgreementTerms'].forEach((v) {
        registrationConfidentialityAgreementTerms
            .add(new TermsAgreement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['name'] = this.name;
    data['sphereId'] = this.sphereId;
    data['sphere'] = this.sphere;
    data['sphereTypeId'] = this.sphereTypeId;
    data['sphereType'] = this.sphereType;
    data['isFidoEnable'] = this.isFidoEnable;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['contactId'] = this.contactId;
    data['title'] = this.title;
    data['sphereImage'] = this.sphereImage;
    data['office'] = this.office;
    data['officeId'] = this.officeId;
    if (this.registrationConfidentialityAgreementTerms != null) {
      data['registrationConfidentialityAgreementTerms'] = this
          .registrationConfidentialityAgreementTerms
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class TermsAgreement {
  int termId;
  String termDescription;
  String termContent;

  TermsAgreement({this.termId, this.termDescription, this.termContent});

  TermsAgreement.fromJson(Map<String, dynamic> json) {
    termId = json['termId'];
    termDescription = json['termDescription'];
    termContent = json['termContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termId'] = this.termId;
    data['termDescription'] = this.termDescription;
    data['termContent'] = this.termContent;
    return data;
  }
}
