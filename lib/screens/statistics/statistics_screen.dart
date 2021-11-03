import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/database.dart';
import '../../widgets/statistic_chart.dart';
import '../../utils/constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<bool> _isSelected = [true, false];
  var _currentIndex = 0;

  bool _containsFinishedBooks(List<BookWithLog>? books) {
    if (books != null && books.isNotEmpty) {
      return books.any((b) => b.log.isFinished == true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('statistics')),
      ),
      body: StreamBuilder(
        stream:
            Provider.of<BooksDao>(context, listen: false).watchBookWithLogs(),
        builder: (context, AsyncSnapshot<List<BookWithLog>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !_containsFinishedBooks(snapshot.data)) {
            return Center(
              child: Text(tr('noReadBookYet')),
            );
          }

          return Column(
            children: [
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
              DefaultTabController(
                length: 2,
                child: ToggleButtons(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(tr('month')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(tr('week')),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _isSelected[buttonIndex] = true;
                          _currentIndex = buttonIndex;
                        } else {
                          _isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: _isSelected,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 385,
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                child: StatisticCharts(
                  data: snapshot.data!,
                  isMonthChart: _currentIndex == 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
