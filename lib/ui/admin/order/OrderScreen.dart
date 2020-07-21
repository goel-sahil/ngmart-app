import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/model/admin/order/AdminOrderResponse.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool toggle = true;
  var dataList = new List<DataInner>();
  final format = DateFormat("yyyy-MM-dd");
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  int _currentPageNumber = 1;
  ScrollController scrollController = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  AdminProvider adminProvider;

  @override
  void initState() {
    _setScrollListener();
    _currentPageNumber = 1;
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (dataList.length >= (PAGINATION_SIZE * _currentPageNumber) &&
            _loadMore) {
          isPullToRefresh = true;
          _hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  Future<void> _hitApi() async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }

    if (!isPullToRefresh) {
      adminProvider.setLoading(); //show loader
    }
    isPullToRefresh = false;

    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }

    var response = await adminProvider.getOrders(context, _currentPageNumber);
    if (response is APIError) {
    } else if (response is AdminOrderResponse) {
      if (_currentPageNumber == 1) {
        dataList.clear();
      }
      dataList.addAll(response.data.dataInner);

      if (response.data.dataInner.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    adminProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              isPullToRefresh = true;
              _loadMore = false;
              await _hitApi();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  getSpacer(height: 20),
                  _getDateRow(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataList.length ?? 0,
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        String status;
                        if (dataList[index].status == 0) {
                          status = "Pending";
                        } else if (dataList[index].status == 1) {
                          status = "Accept";
                        } else if (dataList[index].status == 2) {
                          status = "Reject";
                        } else if (dataList[index].status == 3) {
                          status = "Cancel";
                        } else if (dataList[index].status == 4) {
                          status = "Delivered";
                        }

                        return buildItem(
                            dataList[index], status, dataList[index].status);
                        /*InkWell(
                          onTap: () {},
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(
                                      dataList[index].id.toString() ?? "A"),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text("Order id ${dataList[index].id}"),
                                subtitle: Text('Status: $status'),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
//                          _hitDeleteBrandApi(
//                              id: dataInner[index].id, position: index);
                                },
                              ),
                            ],
                          ),
                        );*/
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: adminProvider.getLoading(),
              context: context,
            ),
          ),
          (dataList.length == 0) && (adminProvider.getLoading() == false)
              ? Center(
                  child: getNoDataView(msg: "No Orders found.", onRetry: null))
              : Container()
        ],
      ),
    );
  }

  buildItem(DataInner dataList, String status, int intStatus) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Column(
        children: <Widget>[
          getSpacer(height: 10),
          Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getSpacer(width: 10),
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(dataList.id.toString() ?? "A"),
                foregroundColor: Colors.white,
              ),
              getSpacer(width: 16),
              Column(
                children: <Widget>[
                  Text(
                    "Order Id ${dataList.id}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('Status: $status')
                ],
              ),
            ],
          ),
          getSpacer(height: 10)
        ],
      ),
      secondaryActions: <Widget>[
        intStatus == 0 || intStatus == 2
            ? IconSlideAction(
                caption: 'Accept',
                color: Colors.green,
                icon: FontAwesomeIcons.check,
                onTap: () {
//            _hitDeleteBrandApi(
//                id: dataInner[index].id, position: index);
                },
              )
            : Container(),
        intStatus == 0
            ? IconSlideAction(
                caption: 'Reject',
                color: Colors.red,
                closeOnTap: true,
                icon: Icons.delete,
                onTap: () {
//            _hitDeleteBrandApi(
//                id: dataInner[index].id, position: index);
                },
              )
            : Container(),
        intStatus == 1
            ? IconSlideAction(
                caption: 'Cancel',
                color: Colors.grey,
                closeOnTap: true,
                icon: Icons.delete,
                onTap: () {
//            _hitDeleteBrandApi(
//                id: dataInner[index].id, position: index);
                },
              )
            : null
      ],
    );
  }

  _getDateRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 4.0,
        ),
        new Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, 1),
            child: AbsorbPointer(
              child: new TextField(
                  controller: _dateFromController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Date From",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                        borderSide: new BorderSide(),
                      ))),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        new Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, 2),
            child: AbsorbPointer(
              child: new TextField(
                  controller: _dateToController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Date to",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      borderSide: new BorderSide(),
                    ),
                  )),
            ),
          ),
        ),
        SizedBox(
          width: 4.0,
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.search,
            size: 25,
          ),
          onPressed: () {
            if (_dateFromController.text.isNotEmpty &&
                _dateToController.text.isNotEmpty) {
              //_getTransactionsWithFilter();
            } else {
              showInSnackBar("Date from and date to should not be empty.");
            }
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.redo,
            size: 25,
          ),
          onPressed: () {
            _dateFromController.clear();
            _dateToController.clear();
            // _getTransactions();
          },
        ),
        SizedBox(
          width: 4.0,
        ),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context, int i) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectedDate = picked;
    var formatDate = format.format(selectedDate.toLocal());
    if (i == 1) {
      _dateFromController.text = formatDate;
    } else {
      _dateToController.text = formatDate;
    }
    print(selectedDate.toLocal().toString());
    print(formatDate);
    setState(() {});
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }
}
