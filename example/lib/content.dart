import 'package:flutter/material.dart';
import 'package:launch_counter/launch_counter.dart';

/// The app's main content widget.
class ContentWidget extends StatefulWidget {
  /// The Launch counter instance.
  final LaunchCounter launchCounter;

  /// Creates a new content widget instance.
  const ContentWidget({
    super.key,
    required this.launchCounter,
  });

  @override
  State<StatefulWidget> createState() => _ContentWidgetState();
}

/// The content widget state.
class _ContentWidgetState extends State<ContentWidget> {
  /// Contains all debuggable conditions.
  List<DebuggableCondition> debuggableConditions = [];

  /// Whether the dialog should be opened.
  bool isConditionMet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (DebuggableCondition condition in debuggableConditions)
              textCenter(condition.valuesAsString),
            textCenter('Are conditions met ? ${isConditionMet ? 'Yes' : 'No'}'),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: ElevatedButton(
            //     onPressed: () async {
            //       await widget.launchCounter.showRateDialog(
            //           context); // We launch the default Launch counter dialog.
            //       refresh();
            //     },
            //     child: const Text('Launch "Launch counter" dialog'),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await widget.launchCounter.showStarRateDialog(context,
            //         actionsBuilder: (_, stars) => starRateDialogActionsBuilder(
            //             context,
            //             stars)); // We launch the Launch counter dialog with stars.
            //     refresh();
            //   },
            //   child: const Text('Launch "Launch counter" star dialog'),
            // ),
            ElevatedButton(
              onPressed: () async {
                await widget.launchCounter
                    .reset(); // We reset all Launch counter conditions values.
                refresh();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      );

  /// Returns a centered text.
  Text textCenter(String content) => Text(
        content,
        textAlign: TextAlign.center,
      );

  /// Allows to refresh the widget state.
  void refresh() {
    setState(() {
      debuggableConditions = widget.launchCounter.conditions
          .whereType<DebuggableCondition>()
          .toList();
      isConditionMet = widget.launchCounter.isConditionMet;
    });
  }
}
