import 'package:flutter/material.dart';
import 'package:launch_counter/src/core.dart';

/// Should be called once Launch counter has been initialized.
typedef LaunchCounterInitializedCallback = Function(
  BuildContext context,
  LaunchCounter launchCounter,
);

/// Allows to build a widget and initialize Launch counter.
class LaunchCounterBuilder extends StatefulWidget {
  /// The widget builder.
  final WidgetBuilder builder;

  /// The Launch counter instance.
  final LaunchCounter? launchCounter;

  /// Called when launch counter has been initialized.
  final LaunchCounterInitializedCallback onInitialized;

  /// Creates a new launch counter builder instance.
  const LaunchCounterBuilder({
    Key? key,
    required this.onInitialized,
    required this.builder,
    this.launchCounter,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LaunchCounterBuilderState();
}

/// The launch counter builder state.
class _LaunchCounterBuilderState extends State<LaunchCounterBuilder> {
  /// The current Launch counter instance.
  late LaunchCounter launchCounter;

  @override
  void initState() {
    super.initState();

    launchCounter = widget.launchCounter ?? LaunchCounter();
    initLaunchCounter();
  }

  /// Allows to init launch counter. Should be called one time per app launch.
  Future<void> initLaunchCounter() async {
    await launchCounter.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onInitialized(context, launchCounter);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
