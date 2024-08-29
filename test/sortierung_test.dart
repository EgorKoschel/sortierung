import 'package:flutter_test/flutter_test.dart';

import 'package:sortierung/sortierung.dart';

void main() {
  test('Test generateRandomList', () {
    final List<int> list = Sortierung.generateRandomList(100, maxValue: 1000);
    expect(list.length, 100);
    for (int i = 0; i < list.length; i++) {
      expect(list[i] >= 0 && list[i] <= 1000, true);
    }
  });

  test('Test bubbleSort', () {
    final List<int> list = [23, 16, 4, 8, 15, 42];
    final List<int> sortedList = Sortierung.bubbleSort(list);
    expect(sortedList, [4, 8, 15, 16, 23, 42]);
  });

  test('Test selectionSort', () {
    final List<int> list = [23, 16, 4, 8, 15, 42];
    final List<int> sortedList = Sortierung.selectionSort(list);
    expect(sortedList, [4, 8, 15, 16, 23, 42]);
  });

  test('Test insertionSort', () {
    final List<int> list = [23, 16, 4, 8, 15, 42];
    final List<int> sortedList = Sortierung.insertionSort(list);
    expect(sortedList, [4, 8, 15, 16, 23, 42]);
  });

  test('Test quickSort', () {
    final List<int> list = [23, 16, 4, 8, 15, 42];
    final List<int> sortedList = Sortierung.quickSort(list);
    expect(sortedList, [4, 8, 15, 16, 23, 42]);
  });

  test('Test mergeSort', () {
    final List<int> list = [23, 16, 4, 8, 15, 42];
    final List<int> sortedList = Sortierung.mergeSort(list);
    expect(sortedList, [4, 8, 15, 16, 23, 42]);
  });
}
