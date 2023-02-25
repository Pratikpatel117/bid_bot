class AddNotesTabRequest {
  String employeeId;
  String tabCode;
  String verticalId;

  AddNotesTabRequest({this.employeeId, this.tabCode, this.verticalId});

  AddNotesTabRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    tabCode = json['tabCode'];
    verticalId = json['verticalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['tabCode'] = this.tabCode;
    data['verticalId'] = this.verticalId;
    return data;
  }
}

class AddNotesRequest {
  String noteDateStr;
  String thread;
  String subscriptionId;
  String verticalId;
  String noteId;
  String notes;
  String projectId;
  String employeeId;
  String activeTabId;
  String sendOrNotify;
  String isPrivate;
  String isSemiPrivate;
  String isPlayer;
  String isBidder;
  String parentNoteId;

  AddNotesRequest(
      {this.noteDateStr,
      this.thread,
      this.subscriptionId,
      this.verticalId,
      this.noteId,
      this.notes,
      this.projectId,
      this.employeeId,
      this.activeTabId,
      this.sendOrNotify,
      this.isPrivate,
      this.isSemiPrivate,
      this.isPlayer,
      this.isBidder,
      this.parentNoteId});

  AddNotesRequest.fromJson(Map<String, dynamic> json) {
    noteDateStr = json['noteDateStr'];
    thread = json['thread'];
    subscriptionId = json['subscriptionId'];
    verticalId = json['verticalId'];
    noteId = json['noteId'];
    notes = json['notes'];
    projectId = json['projectId'];
    employeeId = json['employeeId'];
    activeTabId = json['activeTabId'];
    sendOrNotify = json['sendOrNotify'];
    isPrivate = json['isPrivate'];
    isSemiPrivate = json['isSemiPrivate'];
    isPlayer = json['isPlayer'];
    isBidder = json['isBidder'];
    parentNoteId = json['parentNoteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteDateStr'] = this.noteDateStr;
    data['thread'] = this.thread;
    data['subscriptionId'] = this.subscriptionId;
    data['verticalId'] = this.verticalId;
    data['noteId'] = this.noteId;
    data['notes'] = this.notes;
    data['projectId'] = this.projectId;
    data['employeeId'] = this.employeeId;
    data['activeTabId'] = this.activeTabId;
    data['sendOrNotify'] = this.sendOrNotify;
    data['isPrivate'] = this.isPrivate;
    data['isSemiPrivate'] = this.isSemiPrivate;
    data['isPlayer'] = this.isPlayer;
    data['isBidder'] = this.isBidder;
    data['parentNoteId'] = this.parentNoteId;
    return data;
  }
}

class AddNotesResponce {
  bool status;
  String message;
  NotesData data;

  AddNotesResponce({this.status, this.message, this.data});

  AddNotesResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new NotesData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class NotesData {
  String noteDate;
  String divPrjThreadId;
  String isFromWebService;
  String customerId;
  String verticalId;
  String isWS;
  String noteId;
  String enteredDate;
  String note;
  String activeTabId;
  String projectId;
  String loginEmployeeId;
  String isPrivate;
  String isSemiPrivate;
  String isPlayer;
  String isBidder;
  String parentNoteId;
  String notifyMsg;

  NotesData(
      {this.noteDate,
      this.divPrjThreadId,
      this.isFromWebService,
      this.customerId,
      this.verticalId,
      this.isWS,
      this.noteId,
      this.enteredDate,
      this.note,
      this.activeTabId,
      this.projectId,
      this.loginEmployeeId,
      this.isPrivate,
      this.isSemiPrivate,
      this.isPlayer,
      this.isBidder,
      this.parentNoteId,
      this.notifyMsg});

  NotesData.fromJson(Map<String, dynamic> json) {
    noteDate = json['noteDate'];
    divPrjThreadId = json['divPrjThreadId'];
    isFromWebService = json['isFromWebService'];
    customerId = json['customerId'];
    verticalId = json['verticalId'];
    isWS = json['isWS'];
    noteId = json['noteId'];
    enteredDate = json['enteredDate'];
    note = json['note'];
    activeTabId = json['activeTabId'];
    projectId = json['projectId'];
    loginEmployeeId = json['loginEmployeeId'];
    isPrivate = json['isPrivate'];
    isSemiPrivate = json['isSemiPrivate'];
    isPlayer = json['isPlayer'];
    isBidder = json['isBidder'];
    parentNoteId = json['parentNoteId'];
    notifyMsg = json['notifyMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteDate'] = this.noteDate;
    data['divPrjThreadId'] = this.divPrjThreadId;
    data['isFromWebService'] = this.isFromWebService;
    data['customerId'] = this.customerId;
    data['verticalId'] = this.verticalId;
    data['isWS'] = this.isWS;
    data['noteId'] = this.noteId;
    data['enteredDate'] = this.enteredDate;
    data['note'] = this.note;
    data['activeTabId'] = this.activeTabId;
    data['projectId'] = this.projectId;
    data['loginEmployeeId'] = this.loginEmployeeId;
    data['isPrivate'] = this.isPrivate;
    data['isSemiPrivate'] = this.isSemiPrivate;
    data['isPlayer'] = this.isPlayer;
    data['isBidder'] = this.isBidder;
    data['parentNoteId'] = this.parentNoteId;
    data['notifyMsg'] = this.notifyMsg;
    return data;
  }
}
