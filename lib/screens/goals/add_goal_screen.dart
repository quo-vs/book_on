import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../utils/constants.dart';
import '../../screens/goals/goals_screen.dart';


class AddGoalScreen extends StatefulWidget {
  static const routeName = '/add-goal';

  const AddGoalScreen({Key? key}) : super(key: key);

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dailyAmountController = TextEditingController();
  final _mounthlyAmountController = TextEditingController();
  final _yearlyAmountController = TextEditingController();
  var _isLoading = false;
  var _isAddingMode = false;
  GoalType? goalType;
  GoalMode? mode;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final Arguments? args = ModalRoute.of(context)?.settings.arguments as Arguments?;
    if (args != null) {
      if (GoalType.values.contains(args.type) && GoalMode.values.contains(args.mode)) {
        setState(() {
          goalType = args.type;
          mode = args.mode;
        });
      }
      _isAddingMode = false;
    } else {
      _isAddingMode = true;
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_dailyAmountController.text.isNotEmpty) {
        await _addGoalOrUpdate(
            int.tryParse(_dailyAmountController.text) ?? 0, GoalType.Day);
      }
      if (_mounthlyAmountController.text.isNotEmpty) {
        await _addGoalOrUpdate(
            int.tryParse(_mounthlyAmountController.text) ?? 0, GoalType.Mounth);
      }
      if (_yearlyAmountController.text.isNotEmpty) {
        await _addGoalOrUpdate(
            int.tryParse(_yearlyAmountController.text) ?? 0, GoalType.Year);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr('anErrorOccured')),
          content: Text(error.toString()),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(tr('ok')),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _addGoalOrUpdate(int amount, GoalType type) async {
    var dao = Provider.of<GoalsDao>(context, listen: false);
    var existsGoal = await dao.existsGoal(type);
    if (existsGoal != null) {
      var updateEntity = existsGoal.copyWith(goalAmount: amount);
      await dao.updateGoal(updateEntity);
      return;
    }
    var newGoal = GoalsCompanion.insert(
        goalAmount: amount, createdAt: DateTime.now(), type: type);

    await dao.insertGoal(newGoal);
  }

  Widget _buildTitle() {
    if (mode == GoalMode.Edit) {
      return Text(tr('updateGoal'));
    }
    if (mode == GoalMode.Set) {
      return Text(tr('setGoal'));
    }

    return Text(tr('addGoals'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_isAddingMode || goalType == GoalType.Day) TextFormField(
                decoration: InputDecoration(
                  labelText: tr('pagesGoalLabel'),
                  fillColor: Colors.transparent,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _dailyAmountController,
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
               if (_isAddingMode || goalType == GoalType.Mounth) TextFormField(
                decoration: InputDecoration(
                  labelText: tr('booksMonthlyLabel'),
                  fillColor: Colors.transparent,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _mounthlyAmountController,
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
               if (_isAddingMode || goalType == GoalType.Year) TextFormField(
                decoration: InputDecoration(
                  labelText: tr('booksYearlyLabel'),
                  fillColor: Colors.transparent,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _yearlyAmountController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Arguments {
  final GoalType type;
  final GoalMode mode;
 
  Arguments(this.type, this.mode);
}

enum GoalMode {
  Set, 
  Edit
}
