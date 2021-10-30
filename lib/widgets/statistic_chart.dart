import 'package:book_on/widgets/monthly_stats_line_chart.dart';
import 'package:book_on/widgets/weekly_stats_bar_chart.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../data/database.dart';


class StatisticCharts extends StatefulWidget {
  final List<BookWithLog> data;
  final bool isMonthChart;

  StatisticCharts({required this.data, this.isMonthChart = true});

  @override
  State<StatefulWidget> createState() => StatisticChartsState();
}

class StatisticChartsState extends State<StatisticCharts> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              Text(
                widget.isMonthChart
                    ? tr('monthStatistic')
                    : tr('weekStatistic'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: _Charts(
                    booksData: widget.data,
                    isMonthChart: widget.isMonthChart,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _Charts extends StatefulWidget {
  final bool isMonthChart;
  final List<BookWithLog> booksData;

  const _Charts({Key? key, required this.booksData, required this.isMonthChart})
      : super(key: key);

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<_Charts> {
  late List<BookQuantity> _chartData;

  int touchedIndex = -1;
  final Color barBackgroundColor = const Color(0xff72d8bf);

  @override
  Widget build(BuildContext context) {
    return widget.isMonthChart
        ? MonthlyBarChart(
            booksData: widget.booksData,
          )
        : WeeklyBarChart(
          booksData: widget.booksData
        );
  }
}

class BookQuantity {
  final int day;
  final int booksQuantity;

  BookQuantity(this.day, this.booksQuantity);
}
