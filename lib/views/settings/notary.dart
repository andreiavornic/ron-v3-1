import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/settings/state_select.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:notary/models/notary.dart' as NotaryModel;
import 'package:provider/provider.dart';

import '../../widgets/network_connection.dart';

class Notary extends StatefulWidget {
  @override
  _NotaryState createState() => _NotaryState();
}

class _NotaryState extends State<Notary> {
  String _title;
  String _company;
  String _ronLicense;
  DateTime _ronExpire;
  String _address;
  String _addressSecond;
  String _city;
  String _state;
  String _zip;
  String _companyPhone;
  String _companyEmail;
  bool _emailError = false;
  MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
    mask: '+# (###) ###-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    NotaryModel.Notary _notary =
        Provider.of<UserController>(context, listen: false).notary;
    _title = _notary.title;
    _company = _notary.company;
    _ronLicense = _notary.ronLicense;
    _ronExpire = _notary.ronExpire;
    _address = _notary.address;
    _addressSecond = _notary.addressSecond;
    _city = _notary.city;
    _state = _notary.state;
    _zip = _notary.zip;
    _companyPhone = _notary.companyPhone;
    _companyEmail = _notary.companyEmail;
    _emailError = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      Scaffold(
        body: Container(
          height: StateM(context).height(),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  TitlePage(
                    title: 'Notary Details',
                    description: 'Information about your Notary Commission',
                    needNav: true,
                  ),
                  SizedBox(height: reSize(context, 10)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EditInput(
                          initialValue: _title,
                          hintText: 'Notary Full Name',
                          labelText: 'Notary Full Name',
                          onChanged: (value) {
                            _title = value;
                            setState(() {});
                          },
                        ),
                        EditInput(
                          initialValue: _company,
                          hintText: 'Company',
                          labelText: 'Company',
                          onChanged: (value) {
                            _company = value;
                            setState(() {});
                          },
                          validate: (String value) {
                            if (value.trim().isEmpty) {
                              return "Company is required";
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: EditInput(
                                initialValue: _ronLicense,
                                hintText: 'Commission Number',
                                labelText: 'Commission Number',
                                onChanged: (value) {
                                  _ronLicense = value;
                                  setState(() {});
                                },
                                validate: (String value) {
                                  if (value.trim().isEmpty) {
                                    return "RON is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: reSize(context, 15)),
                            Expanded(
                              child: InkWell(
                                onTap: _selectRonExpire,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Color(0xFFEDEDED)),
                                  )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expiration Date',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF161617)),
                                      ),
                                      SizedBox(height: reSize(context, 4)),
                                      Text(
                                        _ronExpire == null
                                            ? 'Empty'
                                            : DateFormat('MM / dd / yyyy')
                                                .format(_ronExpire),
                                        style: TextStyle(
                                            color: Color(0xFF161617),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        EditInput(
                          initialValue: _address,
                          hintText: 'Address',
                          labelText: 'Address',
                          onChanged: (value) {
                            _address = value;
                            setState(() {});
                          },
                          validate: (String value) {
                            if (value.trim().isEmpty) {
                              return "Address is required";
                            }
                            return null;
                          },
                        ),
                        EditInput(
                          initialValue: _addressSecond,
                          hintText: 'Address 2 (Optional)',
                          labelText: 'Address 2 (Optional)',
                          onChanged: (value) {
                            _addressSecond = value;
                            setState(() {});
                          },
                        ),
                        EditInput(
                          initialValue: _city,
                          hintText: 'City',
                          labelText: 'City',
                          onChanged: (value) {
                            _city = value;
                            setState(() {});
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => modalContainerSimple(
                                    StateSelect(
                                      changeState: (abbrevCity, selectedCity) {
                                        _state = abbrevCity;
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      isSetting: true,
                                    ),
                                    context),
                                // showModal(
                                // StateSelect(
                                //   defaultState: _state,
                                //   selectState: (String abbrevCity,
                                //       String state) async {
                                //     _notary.state = abbrevCity;
                                //     _state = abbrevCity;
                                //     setState(() {});
                                //     Navigator.of(context).pop();
                                //   },
                                // ),
                                // context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'State',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Color(0xFF161617),
                                        fontSize: 8,
                                      ),
                                    ),
                                    SizedBox(height: reSize(context, 7)),
                                    Text(
                                      _state != null ? _state : "FL",
                                      style: TextStyle(
                                        color: Color(0xFF161617),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 6),
                                    Container(
                                      color: Color(0xFFEDEDED),
                                      width: StateM(context).width() - 40,
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: reSize(context, 40)),
                            Expanded(
                              child: EditInput(
                                onChanged: (value) {
                                  _zip = value;
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                validate: (String value) {
                                  if (value.trim().isEmpty) {
                                    return "ZIP is required";
                                  } else if (value.length < 5) {
                                    return "ZIP is not match";
                                  }
                                  return null;
                                },
                                hintText: "Zip Code",
                                labelText: "Zip Code",
                                initialValue: _zip,
                                action: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                        EditInput(
                          initialValue: _companyPhone,
                          labelText: 'Phone',
                          hintText: "Enter Company Phone",
                          inputFormatters: [_phoneFormatter],
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            _companyPhone = value;
                            setState(() {});
                          },
                        ),
                        Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              if (_companyEmail == null ||
                                  _companyEmail.isEmpty ||
                                  !_companyEmail.contains("@")) {
                                _emailError = true;
                                setState(() {});
                              }
                            } else {
                              _emailError = false;
                              setState(() {});
                            }
                          },
                          child: Column(
                            children: [
                              EditInput(
                                initialValue: _companyEmail,
                                labelText: 'Company Email Address',
                                hintText: "Enter Company Email",
                                keyboardType: TextInputType.emailAddress,
                                noCapitalize: true,
                                onChanged: (String value) {
                                  _companyEmail = value;
                                  _emailError = false;
                                  setState(() {});
                                },
                              ),
                              if (_emailError)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: StateM(context).width() - 40,
                                      child: Text(
                                        "Please check company email",
                                        style: TextStyle(
                                          color: Color(0xFFFF4E4E),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          height: 0.5,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: reSize(context, 40)),
                      ],
                    ),
                  ),
                  ButtonPrimary(
                    text: 'Save',
                    callback: !_checkData() ? null : _updateNotary,
                  ),
                  SizedBox(
                      height: StateM(context).height() < 670
                          ? 20
                          : reSize(context, 40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _checkData() {
    if (_ronLicense.isNotEmpty &&
        _ronExpire != null &&
        _address.isNotEmpty &&
        _city.isNotEmpty &&
        _zip.isNotEmpty &&
        _zip.length > 4 &&
        _emailError) {
      return true;
    }
    return false;
  }

  _updateNotary() async {
    await Provider.of<UserController>(context, listen: false).editNotary({
      "title": _title,
      "company": _company,
      "ronLicense": _ronLicense,
      "ronExpire": _ronExpire.toString(),
      "address": _address,
      "addressSecond": _addressSecond,
      "city": _city,
      "state": _state,
      "zip": _zip,
      "companyPhone": _companyPhone,
      "companyEmail": _companyEmail,
    });
    Navigator.pop(context);
  }

  _selectRonExpire() async {
    await modalContainerSimple(
        Container(
          height: StateM(context).height() / 2,
          color: Color(0xFFFFFFFF),
          child: Column(
            children: [
              Container(
                height: StateM(context).height() / 2 - reSize(context, 100),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumYear: DateTime.now().year,
                  minimumDate: DateTime.now(),
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (val) {
                    _ronExpire = val;
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ButtonPrimary(
                  text: 'Select expire date',
                  callback: () {
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                ),
              )
            ],
          ),
        ),
        context);
  }
}
