import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        initialDecrease: 0.05,
        initialPeriod: 1.5,
        initialStartingValue: 5000,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.initialStartingValue,
    required this.initialPeriod,
    required this.initialDecrease,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final double initialStartingValue;
  final double initialPeriod;
  final double initialDecrease;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  late double _value;
  late double _startingValue;
  late double _decrease;
  late Duration _period;
  bool isStopped = true;

  @override
  void initState() {
    super.initState();
    _startingValue = widget.initialStartingValue;
    _value = widget.initialStartingValue;
    _decrease = widget.initialDecrease;
    _period = Duration(milliseconds: (widget.initialPeriod * 1000).round());
  }

  void startTimer() {
    setState(() {
      if (_value <= 0) {
        return;
      }

      isStopped = false;
      _timer = Timer.periodic(_period, (timer) {
        setState(() {
          _value -= _decrease * _startingValue;
          if (_value <= 0) {
            stopTimer();
          }
        });
      });
    });
  }

  void stopTimer() {
    setState(() {
      isStopped = true;
      _timer.cancel();
    });
  }

  void reset() {
    setState(() {
      _value = _startingValue;
    });
  }

  void updateStartingValue(double value) {
    setState(() {
      _startingValue = value;
    });
  }

  void updateDecrease(double decrease) {
    setState(() {
      _decrease = decrease / 100;
    });
  }

  void updatePeriod(double seconds) {
    _period = Duration(milliseconds: (seconds * 1000).round());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () {
          isStopped ? startTimer() : stopTimer();
        },
        const SingleActivator(LogicalKeyboardKey.keyR): () {
          reset();
        }
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text("Gibberish timer"),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your reward:',
                ),
                Text(
                  '\$${_value.round()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isStopped
                        ? ElevatedButton(
                            onPressed: startTimer,
                            style: Theme.of(context).elevatedButtonTheme.style,
                            child: const Text("Start"),
                          )
                        : Container(),
                    !isStopped
                        ? ElevatedButton(
                            onPressed: stopTimer,
                            style: Theme.of(context).elevatedButtonTheme.style,
                            child: const Text("Stop"),
                          )
                        : Container(),
                    const SizedBox(
                      width: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: reset,
                      child: const Text("Reset"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120.0,
                      height: 48.0,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Starting value"),
                        onChanged: (value) {
                          updateStartingValue(double.parse(value));
                          reset();
                        },
                        initialValue:
                            widget.initialStartingValue.round().toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    SizedBox(
                      width: 120.0,
                      height: 48.0,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Decrease %"),
                        onChanged: (value) =>
                            updateDecrease(double.parse(value)),
                        initialValue:
                            (widget.initialDecrease * 100).round().toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    SizedBox(
                      width: 120.0,
                      height: 48.0,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Period, seconds"),
                        onChanged: (value) => updatePeriod(double.parse(value)),
                        initialValue: widget.initialPeriod.toString(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
