import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterStreamBuilder(),
    );
  }
}

class FlutterStreamBuilder extends StatefulWidget {
  const FlutterStreamBuilder({super.key});

  @override
  State<FlutterStreamBuilder> createState() => _FlutterStreamBuilderState();
}

class _FlutterStreamBuilderState extends State<FlutterStreamBuilder> {
  late Stream<int?> numberStream;
  Stream<int?> getNumbers() async* {
    await Future.delayed(const Duration(seconds: 4));
    yield 1;
    await Future.delayed(const Duration(seconds: 2));
    yield 2;
    await Future.delayed(const Duration(seconds: 1));
    yield 3;
  }

  @override
  void initState() {
    super.initState();
    numberStream = getNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stream Builder"),
      ),
      body: Center(
        child: StreamBuilder<int?>(
          stream: numberStream,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text("Data Not Available");
              case ConnectionState.waiting:
                return Text("⌛ Wait",
                    style: Theme.of(context).textTheme.headline2);
              case ConnectionState.active:
                if (snapshot.hasData) {
                  int number = snapshot.data!;
                  return Text("👩 $number",
                      style: Theme.of(context).textTheme.headline2);
                } else {
                  return const Text("No data!");
                }
              case ConnectionState.done:
                if (snapshot.hasData) {
                  int number = snapshot.data!;
                  return Text("✅ $number",
                      style: Theme.of(context).textTheme.headline2);
                } else {
                  return const Text("No data!");
                }

              default:
                return Container();
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.restore),
        onPressed: () {
          setState(
            () {
              numberStream = getNumbers();
            },
          );
        },
      ),
    );
  }
}
