/*class ProfileUpdateRequest {
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

class ProfileUpdateResponce {
  String data;
  String message;
  bool status;

  ProfileUpdateResponce({this.data, this.message, this.status});

  ProfileUpdateResponce.fromJson(Map<String, dynamic> json) {
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
}*/
