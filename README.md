# Launch Counter

Flutter plugin that can show specific widgets based on the number of launches and install time.

[![Pub](https://img.shields.io/pub/v/launch_counter.svg)](https://pub.dartlang.org/packages/launch_counter)

### Introduction

We may want to display certain pages or dialogs based on the number of times the user has launched the app or the number of days since the first launch (e.g., to introduce other apps, offer paid plans, request surveys, etc.).

With this package, you can easily display specific Widgets based on the number of launches or install time.

## Minimal Example

Below is the minimal code example. This will be for the basic minimal working of this plugin.
The below will show a dialog or navigate to a new screen after the defined minimal days/minimal launches.

Place this in your main widget state :

```dart
LaunchCounter launchCounter = LaunchCounter(
  preferencesPrefix: 'launchCounter_',
  minDays: 0, // First day of install.
  minLaunches: 5, // 5 launches of app after minDays is passed.
// remindDays: 10,
// remindLaunches: 10,
);
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await launchCounter.init();
    if (mounted && launchCounter.isConditionMet) {
      // Show dialog or navigate to a new screen
    }
  });
}
```

If you want a more complete example, please check [this one](https://github.com/nosuke0926/launch_counter/tree/master/example) on Github.

## Notes

When a dialog or page is displayed, please choose one of the following options using the callEvent method:

- LaunchCounterEventType.later
- LaunchCounterEventType.neverShow

Otherwise, the dialog or page will be displayed again when the app is launched next time.
Please check [this one](https://github.com/nosuke0926/launch_counter/tree/master/example) on Github for more details.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/nosuke0926/launch_counter/issues).  
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/nosuke0926/launch_counter/pulls).
