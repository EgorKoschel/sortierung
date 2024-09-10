import 'dart:core';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortierung/classes/sort_option.dart';
import 'package:sortierung/classes/sort_result.dart';
import 'package:sortierung/classes/sortierung.dart';
import 'package:sortierung/widgets/expandable_text.dart';

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
  List<SortResult> sortResults = [
    SortResult(sortName: 'Bubble Sort'),
    SortResult(sortName: 'Selection Sort'),
    SortResult(sortName: 'Insertion Sort'),
    SortResult(sortName: 'Quick Sort'),
    SortResult(sortName: 'Merge Sort'),
  ];
  final controllerLength = TextEditingController(text: '10');
  final controllerMaxValue = TextEditingController(text: '100');
  final controllerRepeat = TextEditingController(text: '1');
  bool isSorting = false;
  Isolate? sortIsolate;
  List<SortOption> sortOptions = [
    SortOption(
      sortName: 'Bubble Sort',
      sortKey: 'bubbleSort',
      sortFunction: Sortierung.bubbleSort,
    ),
    SortOption(
      sortName: 'Selection Sort',
      sortKey: 'selectionSort',
      sortFunction: Sortierung.selectionSort,
    ),
    SortOption(
      sortName: 'Insertion Sort',
      sortKey: 'insertionSort',
      sortFunction: Sortierung.insertionSort,
    ),
    SortOption(
      sortName: 'Quick Sort',
      sortKey: 'quickSort',
      sortFunction: Sortierung.quickSort,
    ),
    SortOption(
      sortName: 'Merge Sort',
      sortKey: 'mergeSort',
      sortFunction: Sortierung.mergeSort,
    ),
  ];

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
                        maxLength: 5,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: controllerLength,
                        decoration: const InputDecoration(
                          labelText: 'Length',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandableText(
                  maxLines: 5,
                  text: list.isEmpty
                      ? 'Bitte geben Sie die Länge und den maximalen Wert des Arrays ein.'
                      : list.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    final int length = int.tryParse(controllerLength.text) ?? 0;
                    final int maxValue = (int.tryParse(controllerMaxValue.text) ?? 0) + 1;
                    setState(() {
                      list = Sortierung.generateRandomList(length, maxValue: maxValue);
                      _resetSortResults();
                    });
                  },
                  child: const Text('Generate Random Array'),
                ),
              ),
              Visibility(
                visible: list.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                            maxLength: 4,
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
                      Visibility(
                        visible: !isSorting,
                        child: ElevatedButton(
                          onPressed: isSorting || sortOptions.every((option) => !option.isChecked)
                              ? null
                              : () async {
                                  setState(() {
                                    isSorting = true;
                                    _resetSortResults();
                                  });
                                  final repeat = int.tryParse(controllerRepeat.text) ?? 1;
                                  await _startSort(list, repeat, sortOptions);
                                },
                          child: const Text('Sort'),
                        ),
                      ),
                      Visibility(
                        visible: isSorting,
                        child: ElevatedButton(
                          onPressed: () {
                            _cancelSort();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildSortCheckboxes(),
              Visibility(
                visible: isSorting,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
              ),
              for (final result in sortResults)
                if (result.duration != null) _buildResultDisplay(result)
            ],
          ),
        ),
      ),
    );
  }

  Visibility _buildSortCheckboxes() {
    return Visibility(
      visible: list.isNotEmpty,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sorts:', style: TextStyle(fontSize: 16)),
          for (final option in sortOptions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Checkbox(
                    value: option.isChecked,
                    onChanged: isSorting
                        ? null
                        : (value) {
                            setState(() {
                              option.isChecked = value!;
                            });
                          },
                  ),
                  Text(option.sortName),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _startSort(List<int> list, int repeat, List<SortOption> sortOptions) async {
    ReceivePort receivePort = ReceivePort();
    sortIsolate = await Isolate.spawn(_sortListInIsolate, [receivePort.sendPort, list, repeat, sortOptions]);

    receivePort.listen((data) {
      if (data is Map<String, dynamic>) {
        final List<Duration?> sortedDurations = [
          data['bubbleSortTime'],
          data['selectionSortTime'],
          data['insertionSortTime'],
          data['quickSortTime'],
          data['mergeSortTime'],
        ]..sort((a, b) => a == null
            ? 1
            : b == null
                ? -1
                : b.compareTo(a));
        final int maxRank = sortedDurations.where((element) => element != null).length;
        _updateSortResults(data, sortedDurations, maxRank);
        setState(() {
          isSorting = false;
        });
      }
    });
  }

  void _updateSortResults(Map<String, dynamic> data, List<Duration?> sortedDurations, int maxRank) {
    for (int i = 0; i < sortResults.length; i++) {
      sortResults[i]
        ..sortedList = data[sortOptions[i].sortKey]
        ..duration = data['${sortOptions[i].sortKey}Time']
        ..rank = sortedDurations.indexOf(data['${sortOptions[i].sortKey}Time'])
        ..maxRank = maxRank;
    }
  }

  void _resetSortResults() {
    for (var result in sortResults) {
      result.duration = null;
      result.sortedList = null;
      result.rank = null;
      result.maxRank = null;
    }
  }

  void _cancelSort() {
    if (sortIsolate != null) {
      sortIsolate!.kill(priority: Isolate.immediate);
      setState(() {
        isSorting = false;
        sortIsolate = null;
      });
    }
  }

  static void _sortListInIsolate(List<dynamic> isolateArguments) {
    final SendPort sendPort = isolateArguments[0];
    final List<int> list = List<int>.from(isolateArguments[1]);
    final int repeat = isolateArguments[2];
    final List<SortOption> sortOptions = List<SortOption>.from(isolateArguments[3]);
    final Map<String, dynamic> result = {};
    final stopwatch = Stopwatch();

    for (var option in sortOptions) {
      if (option.isChecked) {
        stopwatch.start();
        for (int i = 0; i < repeat; i++) {
          result[option.sortKey] = option.sortFunction(List<int>.from(list));
        }
        result['${option.sortKey}Time'] = stopwatch.elapsed;
        stopwatch.reset();
      }
    }
    sendPort.send(result);
  }

  Widget _buildResultDisplay(SortResult sortResult) {
    return Column(
      children: [
        const Divider(),
        if (sortResult.duration != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sortResult.duration!.inMilliseconds == 0
                  ? '${sortResult.sortName}: ${sortResult.duration!.inMicroseconds} µs'
                  : sortResult.duration!.inSeconds == 0
                      ? '${sortResult.sortName}: ${sortResult.duration!.inMilliseconds} ms'
                      : '${sortResult.sortName}: ${sortResult.duration!.inSeconds} s, ${sortResult.duration!.inMilliseconds.remainder(1000)} ms'),
              if (sortResult.rank != null && sortResult.maxRank! > 1)
                for (int i = 0; i < sortResult.rank! + 1; i++) const Icon(Icons.star, color: Colors.amber),
              if (sortResult.rank != null)
                for (int i = sortResult.rank! + 1; i < sortResult.maxRank!; i++)
                  const Icon(Icons.star_border, color: Colors.grey),
            ],
          ),
        if (sortResult.sortedList != null)
          ExpandableText(
            text: 'Sorted List: ${sortResult.sortedList}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
