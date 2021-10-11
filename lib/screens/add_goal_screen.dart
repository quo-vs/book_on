import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../screens/goals_screen.dart';
import '../utils/constants.dart';

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
        await _addGoalOrUpdate(int.tryParse(_dailyAmountController.text) ?? 0, GoalType.Day);
      }
      if (_mounthlyAmountController.text.isNotEmpty) {
        await _addGoalOrUpdate(int.tryParse(_mounthlyAmountController.text) ?? 0, GoalType.Mounth);
      }
      if (_yearlyAmountController.text.isNotEmpty) {
        await _addGoalOrUpdate(int.tryParse(_yearlyAmountController.text) ?? 0, GoalType.Year);
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
        goalAmount: amount,
        createdAt: DateTime.now(),
        type: type);
      
    await dao.insertGoal(newGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('addGoals')),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), 
            onPressed: _saveForm
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
              TextFormField(
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
              TextFormField(
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
