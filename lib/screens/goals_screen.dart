import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../data/database.dart';
import '../screens/add_goal_screen.dart';
import '../utils/constants.dart';
import '../utils/functions.dart';

enum GoalType { Day, Mounth, Year }

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<bool> _isSelected = [true, false, false];
  var _currentIndex = 0;
  var _goalsExists = false;

  @override
  Widget build(BuildContext context) {
    var goalsDao = Provider.of<GoalsDao>(context);
    goalsDao.getGoals().then((goals) {
      _goalsExists = goals.isEmpty ? false : true;
    });

    return Scaffold(
      appBar: AppBar(
        leading: _goalsExists == true
            ? IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Functions.pushPageNamed(context, AddGoalScreen.routeName);
                })
            : null,
        title: Text(tr('goals')),
      ),
      body: StreamBuilder(
        stream: goalsDao.watchAllGoals(),
        builder: (ctx, AsyncSnapshot<List<Goal>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data?.length == 0) {
            return Center(
              child: Text(tr('addGoals')),
            );
          }
          
          return StreamBuilder(
            stream: Provider.of<BooksDao>(context, listen: false)
                .watchBookWithLogs(),
            builder: (ctx, AsyncSnapshot<List<BookWithLog>> snapshotBooks) {
              if (snapshotBooks.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 140,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppConst.heightBetweenWidgets,
                      ),
                      DefaultTabController(
                        length: 3,
                        child: ToggleButtons(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(tr('day')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(tr('month')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(tr('year')),
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
                      _buildGoalText(
                          GoalType.values[_currentIndex], snapshot.data!),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: _buildRadialGaugeWidget(
                            GoalType.values[_currentIndex],
                            snapshot.data!,
                            snapshotBooks.data),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGoalText(GoalType goalType, List<Goal> goals) {
    var goal =
        goals.where((goal) => goal.type == GoalType.values[_currentIndex]);
    if (goal.iterator.moveNext() && goal.first.goalAmount > 0) {
      switch (goalType) {
        case GoalType.Day:
          return Text(
              tr('dailyGoalText', args: [goal.first.goalAmount.toString()]));
        case GoalType.Mounth:
          return Text(
              tr('montlyGoalText', args: [goal.first.goalAmount.toString()]));
        case GoalType.Year:
          return Text(
              tr('yearlyGoalText', args: [goal.first.goalAmount.toString()]));
      }
    }

    return Text(tr("noGoalSet"));
  }

  void _updateGoal(GoalType type) {
    Navigator.of(context).pushNamed(AddGoalScreen.routeName,
        arguments: Arguments(type, GoalMode.Edit));
  }

  void _setGoal(GoalType type) {
    Navigator.of(context).pushNamed(AddGoalScreen.routeName,
        arguments: Arguments(type, GoalMode.Set));
  }

  Widget _buildRadialGaugeWidget(
      GoalType goalType, List<Goal> goals, List<BookWithLog>? books) {
    var goal =
        goals.where((goal) => goal.type == GoalType.values[_currentIndex]);
    if (goal.iterator.moveNext() && goal.first.goalAmount.toDouble() > 0) {
      switch (goalType) {
        case GoalType.Day:
          {
            num readPagesToday = Functions.getPageAmountReadToday(books);
            return _buildRadialGaugeItem(goal.first, readPagesToday);
          }

        case GoalType.Mounth:
          {
            int readBooksThisMonth = Functions.getBooksReadThisMonth(books);
            return _buildRadialGaugeItem(goal.first, readBooksThisMonth);
          }
        case GoalType.Year:
          {
            int readBooksThisYear = Functions.getBooksReadThisYear(books);
            return _buildRadialGaugeItem(goal.first, readBooksThisYear);
          }
      }
    }
    return Center(
        child: FlatButton(
      onPressed: () {
        _setGoal(GoalType.values[_currentIndex]);
      },
      child: Text(
        tr('setGoal'),
      ),
    ));
  }

  Column _buildRadialGaugeItem(Goal goal, num readPagesToday) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RadialGaugeWidget(
            goalAmount: goal.goalAmount,
            readStateAmount: readPagesToday,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: () {
            _updateGoal(GoalType.values[_currentIndex]);
          },
          child: Text(tr('updateGoal')),
        ),
      ],
    );
  }
}

class RadialGaugeWidget extends StatelessWidget {
  const RadialGaugeWidget({
    Key? key,
    required this.goalAmount,
    required this.readStateAmount,
  }) : super(key: key);

  final int goalAmount;
  final num readStateAmount;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration:
          const Duration(milliseconds: 1200).inMilliseconds.toDouble(),
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: goalAmount.toDouble(),
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Color.fromARGB(30, 0, 169, 181),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
                value: readStateAmount.toDouble(),
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 100,
                animationType: AnimationType.linear)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Text(
                '${readStateAmount.toInt()} / $goalAmount',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
