class UpdateProposalRequest {
  String employeeId;
  String projectId;
  String proposalDocument;
  String fileName;
  String proposalDescription;
  String projectExternalProposalDocumentId;

  UpdateProposalRequest(
      {this.employeeId,
      this.projectId,
      this.proposalDocument,
      this.fileName,
      this.proposalDescription,
      this.projectExternalProposalDocumentId});

  UpdateProposalRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    projectId = json['projectId'];
    proposalDocument = json['proposalDocument'];
    fileName = json['fileName'];
    proposalDescription = json['proposalDescription'];
    projectExternalProposalDocumentId =
        json['projectExternalProposalDocumentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['projectId'] = this.projectId;
    data['proposalDocument'] = this.proposalDocument;
    data['fileName'] = this.fileName;
    data['proposalDescription'] = this.proposalDescription;
    data['projectExternalProposalDocumentId'] =
        this.projectExternalProposalDocumentId;
    return data;
  }
}
