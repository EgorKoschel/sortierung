import 'dart:math';

abstract class Sortierung {
  static List<int> generateRandomList(int length, {int maxValue = 100}) {
    List<int> list = [];
    for (int i = 0; i < length; i++) {
      final int randomNumber = Random().nextInt(maxValue);
      list.add(randomNumber);
    }
    return list;
  }

  static List<int> bubbleSort(List<int> list) {
    List<int> sortedList = List<int>.from(list);
    int n = sortedList.length;
    bool swapped;

    for (int i = 0; i < n - 1; i++) {
      swapped = false;

      for (int j = 0; j < n - i - 1; j++) {
        if (sortedList[j] > sortedList[j + 1]) {
          int temp = sortedList[j];
          sortedList[j] = sortedList[j + 1];
          sortedList[j + 1] = temp;
          swapped = true;
        }
      }
      if (!swapped) {
        break;
      }
    }

    return sortedList;
  }

  static List<int> selectionSort(List<int> list) {
    List<int> sortedList = List<int>.from(list);
    int n = sortedList.length;
    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if (sortedList[j] < sortedList[minIndex]) {
          minIndex = j;
        }
      }
      int temp = sortedList[minIndex];
      sortedList[minIndex] = sortedList[i];
      sortedList[i] = temp;
    }
    return sortedList;
  }

  static List<int> insertionSort(List<int> list) {
    List<int> sortedList = List<int>.from(list);
    int n = sortedList.length;
    for (int i = 1; i < n; i++) {
      int key = sortedList[i];
      int j = i - 1;
      while (j >= 0 && sortedList[j] > key) {
        sortedList[j + 1] = sortedList[j];
        j = j - 1;
      }
      sortedList[j + 1] = key;
    }
    return sortedList;
  }

  static List<int> quickSort(List<int> list) {
    if (list.length <= 1) {
      return list;
    }

    int pivotIndex = list.length ~/ 2;
    int pivot = list[pivotIndex];

    List<int> smaller = [];
    List<int> equal = [];
    List<int> greater = [];

    for (int num in list) {
      if (num < pivot) {
        smaller.add(num);
      } else if (num == pivot) {
        equal.add(num);
      } else {
        greater.add(num);
      }
    }

    return [...quickSort(smaller), ...equal, ...quickSort(greater)];
  }

  static List<int> mergeSort(List<int> list) {
    if (list.length <= 1) {
      return list;
    }

    int mid = list.length ~/ 2;
    List<int> left = list.sublist(0, mid);
    List<int> right = list.sublist(mid);

    return _merge(mergeSort(left), mergeSort(right));
  }

  static List<int> _merge(List<int> left, List<int> right) {
    List<int> mergedList = [];
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      if (left[i] < right[j]) {
        mergedList.add(left[i]);
        i++;
      } else {
        mergedList.add(right[j]);
        j++;
      }
    }

    while (i < left.length) {
      mergedList.add(left[i]);
      i++;
    }

    while (j < right.length) {
      mergedList.add(right[j]);
      j++;
    }

    return mergedList;
  }
}
