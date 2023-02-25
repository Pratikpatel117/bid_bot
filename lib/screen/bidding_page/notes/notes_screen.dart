import 'package:bidbot/api/bidding/Notes/addNotes_api.dart';
import 'package:bidbot/api/bidding/Notes/notes_list_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/notes/add_notes_model.dart';
import 'package:bidbot/model/bidding/notes/notes_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController replayController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddNotesRequest notesRequest;

  NotesListRequest notesListRequest;
  bool isLoading = false;
  DateTime now = DateTime.now();
  bool isReplay = false;
  NotesData notesData;
  NoteListData noteListData;
  // String replyNote = " ";
  // NotesListApi notesListApi;
  List<NoteListData> listOfNotesData = [];
  List<SubNotes> listOfSubNotes = [];
  int replyIndex;
  String projectId = " ";

  @override
  void initState() {
    super.initState();
    if (GlobalValues.selectedBidIndex == 0) {
      projectId = BiddingGlobalValue.biddingNoteProjectId;
    } else if (GlobalValues.selectedBidIndex == 1) {
      projectId = BidListGlobalValue.bidListNoteProjectId;
    } else if (GlobalValues.selectedBidIndex == 2) {
      projectId = PendingBidGlobalValue.pendingBidNoteProjectId;
    }
    notesListData();
    debugPrint("dgdgwe ===");
  }

  Future notesListData() async {
    setState(() {
      isLoading = true;
      // listOfNotesData.clear();
      // listOfSubNotes.clear();
    });
    notesListRequest = NotesListRequest(
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: projectId, //"${BiddingGlobalValue.biddingForNotes.projectId}",
      tabId: GlobalValues.loginEmployee.sphereTypeId != 1 ? "1507931" : null,
    );
    NotesListApi notesListApi = NotesListApi();
    var list = <NoteListData>[];
    await notesListApi.notesListData(notesListRequest).then((value) {
      debugPrint("NotesList Api Responce = ${value.status}");
      value.data.forEach((element) {
        list.add(element);
      });
      /* setState(() {
        listOfNotesData = value.data;
      });*/
    });
    setState(() {
      isLoading = false;
      listOfNotesData.addAll(list);
      debugPrint("NotesList Api Responce = $listOfNotesData");
    });
  }

  Future replayNotes(NoteListData replayNoteData) async {
    setState(() {
      isLoading = true;
      listOfNotesData.clear();
      listOfSubNotes.clear();
      replyIndex = null;
      // isReplay = !isReplay ;
    });
    notesRequest = AddNotesRequest(
      verticalId: "${GlobalValues.verticalId}",
      employeeId: "${GlobalValues.loginEmployee.employeeId}",
      projectId: projectId,
      subscriptionId: "${GlobalValues.subscriptionId}",
      activeTabId: replayNoteData.tabId,
      isPrivate: replayNoteData.isPrivate,
      isSemiPrivate: replayNoteData.isSemiPrivate,
      isBidder: "0",
      isPlayer: "0",
      sendOrNotify: "0",
      notes: replayController.text,
      noteDateStr: DateFormat("MM/dd/yyyy").format(DateTime.now()),
      noteId: null,
      parentNoteId: replayNoteData.noteId,
      thread: replayNoteData.thread,
    );
    AddNotesApi notesApi = AddNotesApi();
    await notesApi.addNotesData(notesRequest).then((value) {
      var replayStatus = value.status;
      debugPrint("Notes Replay Status == $replayStatus");
      /* setState(() {
        notesData = value.data;
      });*/
    });
    setState(() {
      replayController.clear();
      isLoading = false;
    });
    notesListData();
  }

  bool replyValidate() {
    if (replayController.text.isNotEmpty) {
      return true;
    } else {
      final snacbar = SnackBar(
        content: Text("Please Enter Note Replay"),
        backgroundColor: ColorConst.failedSnackBarColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snacbar);
      return false;
    }
    // selectLead ?? selectGroup ?? selectPhase ?? selectType == null ?
  }

  /* @override
  void dispose() {
    replayController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff252669),
        leading: Container(),
        titleSpacing: -30,
        title: Text('Notes'),
        actions: [
          TabRights.tabListData.any((element) => element.isAdd == 1)
              ? InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/addNotes");
                  },
                  child: Icon(
                    Icons.add_outlined,
                    size: 32,
                  ),
                )
              : Container(),
          PopBackAction(),
        ],
      ),
      body: isLoading != true
          ? Column(
              children: [
                listOfNotesData.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: listOfNotesData.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              debugPrint(
                                  "list index of notes Dat == ${listOfNotesData.length}");
                              return noteItems(context, index);
                            }),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "There are no notes available",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
              ],
            )
          : Visible(isLoading: isLoading, message: ""),
    );
  }

  Widget noteItems(BuildContext context, int i) {
    return Card(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Image.network(
                    "https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=employeePhoto&compress=0&id=${listOfNotesData[i].createdById}&random=$now",
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      listOfNotesData[i].notes.contains("<") == true
                          ? Html(data: listOfNotesData[i].notes)
                          : MarkdownBody(
                              data: listOfNotesData[i].notes,
                              shrinkWrap: true,
                              // listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
                              styleSheet: MarkdownStyleSheet(),
                            ),
                      replyIndex != i
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: notesAction(listOfNotesData[i], i),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 6, bottom: 6),
                                    child: Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: Container(
                                        height: 40,
                                        child: TextFormField(
                                          controller: replayController,
                                          onChanged: (name) {
                                            /* setState(() {
                                              replyNote = name;
                                            });*/
                                          },
                                          /* validator: (value) {
                                            if (value.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "Please Enter Note Replay";
                                            }
                                          },*/
                                          decoration: InputDecoration(
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff4381b7),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            border: OutlineInputBorder(
                                                // borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color:
                                                      ColorConst.SearchBorder,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: ColorConst
                                                      .InputEnableBorderColor,
                                                  width: 1),
                                            ),
                                            //    filled: true,
                                            hintText: 'Replay here...',
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10, 20, 10, 0),
                                            //padding according to your need
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                            fillColor: Colors.white,
                                            errorStyle: TextStyle(
                                              height: 0.5,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: InkWell(
                                    onTap: () {
                                      if (replyValidate() == true) {
                                        replayNotes(listOfNotesData[i]);
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      child: Text(
                                        "Reply",
                                        style: TextStyle(
                                          color: Color(0xff4381b7),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Color(0xff4381b7),
                                              width: 2)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                /* Text(notes.outerHtml,
               style: TextStyle(fontFamily: StringConst.FONT_FAMILY,color: Colors.black,fontWeight: FontWeight.w400),
             ),*/
              ),
            ],
          ),
          listOfNotesData[i].subNotes != null &&
                  listOfNotesData[i].subNotes.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: listOfNotesData[i].subNotes.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Image.network(
                                          "https://www.myciright.com/Ciright/ajaxCall-photo.htm?flag=employeePhoto&compress=0&id=${listOfNotesData[i].subNotes[index].createdById}&random=$now",
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Html(
                                      data: listOfNotesData[i]
                                          .subNotes[index]
                                          .notes,
                                    )),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  /* bool buttonPress() {
    final form = _formKey.currentState;
    // debugPrint("Button Press Activity ${buttonPress()}");
    // debugPrint("Button Press Activity ${form?.validate()}");
    if (form.validate()) {
      form?.save();
      return true;
    }
    return false;
  }*/

  List<Widget> notesAction(NoteListData listOfElements, int i) {
    List<Widget> list = [];
    list.add(
      InkWell(
        onTap: () {
          setState(() {
            replyIndex = i;
            isReplay = !isReplay;
          });
        },
        child: Icon(
          Icons.reply,
          color: Colors.blue,
        ),
      ),
    );
    TabRights.tabListData.any((element) => element.isEdit == 1)
        ? list.add(
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: InkWell(
                onTap: () {
                  setState(() {
                    BiddingGlobalValue.editNoteData = listOfElements;
                    Navigator.popAndPushNamed(context, "/addNotes", arguments: {
                      "editNote": true,
                    });
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        : null;
    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(listOfElements.tabLabel),
      ),
    );
    return list;
  }
}
