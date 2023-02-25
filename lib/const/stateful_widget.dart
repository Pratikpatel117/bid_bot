import 'package:bidbot/model/bid_Inquiry/create_new_project_model.dart';
import 'package:bidbot/model/project_information_model.dart';
import 'package:flutter/material.dart';

import '../api/project_info_api.dart';
import '../screen/bidding_page/bidding_project_list.dart';
import 'color_const.dart';
import 'function_const.dart';

class BuildDropDownButton extends StatefulWidget {
  const BuildDropDownButton({
    Key key,
    this.fieldId,
    this.isAddContact,
    this.listOfData,
    this.hintText,
    this.errorText,
    this.selectList,
    this.dropdownValueChanged,
  }) : super(key: key);
  final String hintText;
  final String errorText;
  final int fieldId;
  final bool isAddContact;
  final List<DrawerData> listOfData;
  final DrawerData selectList;
  final void Function(DrawerData, int) dropdownValueChanged;

  @override
  State<BuildDropDownButton> createState() => _BuildDropDownButtonState();
}

class _BuildDropDownButtonState extends State<BuildDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(widget.hintText),
      isDense: true,
      isExpanded: true,
      elevation: 6,
      // dropdownColor: isAddContact != true ? Colors.green : Colors.black54,
      validator: // ridesPhase != RidesPhase.chooseExisting ?
          (value) {
        return widget.fieldId == 1
            ? value == null
                ? widget.errorText
                : null
            : null;
      },
      //: null,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          height: 0.5,
          fontSize: 11,
        ),
        border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff4381b7), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff4381b7),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: ColorConst.InputFocusedBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: ColorConst.InputEnableBorderColor, width: 1),
        ),
        filled: true,
        //  hintText: 'Project Name *',
        contentPadding: EdgeInsets.fromLTRB(8, 0, 10, 0),
        //padding according to your need
        hintStyle: TextStyle(color: Colors.grey, fontSize: 9),
        fillColor: widget.isAddContact == true && widget.fieldId == 4
            ? Color(0xffCCCCCC)
            : Colors.white,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
      ),
      items: widget.listOfData?.map((items) {
            return DropdownMenuItem(
              child: Text(items.value),
              value: items,
            );
          })?.toList() ??
          [],
      onChanged: (newValue) {
        widget.dropdownValueChanged.call(newValue, widget.fieldId);
      },
      value: widget.selectList,
    );
  }
}
