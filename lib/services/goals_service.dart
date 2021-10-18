import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';

class GoalsService {
  static final GoalsService _instance = GoalsService.internal();
  factory GoalsService() => _instance;
  GoalsService.internal();

  addGolas(BuildContext context) async {
    CollectionReference goals =
        FirebaseFirestore.instance.collection('goals');
    var localGoals =
        await Provider.of<GoalsDao>(context, listen: false).getGoals();

    for (var goal in localGoals) {
      goals
          .add(goal.toJson())
          .then((value) => print("Goal Added"))
          .catchError((error) => print("Failed to add goal: $error"));
    }
  }
}
