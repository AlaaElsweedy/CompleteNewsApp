import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];

  List<Widget> pages = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  int currentIndex = 0;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(AppBottomNavBarState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    emit(AppGetBusinessCircularState());

    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': 'bb48161fe5a64786bb32fb7896e1b487',
      },
    ).then((value) {
      business = value.data['articles'];
      print(business.length);
      emit(AppGetBusinessSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppGetBusinessWrongState(onError.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(AppGetSportsCircularState());

    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': 'bb48161fe5a64786bb32fb7896e1b487',
        },
      ).then((value) {
        sports = value.data['articles'];
        print(sports.length);
        emit(AppGetSportsSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(AppGetSportsWrongState(onError.toString()));
      });
    } else {
      emit(AppGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    emit(AppGetScienceCircularState());

    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': 'bb48161fe5a64786bb32fb7896e1b487',
        },
      ).then((value) {
        science = value.data['articles'];
        print(science.length);
        emit(AppGetScienceSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(AppGetScienceWrongState(onError.toString()));
      });
    } else {
      emit(AppGetScienceSuccessState());
    }
  }

  bool isDark = false;

  void changeModeTheme({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeThemeState());
    } else {
      isDark = !isDark;
      CacheHelper.setBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeThemeState());
      });
    }
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    emit(AppGetSearchCircularState());

    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q': '$value',
        'apiKey': 'bb48161fe5a64786bb32fb7896e1b487',
      },
    ).then((value) {
      search = value.data['articles'];
      emit(AppGetSearchSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppGetSearchWrongState(onError.toString()));
    });
  }
}
