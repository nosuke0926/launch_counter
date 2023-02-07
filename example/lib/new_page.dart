import 'package:flutter/material.dart';
import 'package:launch_counter/launch_counter.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    super.key,
    required this.launchCounter,
  });

  final LaunchCounter launchCounter;

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Introducing Our New App!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Exciting news! We have just released new app! Download now and experience the convenience and efficiency for yourself. "),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("later"),
                onPressed: () {
                  widget.launchCounter.callEvent(LaunchCounterEventType.later);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                child: const Text("Download"),
                onPressed: () {
                  widget.launchCounter.callEvent(LaunchCounterEventType.ok);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: () {
              widget.launchCounter.callEvent(LaunchCounterEventType.neverShow);
              Navigator.pop(context);
            },
            child: const Text("Don't show this message again"),
          ),
        ],
      ),
    );
  }
}
