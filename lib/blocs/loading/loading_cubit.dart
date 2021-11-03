import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import '../../blocs/loading/loading_state.dart';
import '../../utils/alerts_helper.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingInitial());

  showLoading(BuildContext context, String message, bool isDismissible) {
    AlertHelper.showProgress(context, message, isDismissible);
  }

  hideLoading() => AlertHelper.hideProgress();
}