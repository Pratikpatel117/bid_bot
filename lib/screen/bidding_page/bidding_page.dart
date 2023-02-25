import 'dart:async';
import 'dart:collection';
import 'package:bidbot/const/string_const.dart';
import 'package:bidbot/utils/calender_view.dart';
import 'package:bidbot/api/bidding/biddingProjectList_api.dart';
import 'package:bidbot/const/color_const.dart';
import 'package:bidbot/const/style_const.dart';
import 'package:bidbot/const/widget.dart';
import 'package:bidbot/model/bidding/bidding_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:get_storage/get_storage.dart';
import '../../api/bidding/add_me_as_bidder_api.dart';
import '../../api/bidding/change_to_no_bid_api.dart';
import '../../model/bidding/add_me_as_bidder_model.dart';
import 'bidding_project_list.dart';

class BiddingPage extends StatefulWidget {
  final bool isLogin;

  const BiddingPage({Key key, this.isLogin}) : super(key: key);

  @override
  _BiddingPageState createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  var monthName = '';
  ListRequest listRequest;
  final listLimit = 5;
  Timer _timer;
  String previousKeyword;
  TabController tabController;
  List<BiddingData> sectionList = [];
  bool isLoading = true, isLoaded = false;
  bool bidderTap = false;
  String projectBidDate = "";
  AddMeAsBidderRequest addMeAsBidderRequest;
  // final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  DateTime _focusedDay = DateTime.now();
  int currentTab = 0;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      _selectedDays.clear();
      _selectedDays.add(selectedDay);
    });

    getBidsData("", forceLoad: true, date: selectedDay);
  }

  void toDaySelected() {
    sectionList.clear();
    getBidsData('');
  }

  @override
  void initState() {
    super.initState();
    // final getXStorage = GetStorage();
    // sectionList = getXStorage.read("bidderTap");
    debugPrint("Bidding Page");
    debugPrint("bidderTap status == ${GlobalValues.addMeAsBidderTap} ");
    // addAndRemoveBidsTap == true ? getBidderTap() :
    getBidsData("");
    // //   monthName =  DateFormat('MMMM').format(DateTime.now());
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        debugPrint("Tab tabb ${tabController.index}");
        currentTab = tabController.index;
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        getBidsData(previousKeyword);
        debugPrint('Scroll Activity Success');
      }
    });
  }

/*  getBidderTap() {
    // final getXStorage = GetStorage();
    var listData = getXStorage.read("bidderTap");
    // sectionList.forEach((element) {
    //   element = listData;
    // });
    debugPrint("response of Bidders tap == ${getXStorage.read("bidderTap")}");
    debugPrint("save list data == $listData");
    // getBidsData("");
  }*/
  Future changeToNoBid(String bidderId) async {
    ChangeToNoBidApi changeToNoBidApi = ChangeToNoBidApi();
    await changeToNoBidApi.ChangeToNoBid(bidderId).then((value) {
      var status = value.status;
      debugPrint("Remove Bids status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Successfully Removed"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        getBidsData("${GlobalValues.bidDateForBiddingStatus}");

        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        // Navigator.popAndPushNamed(context, "/homePage",
        //     arguments: {"isLogin": false});
      } else {
        final snackBar = SnackBar(
          content: Text("Bidder Add Submittals Not Added"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future addMeAsBidderTap(String projectLink) {
    setState(() {
      isLoading = true;
      sectionList.clear();
      GlobalValues.addMeAsBidderTap = true;
    });
    /*  widget.addMeBidderTap = true;
    final getXBox = GetStorage();
    getXBox.write("bidderTap", widget.sectionList);*/
    addMeAsBidderRequest = AddMeAsBidderRequest(
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      appId: "${GlobalValues.appId}",
      link: projectLink,
    );
    AddMeAsBidderApi addMeAsBidderApi = AddMeAsBidderApi();
    addMeAsBidderApi.addMeAsBidderTap(addMeAsBidderRequest).then((value) {
      var status = value.status;
      debugPrint("update Submittals status === $status");
      if (status == true) {
        final snackBar = SnackBar(
          content: Text("Bidder Added Successfully"),
          backgroundColor: ColorConst.successSnackBarColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        getBidsData("${GlobalValues.bidDateForBiddingStatus}");
      } else {
        final snackBar = SnackBar(
          content: Text("Error while adding as a bidder"),
          backgroundColor: ColorConst.failedSnackBarColor,
        );
        // scaffoldMessengerKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    setState(() {
      isLoading = false;
      // GlobalValues.addMeAsBidderTap = false;
    });
  }

  void searchWithThrottle(String keyword,
      {bool forceLoad = false, int throttleTime}) {
    _timer?.cancel();
    // if (keyword != previousKeyword && keyword.isNotEmpty) {
    previousKeyword = keyword;
    _timer =
        Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
      debugPrint("BidList Search Project Name: $keyword");
      getBidsData(keyword, forceLoad: forceLoad);
      _timer.cancel();
    });
  }

  Future getBidsData(String searchText,
      {bool forceLoad = false, date: DateTime}) async {
    //  var start = sectionList.isEmpty || forceLoad ? 0 : sectionList.length;
    setState(() {
      isLoading = true;
      if (sectionList.isEmpty ||
          forceLoad ||
          GlobalValues.addMeAsBidderTap == true) {
        sectionList.clear();
      }
    });
    // sectionList.clear();
    debugPrint("search Text == $searchText");
    debugPrint("add me as bidder tap == ${GlobalValues.addMeAsBidderTap}");
    DateTime now = DateTime.now();
    if (sectionList.isEmpty ||
        forceLoad && GlobalValues.addMeAsBidderTap != true) {
      if (date != null && date is DateTime) {
        now = date;
      } else {
        now = DateTime.now();
      }
    } else if (GlobalValues.addMeAsBidderTap == true) {
      String date = searchText;
      // String dateWithT = 'MM/dd/yyyy';
      // DateTime dateTime = DateTime.parse(dateWithT);
      DateTime tempDate = new DateFormat('MM/dd/yyyy').parse(date);
      now = tempDate;
    } else {
      String date = sectionList.last.projectList.last.bidDate;
      // String dateWithT = 'MM/dd/yyyy';
      // DateTime dateTime = DateTime.parse(dateWithT);
      DateTime tempDate = new DateFormat('MM/dd/yyyy').parse(date);
      now = tempDate;
    }
    String formattedDate = DateFormat('MM/dd/yyyy').format(now);
    widget.isLogin ??
        debugPrint("Bidding user ContactId === ${listRequest.contactId}");
    debugPrint("add me as bidder tap == $formattedDate");

    listRequest = ListRequest(
      projectName: GlobalValues.addMeAsBidderTap != true ? searchText : "",
      listLimit: listLimit.toString(),
      subscriptionId: "${GlobalValues.subscriptionId}",
      verticalId: "${GlobalValues.verticalId}",
      startDate:
          GlobalValues.addMeAsBidderTap != true ? formattedDate : searchText,
      contactId:
          widget.isLogin == true ? GlobalValues.loginEmployee.contactId : null,
    );
    BiddingProjectListApi listApi = BiddingProjectListApi();

    await listApi.getListData(listRequest).then((value) {
      GlobalValues.biddingProjectListData = value.data[0].projectList;
      debugPrint(
          " Global value  BiddingProjectList====${GlobalValues.biddingProjectListData}");
      widget.isLogin == true ??
          debugPrint(
              " Login User IsBidder----- ${GlobalValues.biddingProjectListData.lastWhere((element) => true).isBidder}");
      debugPrint(
          " Login User isMyCompany----- ${GlobalValues.biddingProjectListData.lastWhere((element) => true).isMyCompanyBidder}");
      debugPrint(
          " Login User IsNotBidder----- ${GlobalValues.biddingProjectListData.lastWhere((element) => true).isNotBidding}");
      var list = <BiddingData>[];
      if (sectionList.isEmpty || forceLoad) {
        sectionList.clear();
      }
      value.data?.forEach((element) {
        if (sectionList.any((sec) => sec.bidDate == element.bidDate)) {
        } else {
          list.add(element);
        }
      });
      try {
        setState(() {
          GlobalValues.addMeAsBidderTap = false;
          GlobalValues.bidDateForBiddingStatus = "";
          isLoading = false;
          sectionList.addAll(list);
        });
      } catch (e) {
        return null;
      }
    });
  }

  Widget searchSort() {
    return Container(
      // color: Colors.greenAccent[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: SearchTextFormField(
              searchWithThrottle: searchWithThrottle,
            ),
          ),
          GlobalValues.loginEmployee.sphereTypeId == 1 &&
                  TabRights.tabListData.any((element) =>
                      element.tabTypeUrl == 'bidlist-create-new-project.htm')
              ? InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/createNewProject');
                  },
                  child: Container(
                    height: 22,
                    width: 20,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Image.asset(
                      'asset/image/createnewproject.png',
                    ),
                  ),
                )
              : Container(),
          GlobalValues.loginEmployee.sphereTypeId == 1 &&
                  TabRights.tabListData.any(
                      (element) => element.tabTypeUrl == 'bidlist-my-bids.htm')
              ? InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/employeeBid');
                  },
                  child: Container(
                    height: 22,
                    width: 20,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Image.asset(
                      'asset/image/displaymybid.png',
                    ),
                  ),
                )
              : Container(),
          GlobalValues.loginEmployee.sphereTypeId == 1 &&
                  TabRights.tabListData.any((element) =>
                      element.tabTypeUrl == 'bidlist-manage-bid-requests.htm')
              ? Container(
                  width: 22,
                  height: 24,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/managBidRequest');
                    },
                    child: Stack(children: [
                      Container(
                        height: 22,
                        width: 20,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'asset/image/managebidrequest.png',
                          // fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 14,
                          width: 14,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff43A047),
                          ),
                          child: Text(
                            GlobalValues.manageBidData == null
                                ? "0"
                                : "${GlobalValues.manageBidData.length}",
                            // activeProjectList.submittalCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // ? Container()
                      // : Stack(
                      // children: [],
                      // )
                    ]),
                  ),
                )
              : Container(),
          /*  GlobalValues.loginEmployee.sphereTypeId ==
                  2
              ? InkWell(
                  child: Container(
                    height: 18,
                    width: 18,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Image.asset('asset/image/newbidrequest.png'),
                  ),
                )
              : Container(),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            widget.isLogin == true && GlobalValues.calenderView == true //title
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Bidding',
                      style: TextstyleConst.HeaderTitlePage,
                    ),
                  )
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == true //search-bar
                ? searchSort()
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == false //tab-bar
                ? Container(
                    height: 40,
                    child: TabBar(
                        onTap: (index) {
                          setState(() {
                            debugPrint("Tab tab ${tabController.index}");
                            currentTab = tabController.index;
                          });
                        },
                        automaticIndicatorColorAdjustment: true,
                        indicatorColor: Color(0xff2B2C6C),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xff3898D4),
                        controller: tabController,
                        tabs: [
                          currentTab == 0
                              ? tabBarTitle("Day")
                              : Text(
                                  'Day',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          currentTab == 1
                              ? tabBarTitle("Week")
                              : Text(
                                  'Week',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          currentTab == 2
                              ? tabBarTitle("Month")
                              : Text(
                                  'Month',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ]),
                  )
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == false &&
                    currentTab == 1
                ? SizedBox(
                    height: 10,
                  )
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == false &&
                    currentTab == 2
                ? Container(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      // monthName.isEmpty?
                      DateFormat('MMMM').format(_focusedDay),
                      // : monthName,
                      // DateFormat('MMMM').format(_focusedDay),
                      style: TextStyle(
                          color: Color(0xff252669),
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == false &&
                    currentTab == 0
                ? toDayDate()
                : Container(),
            widget.isLogin == true &&
                    GlobalValues.calenderView == false &&
                    currentTab != 0
                ? Flexible(
                    child: Column(
                      children: [
                        TableCalendar<Event>(
                          rowHeight: 40,
                          headerVisible: false,
                          firstDay: kFirstDay,
                          lastDay: kLastDay,
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextstyleConst.CalenderWeekStyle,
                            weekendStyle: TextstyleConst.CalenderWeekStyle,
                          ),
                          focusedDay: _focusedDay,
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: ColorConst.LoginButtonColor,
                                borderRadius: BorderRadius.circular(3)),
                            selectedTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                            todayDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xff252669),
                                borderRadius: BorderRadius.circular(3)),
                            todayTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                            canMarkersOverflow: false,
                          ),
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
                            formatButtonShowsNext: false,
                          ),
                          // calendarBuilders: CalendarBuilders(
                          //     ),
                          calendarFormat: currentTab == 1
                              ? CalendarFormat.week
                              : CalendarFormat.month,
                          //eventLoader: _getEventsForDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          selectedDayPredicate: (day) {
                            return _selectedDays.contains(day);
                          },
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                            setState(() {
                              monthName =
                                  DateFormat('MMMM').format(_focusedDay);
                            });
                          },
                        ),
                        BiddingProjectList(
                          scrollController: scrollController,
                          sectionList: sectionList,
                          projectBidDate: projectBidDate,
                          onPressedAddBidder: addMeAsBidderTap,
                          onPressedForRemoveBid: changeToNoBid,
                        ),
                      ],
                    ),
                  )
                : Container(),
            widget.isLogin == false
                ? Expanded(
                    child: ExpandableListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      //   padding: EdgeInsets.only(),
                      builder: SliverExpandableChildDelegate<ProjectList,
                          BiddingData>(
                        removeItemsOnCollapsed: true,
                        sectionList: sectionList,
                        headerBuilder: (context, selectIndex, i) {
                          String bid = sectionList[selectIndex].bidDate;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    bid,
                                    textAlign: TextAlign.center,
                                    style: TextstyleConst.ListTitleStyle,
                                  ),
                                  height: 38,
                                  alignment: Alignment.center,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Color(0xff262769),
                                      borderRadius: BorderRadius.circular(9)),
                                ),
                                Text(
                                  '${sectionList[selectIndex].projectList.length} Projects ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                        itemBuilder: (context, selectionIndex, itemIndex, i) {
                          List<ProjectList> list =
                              sectionList[selectionIndex].projectList;
                          String name = list[itemIndex].projectName;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        name,
                                        style: TextstyleConst.ListTextStyle,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            widget.isLogin == true && GlobalValues.calenderView == true
                ? BiddingProjectList(
                    scrollController: scrollController,
                    sectionList: sectionList,
                    projectBidDate: projectBidDate,
                    onPressedAddBidder: addMeAsBidderTap,
                    onPressedForRemoveBid: changeToNoBid,
                    // intro: intro,
                    // reCallGetBidding: getBidsData,
                    //     isLoading: isLoading,
                  )
                : Container(),
          ],
        ),
        GlobalValues.checkconection == true
            ? Visible(
                isLoading: isLoading,
                message: 'Loading Bidding...',
              )
            : Container()
      ],
    );
  }

  Container tabBarTitle(String title) {
    return Container(
      height: 30,
      width: 120,
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xff3898D4),
      ),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget toDayDate() {
    return Flexible(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.fromBorderSide(
                          BorderSide(color: Color(0xff252669), width: 3)),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.now().day.toString(),
                        // sectionList.last.projectList.last.bidDate,
                        style: TextStyle(
                            color: Color(0xff252669),
                            fontFamily: StringConst.FONT_FAMILY,
                            fontWeight: FontWeight.w500,
                            fontSize: 45),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE').format(DateTime.now()),
                            style: TextStyle(
                              fontFamily: StringConst.FONT_FAMILY,
                              color: Color(0xff40B2DF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMM yyyy').format(DateTime.now()),
                            style: TextStyle(
                              color: Color(0xff40B2DF),
                              fontFamily: StringConst.FONT_FAMILY,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    toDaySelected();
                  },
                  child: Container(
                    height: 25,
                    width: 95,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xff252669),
                        shape: BoxShape.rectangle,
                        // border: Border.fromBorderSide(BorderSide(color: Color(0xff252669), width: 3)),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      'Today',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          BiddingProjectList(
            scrollController: scrollController,
            sectionList: sectionList,
            projectBidDate: projectBidDate,
            onPressedAddBidder: addMeAsBidderTap,
            onPressedForRemoveBid: changeToNoBid,
            // intro: intro,
            // reCallGetBidding: getBidsData,
            //   isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
