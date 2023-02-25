class NotesListRequest {
  String employeeId;
  String projectId;
  String tabId;

  NotesListRequest({this.employeeId, this.projectId, this.tabId});

  NotesListRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    projectId = json['projectId'];
    tabId = json['tabId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['projectId'] = this.projectId;
    data['tabId'] = this.tabId;
    return data;
  }
}

class NotesListResponce {
  bool status;
  String message;
  List<NoteListData> data;

  NotesListResponce({this.status, this.message, this.data});

  NotesListResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NoteListData>[];
      json['data'].forEach((v) {
        data.add(new NoteListData.fromJson(v));
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

class NoteListData {
  String noteId;
  String thread;
  String notes;
  String createdDateStr;
  String createdByName;
  String isPrivate;
  String isSemiPrivate;
  String createdById;
  String tabId;
  String tabLabel;
  List<SubNotes> subNotes;

  NoteListData(
      {this.noteId,
      this.thread,
      this.notes,
      this.createdDateStr,
      this.createdByName,
      this.isPrivate,
      this.isSemiPrivate,
      this.createdById,
      this.tabId,
      this.tabLabel,
      this.subNotes});

  NoteListData.fromJson(Map<String, dynamic> json) {
    noteId = json['noteId'].toString();
    thread = json['thread'].toString();
    notes = json['notes'].toString();
    createdDateStr = json['createdDateStr'].toString();
    createdByName = json['createdByName'].toString();
    isPrivate = json['isPrivate'].toString();
    isSemiPrivate = json['isSemiPrivate'].toString();
    createdById = json['createdById'].toString();
    tabId = json['tabId'].toString();
    tabLabel = json['tabLabel'].toString();
    if (json['subNotes'] != null) {
      subNotes = <SubNotes>[];
      json['subNotes'].forEach((v) {
        subNotes.add(new SubNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteId'] = this.noteId;
    data['thread'] = this.thread;
    data['notes'] = this.notes;
    data['createdDateStr'] = this.createdDateStr;
    data['createdByName'] = this.createdByName;
    data['isPrivate'] = this.isPrivate;
    data['isSemiPrivate'] = this.isSemiPrivate;
    data['createdById'] = this.createdById;
    data['tabId'] = this.tabId;
    data['tabLabel'] = this.tabLabel;
    if (this.subNotes != null) {
      data['subNotes'] = this.subNotes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubNotes {
  String noteId;
  String thread;
  String notes;
  String createdDateStr;
  String createdByName;
  String isPrivate;
  String isSemiPrivate;
  String createdById;
  String tabId;
  String tabLabel;

  SubNotes(
      {this.noteId,
      this.thread,
      this.notes,
      this.createdDateStr,
      this.createdByName,
      this.isPrivate,
      this.isSemiPrivate,
      this.createdById,
      this.tabId,
      this.tabLabel});

  SubNotes.fromJson(Map<String, dynamic> json) {
    noteId = json['noteId'].toString();
    thread = json['thread'].toString();
    notes = json['notes'].toString();
    createdDateStr = json['createdDateStr'].toString();
    createdByName = json['createdByName'].toString();
    isPrivate = json['isPrivate'].toString();
    isSemiPrivate = json['isSemiPrivate'].toString();
    createdById = json['createdById'].toString();
    tabId = json['tabId'].toString();
    tabLabel = json['tabLabel'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteId'] = this.noteId;
    data['thread'] = this.thread;
    data['notes'] = this.notes;
    data['createdDateStr'] = this.createdDateStr;
    data['createdByName'] = this.createdByName;
    data['isPrivate'] = this.isPrivate;
    data['isSemiPrivate'] = this.isSemiPrivate;
    data['createdById'] = this.createdById;
    data['tabId'] = this.tabId;
    data['tabLabel'] = this.tabLabel;
    return data;
  }
}
