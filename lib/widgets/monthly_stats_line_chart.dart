import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../data/database.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import '../widgets/statistic_chart.dart';

class MonthlyBarChart extends StatefulWidget {
  final List<BookWithLog> booksData;

  MonthlyBarChart({required this.booksData});

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  late List<BookQuantity> _chartData;
  late Color accentColor;
  late Color primaryColor;
  List<bool> _selectedButtons = [true, false];
  late DateTime _dateToBuildChart;

  void _setPreviousMonthDate() {
    var date = Jiffy(_dateToBuildChart).subtract(months: 1).dateTime;
    // show month stats only for this year
    if (DateTime.now().year == date.year) {
      setState(() {
        _dateToBuildChart = date;

        _chartData = _createMonthChartData();
        _chartData.sort(dayCompare);
      });
    }
  }

  void _setNextMonthDate() {
    var date = Jiffy(_dateToBuildChart).add(months: 1).dateTime;
    if (DateTime.now().month != _dateToBuildChart.month) {
      setState(() {
        _dateToBuildChart = date;
        _chartData = _createMonthChartData();
        _chartData.sort(dayCompare);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateToBuildChart = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    accentColor = Theme.of(context).accentColor;

    setState(() {
      _chartData = _createMonthChartData();
      _chartData.sort(dayCompare);
    });

    var total = 0;
    _chartData.forEach((d) => total += d.booksQuantity);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlineButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(tr('previous')),
                onPressed: () {
                  _setPreviousMonthDate();
                },
              ),
              if (_dateToBuildChart.month != DateTime.now().month)
                OutlineButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(tr('next')),
                  onPressed: () {
                    _setNextMonthDate();
                  },
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          height: 200,
          child: LineChart(
            monthLineChartData,
            swapAnimationCurve: Curves.easeIn,
            swapAnimationDuration: const Duration(milliseconds: 900),
          ),
        ),
        const SizedBox(
          height: AppConst.heightBetweenWidgets,
        ),
        Text(
          '${tr('total')} ${tr('in')} ${Helper.numberToMonth(_dateToBuildChart.month)}: $total',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  BookQuantity _addChartData(
    DateTime date,
    List<BookLog> statsData,
  ) {
    return BookQuantity(
        date.day,
        statsData
            .where(
              (ms) => Helper.isSameDate(ms.finishedDate!, date),
            )
            .toList()
            .length);
  }

  List<BookQuantity> _createMonthChartData() {
    var firstDayOfTheMonth =
        DateTime(_dateToBuildChart.year, _dateToBuildChart.month, 1);
    var lastDayOfTheMonth =
        DateTime(_dateToBuildChart.year, _dateToBuildChart.month + 1, 0);

    var monthStatsData = widget.booksData.map((b) => b.log).where((b) {
      return b.finishedDate != null &&
          b.finishedDate!
              .isAfter(firstDayOfTheMonth.subtract(const Duration(days: 1))) &&
          b.finishedDate!
              .isBefore(lastDayOfTheMonth.add(const Duration(days: 1)));
    }).toList();
    monthStatsData.sort((a, b) {
      return a.finishedDate!.compareTo(b.finishedDate!);
    });

    List<BookQuantity> data = [];

    data.add(_addChartData(firstDayOfTheMonth, monthStatsData));
    monthStatsData.forEach((element) {
      if (!data.any((d) => d.day == element.finishedDate!.day)) {
        data.add(_addChartData(element.finishedDate!, monthStatsData));
      }
    });
    data.add(_addChartData(lastDayOfTheMonth, monthStatsData));

    return data;
  }

  LineChartData get monthLineChartData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridDataMonth,
        titlesData: titlesDataMonth,
        borderData: borderData,
        lineBarsData: monthLineBarsData,
        clipData: FlClipData.all(),
        minX: 1,
        maxX: DateTime(_dateToBuildChart.year, _dateToBuildChart.month + 1, 0)
            .day
            .toDouble(),
        maxY: _chartData
                .reduce(
                    (b1, b2) => b1.booksQuantity > b2.booksQuantity ? b1 : b2)
                .booksQuantity
                .toDouble() +
            1,
        minY: 0,
      );

  int dayCompare(BookQuantity b1, BookQuantity b2) => b1.day - b2.day;

  LineTouchData get lineTouchData => LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: lineTouchTooltipData,
      );

  LineTouchTooltipData get lineTouchTooltipData => LineTouchTooltipData(
      tooltipBgColor: Colors.primaries.last,
      getTooltipItems: (spot) {
        var booksQuantity = spot[0].y.toInt();
        var quantityText =
            '$booksQuantity ${booksQuantity == 1 ? tr("oneBook") : tr("manyBooks")}';
        var dateText = '${spot[0].x.toInt()}.${DateTime.now().month}';
        var tooltipText = '$quantityText\n$dateText';
        return [
          LineTooltipItem(
            tooltipText,
            const TextStyle(color: Colors.black),
          ),
        ];
      });

  FlTitlesData get titlesDataMonth => FlTitlesData(
        bottomTitles: bottomTitlesMonth,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            return value.toInt().toString();
          },
        ),
      );

  List<LineChartBarData> get monthLineBarsData => [
        lineChartBarMonth,
      ];

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 20,
        getTextStyles: (context, value) => const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );

  SideTitles get bottomTitlesMonth => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) {
          if (value.toInt().isOdd) {
            return value.toInt().toString();
          }
          return "";
        },
      );

  FlGridData get gridDataMonth => FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 2);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff000000), width: 0.5),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarMonth => LineChartBarData(
      isCurved: false,
      curveSmoothness: 0.1,
      colors: [accentColor],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
          show: true,
          getDotPainter: (spot, x, chartData, y) {
            if (spot.y == 0) {
              return FlDotCirclePainter(
                  color: Colors.transparent, strokeColor: Colors.transparent);
            }
            return FlDotCirclePainter(color: accentColor.darken(85));
          }),
      belowBarData: BarAreaData(
        show: false,
      ),
      spots: _createMonthChartData()
          .map((e) => FlSpot(e.day.toDouble(), e.booksQuantity.toDouble()))
          .toList());
}
