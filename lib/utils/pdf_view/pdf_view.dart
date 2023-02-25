import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/utils/routes.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:flutter/material.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    Key key,
  }) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String projectName = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (GlobalValues.selectedBidIndex == 0) {
      projectName = BiddingGlobalValue.equipmentProposal?.projectName != null
          ? "${BiddingGlobalValue.equipmentProposal?.projectName}"
          : " ";
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectName = BidListGlobalValue.bidListEquipmentProjectName != null
          ? "${BidListGlobalValue.bidListEquipmentProjectName}"
          : " ";
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectName = PendingBidGlobalValue
                  .pendingBidEquipmentProposal?.projectName !=
              null
          ? "${PendingBidGlobalValue.pendingBidEquipmentProposal?.projectName}"
          : " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    // final name = basename(GlobalValues.pdfFile.path);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            GlobalValues.pdfFile.delete();
            BiddingGlobalValue.equipmentProposal = null;
          },
          child: Icon(
            Icons.arrow_back,
            size: 26,
          ),
        ),
        title: Text(projectName),
        backgroundColor: ColorConst.appBarBackGroundColor,
        actions: [
          GlobalValues.selectedBidIndex == 3 ||
                  GlobalValues.selectedBidIndex == 4 ||
                  GlobalValues.selectedBidIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: InkWell(
                      child: Icon(Icons.share, size: 24),
                      onTap: () {
                        Navigator.pushNamed(context, shareDocumentPage);
                      }),
                )
              : Container(),
        ],
      ),
      body: PDFView(
        filePath: GlobalValues.pdfFile.path,
      ),
    );
  }
}
