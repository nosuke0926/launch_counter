import 'package:example/content.dart';
import 'package:flutter/material.dart';
import 'package:launch_counter/launch_counter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Launch Counter Example',
      home: HomePage(),
    );
  }
}

/// A widget.
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

/// The body state of the main Launch counter test widget.
class HomePageState extends State<HomePage> {
  /// The widget builder.
  WidgetBuilder builder = buildProgressIndicator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: LaunchCounterBuilder(
        // launchCounter: LaunchCounter(
        //   minDays: 7,
        //   minLaunches: 7,
        //   remindDays: 10,
        //   remindLaunches: 10,
        // ),
        builder: builder,
        onInitialized: (context, launchCounter) {
          setState(() => builder = (context) => ContentWidget(
                launchCounter: launchCounter,
              ));

          for (var condition in launchCounter.conditions) {
            if (condition is DebuggableCondition) {
              print(condition
                  .valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
            }
          }

          print(
              'Are all conditions met ? ${launchCounter.isConditionMet ? 'Yes' : 'No'}');

          if (launchCounter.isConditionMet) {
            // Show dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text("Introducing Our New App!"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          "Exciting news! We have just released new app! Download now and experience the convenience and efficiency for yourself. "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: const Text("later"),
                            onPressed: () {
                              launchCounter
                                  .callEvent(LaunchCounterEventType.later);
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            child: const Text("Download"),
                            onPressed: () {
                              launchCounter
                                  .callEvent(LaunchCounterEventType.neverShow);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          launchCounter
                              .callEvent(LaunchCounterEventType.neverShow);
                          Navigator.pop(context);
                        },
                        child: const Text("Don't show this message again"),
                      )
                    ],
                  ),
                );
              },
            );

            // Or navigate to a new screen
            // Navigator.of(
            //   context,
            //   rootNavigator: true,
            // ).push<void>(
            //   MaterialPageRoute(
            //     builder: (context) => NewPage(
            //       launchCounter: launchCounter,
            //     ),
            //     fullscreenDialog: true,
            //   ),
            // );
          }
        },
      ),
    );
  }

  /// Builds the progress indicator, allowing to wait for Launch counter to initialize.
  static Widget buildProgressIndicator(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
