class TermAndConditionResponse {
  bool status;
  String message;
  List<TermAndConditionData> data;

  TermAndConditionResponse({this.status, this.message, this.data});

  TermAndConditionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <TermAndConditionData>[];
      json['data'].forEach((v) {
        data.add(new TermAndConditionData.fromJson(v));
      });
    }
  }
}

class TermAndConditionData {
  String id;
  String content;
  String description;

  TermAndConditionData({this.id, this.content, this.description});

  TermAndConditionData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    content = json['content'].toString();
    description = json['description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['description'] = this.description;
    return data;
  }
}
