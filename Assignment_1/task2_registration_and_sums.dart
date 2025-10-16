import 'dart:io';
import 'dart:convert';
import 'dart:math';

void main() {
  stdout.write('Enter your name: ');
  String? name = stdin.readLineSync();
  if (name == null || name.trim().isEmpty) {
    print('Name cannot be empty. Exiting.');
    return;
  }
  stdout.write('Enter your age: ');
  String? ageInput = stdin.readLineSync();
  int? age = int.tryParse(ageInput ?? '');
  if (age == null) {
    print('Invalid age input. Exiting.');
    return;
  }
  if (age < 18) {
    print('Sorry ${name.trim()}, you are not eligible to register.');
    return;
  }

  stdout.write('How many numbers do you want to enter? ');
  String? nInput = stdin.readLineSync();
  int n = int.tryParse(nInput ?? '') ?? 0;
  if (n <= 0) {
    print('No numbers to process. Exiting.');
    return;
  }

  List<int> numbers = [];
  for (int i = 0; i < n; i++) {
    stdout.write('Enter number ${i + 1}: ');
    String? numInput = stdin.readLineSync();
    int value = int.tryParse(numInput ?? '') ?? 0;
    numbers.add(value);
  }

  int sumEven = 0;
  int sumOdd = 0;
  int largest = numbers.first;
  int smallest = numbers.first;

  for (var v in numbers) {
    if (v % 2 == 0) sumEven += v;
    else sumOdd += v;
    if (v > largest) largest = v;
    if (v < smallest) smallest = v;
  }

  print("\n-------- Results -----------");
  print("Numbers entered: ${numbers.join(", ")}");
  print("Sum of even numbers: $sumEven");
  print("Sum of odd numbers: $sumOdd");
  print("Largest number: $largest");
  print("Smallest number: $smallest");
}
