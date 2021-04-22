abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppBottomNavBarState extends AppStates {}

class AppGetBusinessCircularState extends AppStates {}

class AppGetBusinessSuccessState extends AppStates {}

class AppGetBusinessWrongState extends AppStates {
  final String error;

  AppGetBusinessWrongState(this.error);
}

class AppGetSportsCircularState extends AppStates {}

class AppGetSportsSuccessState extends AppStates {}

class AppGetSportsWrongState extends AppStates {
  final String error;

  AppGetSportsWrongState(this.error);
}

class AppGetScienceCircularState extends AppStates {}

class AppGetScienceSuccessState extends AppStates {}

class AppGetScienceWrongState extends AppStates {
  final String error;

  AppGetScienceWrongState(this.error);
}
