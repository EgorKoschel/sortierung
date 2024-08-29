import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortierung/sortierung.dart';
import 'dart:core';
import 'dart:isolate';

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
  bool isSorting = false;

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
                        maxLength: 7,
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
                  maxLines: 5,
                  list.isEmpty ? 'Bitte geben Sie die Länge und den maximalen Wert des Arrays ein.' : list.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
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
                      onPressed: isSorting
                          ? null
                          : () async {
                              setState(() {
                                isSorting = true;
                              });

                              final repeat = int.tryParse(controllerRepeat.text) ?? 1;
                              final result = await _sortList(list, repeat);

                              setState(() {
                                sortedListBubble = result['bubbleSort']!;
                                timeBubbleSort = result['bubbleSortTime']!;
                                sortedListSelection = result['selectionSort']!;
                                timeSelectionSort = result['selectionSortTime']!;
                                sortedListInsertion = result['insertionSort']!;
                                timeInsertionSort = result['insertionSortTime']!;
                                sortedListQuick = result['quickSort']!;
                                timeQuickSort = result['quickSortTime']!;
                                sortedListMerge = result['mergeSort']!;
                                timeMergeSort = result['mergeSortTime']!;
                                isSorting = false;
                              });
                            },
                      child: const Text('Sort'),
                    ),
                    if (isSorting)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (timeBubbleSort != null) _buildResultDisplay('Bubble Sort', timeBubbleSort!, sortedListBubble),
              if (timeSelectionSort != null)
                _buildResultDisplay('Selection Sort', timeSelectionSort!, sortedListSelection),
              if (timeInsertionSort != null)
                _buildResultDisplay('Insertion Sort', timeInsertionSort!, sortedListInsertion),
              if (timeQuickSort != null) _buildResultDisplay('Quick Sort', timeQuickSort!, sortedListQuick),
              if (timeMergeSort != null) _buildResultDisplay('Merge Sort', timeMergeSort!, sortedListMerge),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _sortList(List<int> list, int repeat) async {
    return await Isolate.run(() {
      final Map<String, dynamic> result = {};
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < repeat; i++) {
        result['bubbleSort'] = Sortierung.bubbleSort(list);
      }
      result['bubbleSortTime'] = stopwatch.elapsed;
      stopwatch.reset();
      stopwatch.start();

      for (int i = 0; i < repeat; i++) {
        result['selectionSort'] = Sortierung.selectionSort(list);
      }
      result['selectionSortTime'] = stopwatch.elapsed;
      stopwatch.reset();
      stopwatch.start();

      for (int i = 0; i < repeat; i++) {
        result['insertionSort'] = Sortierung.insertionSort(list);
      }
      result['insertionSortTime'] = stopwatch.elapsed;
      stopwatch.reset();
      stopwatch.start();

      for (int i = 0; i < repeat; i++) {
        result['quickSort'] = Sortierung.quickSort(list);
      }
      result['quickSortTime'] = stopwatch.elapsed;
      stopwatch.reset();
      stopwatch.start();

      for (int i = 0; i < repeat; i++) {
        result['mergeSort'] = Sortierung.mergeSort(list);
      }
      result['mergeSortTime'] = stopwatch.elapsed;

      return result;
    });
  }

  Widget _buildResultDisplay(String sortName, Duration time, List<int> sortedList) {
    return Column(
      children: [
        const Divider(),
        Text(time.inMilliseconds == 0
            ? '$sortName: ${time.inMicroseconds} µs'
            : time.inSeconds == 0
                ? '$sortName: ${time.inMilliseconds} ms'
                : '$sortName: ${time.inSeconds} s, ${time.inMilliseconds.remainder(1000)} ms'),
        Text('Sorted List: $sortedList', maxLines: 2, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
