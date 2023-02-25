class ProfileResponse {
  ProfileData data;

  ProfileResponse({this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ProfileData {
  int id;
  String name;
  String username;
  String email;
  String phone;
  int isPhoto;
  int isCopyToMe;
  String companyName;
  int isCompanyLogo;
  int companyId;
  int driverLicenceId;
  String driverLicence;
  String hireDate;
  String birthDate;
  int managerId;
  String manager;
  int officeId;
  String office;
  int teamId;
  String team;

  ProfileData(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.isPhoto,
      this.isCopyToMe,
      this.companyName,
      this.isCompanyLogo,
      this.companyId,
      this.driverLicenceId,
      this.driverLicence,
      this.hireDate,
      this.birthDate,
      this.managerId,
      this.manager,
      this.officeId,
      this.office,
      this.teamId,
      this.team});

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    isPhoto = json['isPhoto'];
    isCopyToMe = json['isCopyToMe'];
    companyName = json['companyName'];
    isCompanyLogo = json['isCompanyLogo'];
    companyId = json['companyId'];
    driverLicenceId = json['driverLicenceId'];
    driverLicence = json['driverLicence'];
    hireDate = json['hireDate'];
    birthDate = json['birthDate'];
    managerId = json['managerId'];
    manager = json['manager'];
    officeId = json['officeId'];
    office = json['office'];
    teamId = json['teamId'];
    team = json['team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['isPhoto'] = this.isPhoto;
    data['isCopyToMe'] = this.isCopyToMe;
    data['companyName'] = this.companyName;
    data['isCompanyLogo'] = this.isCompanyLogo;
    data['companyId'] = this.companyId;
    data['driverLicenceId'] = this.driverLicenceId;
    data['driverLicence'] = this.driverLicence;
    data['hireDate'] = this.hireDate;
    data['birthDate'] = this.birthDate;
    data['managerId'] = this.managerId;
    data['manager'] = this.manager;
    data['officeId'] = this.officeId;
    data['office'] = this.office;
    data['teamId'] = this.teamId;
    data['team'] = this.team;
    return data;
  }
}

class ProfileUpdateRequest {
  String name;
  String phone;
  String photo;
  String isDeletePhoto;
  String isCopyToMe;
  String companyId;
  String companyLogo;
  String companyName;
  String isDeleteCompanyLogo;

  ProfileUpdateRequest(
      {this.name,
      this.phone,
      this.photo,
      this.isDeletePhoto,
      this.isCopyToMe,
      this.companyId,
      this.companyLogo,
      this.companyName,
      this.isDeleteCompanyLogo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['photo'] = this.photo;
    data['isDeletePhoto'] = this.isDeletePhoto;
    data['isCopyToMe'] = this.isCopyToMe;
    data['companyId'] = this.companyId;
    data['companyLogo'] = this.companyLogo;
    data['companyName'] = this.companyName;
    data['isDeleteCompanyLogo'] = this.isDeleteCompanyLogo;
    return data;
  }
}

class UpdateApiResponse {
  String data;
  String message;
  bool status;

  UpdateApiResponse({this.data, this.message, this.status});

  UpdateApiResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
