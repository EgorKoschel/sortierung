import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortierung/sortierung.dart';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortierung',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sortierung'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> list = [];
  List<int> sortedListBubble = [];
  List<int> sortedListSelection = [];
  List<int> sortedListInsertion = [];
  List<int> sortedListQuick = [];
  List<int> sortedListMerge = [];
  final controllerLength = TextEditingController(text: '10');
  final controllerMaxValue = TextEditingController(text: '100');
  final controllerRepeat = TextEditingController(text: '1');

  Duration? timeBubbleSort;
  Duration? timeSelectionSort;
  Duration? timeInsertionSort;
  Duration? timeQuickSort;
  Duration? timeMergeSort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Array:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 110,
                      child: TextField(
                        maxLength: 2,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: controllerLength,
                        decoration: const InputDecoration(
                          labelText: 'Length',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          counterText: '',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      maxLength: 4,
                      controller: controllerMaxValue,
                      decoration: const InputDecoration(
                        labelText: 'Max Value',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  list.isEmpty ? 'Bitte geben Sie die Länge und den maximalen Wert des Arrays ein.' : list.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      final int length = int.tryParse(controllerLength.text) ?? 0;
                      final int maxValue = int.tryParse(controllerMaxValue.text) ?? 0;
                      setState(() {
                        list = Sortierung.generateRandomList(length, maxValue: maxValue);
                        timeBubbleSort = null;
                        timeSelectionSort = null;
                        timeInsertionSort = null;
                        timeQuickSort = null;
                        timeMergeSort = null;
                      });
                    },
                    child: const Text('Generate Random List')),
              ),
              Visibility(
                visible: list.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Repeat:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 130,
                        child: TextField(
                          maxLength: 10,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: controllerRepeat,
                          decoration: const InputDecoration(
                            labelText: 'Repeat',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            counterText: '',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final repeat = int.tryParse(controllerRepeat.text) ?? 1;
                          setState(() {
                            final stopwatch = Stopwatch()..start();
                            for (int i = 0; i < repeat; i++) {
                              sortedListBubble = Sortierung.bubbleSort(list);
                            }
                            timeBubbleSort = stopwatch.elapsed;

                            stopwatch.reset();
                            stopwatch.start();
                            for (int i = 0; i < repeat; i++) {
                              sortedListSelection = Sortierung.selectionSort(list);
                            }
                            timeSelectionSort = stopwatch.elapsed;

                            stopwatch.reset();
                            stopwatch.start();
                            for (int i = 0; i < repeat; i++) {
                              sortedListInsertion = Sortierung.insertionSort(list);
                            }
                            timeInsertionSort = stopwatch.elapsed;

                            stopwatch.reset();
                            stopwatch.start();
                            for (int i = 0; i < repeat; i++) {
                              sortedListQuick = Sortierung.quickSort(list);
                            }
                            timeQuickSort = stopwatch.elapsed;

                            stopwatch.reset();
                            stopwatch.start();
                            for (int i = 0; i < repeat; i++) {
                              sortedListMerge = Sortierung.mergeSort(list);
                            }
                            timeMergeSort = stopwatch.elapsed;
                          });
                        },
                        child: const Text('Sort')),
                  ],
                ),
              ),
              if (timeBubbleSort != null)
                Column(
                  children: [
                    const Divider(),
                    Text(timeBubbleSort!.inMilliseconds == 0
                        ? 'Bubble Sort: ${timeBubbleSort!.inMicroseconds} µs'
                        : timeBubbleSort!.inSeconds == 0
                            ? 'Bubble Sort: ${timeBubbleSort!.inMilliseconds} ms'
                            : 'Bubble Sort: ${timeBubbleSort!.inSeconds} s, ${timeBubbleSort!.inMilliseconds.remainder(1000)} ms'),
                    Text('Sorted List: $sortedListBubble', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              if (timeSelectionSort != null)
                Column(
                  children: [
                    const Divider(),
                    Text(timeSelectionSort!.inMilliseconds == 0
                        ? 'Bubble Sort: ${timeSelectionSort!.inMicroseconds} µs'
                        : timeSelectionSort!.inSeconds == 0
                            ? 'Bubble Sort: ${timeSelectionSort!.inMilliseconds} ms'
                            : 'Bubble Sort: ${timeSelectionSort!.inSeconds} s, ${timeSelectionSort!.inMilliseconds.remainder(1000)} ms'),
                    Text('Sorted List: $sortedListSelection', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              if (timeInsertionSort != null)
                Column(
                  children: [
                    const Divider(),
                    Text(timeInsertionSort!.inMilliseconds == 0
                        ? 'Bubble Sort: ${timeInsertionSort!.inMicroseconds} µs'
                        : timeInsertionSort!.inSeconds == 0
                            ? 'Bubble Sort: ${timeInsertionSort!.inMilliseconds} ms'
                            : 'Bubble Sort: ${timeInsertionSort!.inSeconds} s, ${timeInsertionSort!.inMilliseconds.remainder(1000)} ms'),
                    Text('Sorted List: $sortedListInsertion', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              if (timeQuickSort != null)
                Column(
                  children: [
                    const Divider(),
                    Text(timeQuickSort!.inMilliseconds == 0
                        ? 'Bubble Sort: ${timeQuickSort!.inMicroseconds} µs'
                        : timeQuickSort!.inSeconds == 0
                            ? 'Bubble Sort: ${timeQuickSort!.inMilliseconds} ms'
                            : 'Bubble Sort: ${timeQuickSort!.inSeconds} s, ${timeQuickSort!.inMilliseconds.remainder(1000)} ms'),
                    Text('Sorted List: $sortedListQuick', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              if (timeMergeSort != null)
                Column(
                  children: [
                    const Divider(),
                    Text(timeMergeSort!.inMilliseconds == 0
                        ? 'Bubble Sort: ${timeMergeSort!.inMicroseconds} µs'
                        : timeMergeSort!.inSeconds == 0
                            ? 'Bubble Sort: ${timeMergeSort!.inMilliseconds} ms'
                            : 'Bubble Sort: ${timeMergeSort!.inSeconds} s, ${timeMergeSort!.inMilliseconds.remainder(1000)} ms'),
                    Text('Sorted List: $sortedListMerge', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
