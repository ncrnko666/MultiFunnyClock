// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Colors.white,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    String clockType = globals.clockList[globals.clockIndex].toString().substring(0,5).toLowerCase();
    globals.picHour1 = "assets/" + clockType + hour.substring(0,1) + ".png";
    globals.picHour2 = "assets/" + clockType + hour.substring(1,2) + ".png";
    globals.picMinute1 = "assets/" + clockType + minute.substring(0,1) + ".png";
    globals.picMinute2 = "assets/" + clockType + minute.substring(1,2) + ".png";

    DateTime curDateTime = DateTime.now();
    switch (globals.legendIndex){
      case 0: globals.legend = "MultiFunnyClock"; break;
      case 1: globals.legend = DateFormat('HH:mm').format(curDateTime); break;
      case 2: globals.legend = DateFormat('EEEE').format(curDateTime); break;
      case 3: globals.legend = DateFormat('dd.MM.yyyy').format(curDateTime); break;
      case 4: globals.legend = DateFormat('HH:mm').format(curDateTime) + "  " + DateFormat('EEEE').format(curDateTime); break;
      case 5: globals.legend = DateFormat('HH:mm  dd.MM.yyyy').format(curDateTime); break;
      case 6: globals.legend = DateFormat('HH:mm  dd.MM.yyyy').format(curDateTime) + "  " + DateFormat('EEEE').format(curDateTime); break;
    }

    return Container(
      color: colors[_Element.background],

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {changeClock();},
               child: Container(
                    margin: const EdgeInsets.only(left:30.0, bottom:3.0),
                      child: Text( globals.clockList[globals.clockIndex].toString().substring(8),
                        style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16,
                      ),
                    ),
                  ),
               ),
            ),

            Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Image.asset(globals.picHour1, scale: 1),
                      ),
                      Container(
                        child: Image.asset(globals.picHour2, scale: 1),
                      ),
                      Container(
                        child: Text( ":",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        child: Image.asset(globals.picMinute1, scale: 1),
                      ),
                      Container(
                        child: Image.asset(globals.picMinute2, scale: 1),
                      ),
                    ],
                  ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {changeLegend();},
                  child: Container(
                      margin: const EdgeInsets.only(top:3.0, right:30.0),
                      child: Text(globals.legend,
                        style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

            ],
          ),
        );

  }

  void changeClock(){
    globals.clockIndex += 1;
    if (globals.clockIndex == 6)
      globals.clockIndex = 0;

    setState((){});
  }

  void changeLegend(){
    globals.legendIndex += 1;
    if (globals.legendIndex == 7)
      globals.legendIndex = 0;

    setState((){});
  }

}
