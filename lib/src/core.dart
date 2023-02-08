import 'dart:async';

import 'package:launch_counter/src/conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Allows to show widgets if custom conditions are met (eg. install time, number of launches, etc...).
class LaunchCounter {
  /// Prefix for preferences.
  final String preferencesPrefix;

  /// All conditions that should be met to show the dialog.
  final List<Condition> conditions;

  /// Creates a new Launch counter instance.
  LaunchCounter({
    this.preferencesPrefix = 'launchCounter_',
    int minDays = 7,
    int remindDays = 7,
    int minLaunches = 10,
    int remindLaunches = 10,
  }) : conditions = [] {
    populateWithDefaultConditions(
      minDays: minDays,
      remindDays: remindDays,
      minLaunches: minLaunches,
      remindLaunches: remindLaunches,
    );
  }

  /// Initializes the plugin (loads base launch date, app launches and whether the dialog should not be opened again).
  Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (Condition condition in conditions) {
      condition.readFromPreferences(preferences, preferencesPrefix);
    }
    await callEvent(LaunchCounterEventType.initialized);
  }

  /// Saves the plugin current data to the shared preferences.
  Future<void> save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (Condition condition in conditions) {
      await condition.saveToPreferences(preferences, preferencesPrefix);
    }

    await callEvent(LaunchCounterEventType.saved);
  }

  /// Resets the plugin data.
  Future<void> reset() async {
    for (Condition condition in conditions) {
      condition.reset();
    }
    await save();
  }

  /// Whether the widget should be showed.
  bool get isConditionMet {
    for (Condition condition in conditions) {
      if (!condition.isMet) {
        return false;
      }
    }
    return true;
  }

  /// Calls the specified event.
  Future<void> callEvent(LaunchCounterEventType eventType) async {
    bool saveSharedPreferences = false;
    for (Condition condition in conditions) {
      saveSharedPreferences =
          condition.onEventOccurred(eventType) || saveSharedPreferences;
    }
    if (saveSharedPreferences) {
      await save();
    }
  }

  /// Adds the default conditions to the current conditions list.
  void populateWithDefaultConditions({
    required int minDays,
    required int remindDays,
    required int minLaunches,
    required int remindLaunches,
  }) {
    conditions.add(MinimumDaysCondition(
      minDays: minDays,
      remindDays: remindDays,
    ));
    conditions.add(MinimumAppLaunchesCondition(
      minLaunches: minLaunches,
      remindLaunches: remindLaunches,
    ));
    conditions.add(DoNotOpenAgainCondition());
  }
}

/// Represents all events that can occur during the Launch counter lifecycle.
enum LaunchCounterEventType {
  /// When Launch counter is fully initialized.
  initialized,

  /// When Launch counter is saved.
  saved,

  /// When the later button has been pressed.
  later,

  /// When the never show again button has been pressed.
  neverShow,
}
