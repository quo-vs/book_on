import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/src/flex_extensions.dart';

import '../data/database.dart';
import '../utils/functions.dart';
import '../widgets/statistic_chart.dart';

class WeeklyBarChart extends StatefulWidget {
  final List<BookWithLog> booksData;

  const WeeklyBarChart({
    Key? key, 
    required this.booksData
  }) : super(key: key);

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  late Color primaryColor;
  late Color accentColor;
  
  int touchedIndex = -1;
  
  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    accentColor = Theme.of(context).accentColor;

    return BarChart(
      mainBarData(),
      swapAnimationDuration: const Duration(milliseconds: 900),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 32,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [accentColor] : [ primaryColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: accentColor.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: _createWeekChartData()
                .reduce(
                    (b1, b2) => b1.booksQuantity > b2.booksQuantity ? b1 : b2)
                .booksQuantity
                .toDouble(),
            colors: [primaryColor.lighten(40)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BookQuantity> _createWeekChartData() {
    var now = DateTime.now();

    int daysOfWeek = now.weekday - 1;
    DateTime firstDay = DateTime(now.year, now.month, now.day - daysOfWeek);
    DateTime lastDay = firstDay.add(const Duration(days: 6, hours: 23, minutes: 59));

    //TODO: add prev and next week buttons

    // DateTime nextFirst = firstDay.add(const Duration(days: 7));
    // DateTime nextLast = lastDay.add(const Duration(days: 7));

    // DateTime prevFirst = firstDay.subtract(const Duration(days: 7));
    // DateTime prevLast = lastDay.subtract(const Duration(days: 7));

    var weekStatsData = widget.booksData.map((b) => b.log).where((b) {
      return b.finishedDate != null &&
          b.finishedDate!.isAfter(firstDay) &&
          b.finishedDate!.isBefore(lastDay);
    }).toList();

    List<BookQuantity> data = [];
    for (var day = firstDay.weekday - 1; day <= lastDay.weekday - 1; day++) {
      var found = weekStatsData
          .where(
              (d) => d.finishedDate != null && d.finishedDate?.weekday == day)
          .toList();
      if (found.isNotEmpty) {
        data.add(_addChartWeekData(found.first.finishedDate!, weekStatsData));
      } else {
        data.add(BookQuantity(day, 0));
      }
    }

    return data;
  }

  BookQuantity _addChartWeekData(
    DateTime date,
    List<BookLog> statsData,
  ) {
    return BookQuantity(
        date.weekday,
        statsData
            .where(
              (ms) => Functions.isSameDate(ms.finishedDate!, date),
            )
            .toList()
            .length);
  }

  List<BarChartGroupData> showingGroups() {
    var data = _createWeekChartData();
    var result = data.map((bq) {
      switch (bq.day) {
        case 0:
          return makeGroupData(0, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 1:
          return makeGroupData(1, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 2:
          return makeGroupData(2, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 3:
          return makeGroupData(3, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 4:
          return makeGroupData(4, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 5:
          return makeGroupData(5, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        case 6:
          return makeGroupData(6, bq.booksQuantity.toDouble(),
              isTouched: bq.day == touchedIndex);
        default:
          return throw Error();
      }
    }).toList();

    return result;
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = tr('monday');
                  break;
                case 1:
                  weekDay = tr('tuesday');
                  break;
                case 2:
                  weekDay = tr('wednesday');
                  break;
                case 3:
                  weekDay = tr('thursday');
                  break;
                case 4:
                  weekDay = tr('friday');
                  break;
                case 5:
                  weekDay = tr('saturday');
                  break;
                case 6:
                  weekDay = tr('sunday');
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: TextStyle(
                      color: accentColor.lighten(),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return tr('monday').substring(0, 1);
              case 1:
                return tr('tuesday').substring(0, 1);
              case 2:
                return tr('wednesday').substring(0, 1);
              case 3:
                return tr('thursday').substring(0, 1);
              case 4:
                return tr('friday').substring(0, 1);
              case 5:
                return tr('saturday').substring(0, 1);
              case 6:
                return tr('sunday').substring(0, 1);
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }
}
