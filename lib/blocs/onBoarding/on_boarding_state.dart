abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  int currentPageCount;

  OnBoardingInitial(this.currentPageCount);
}