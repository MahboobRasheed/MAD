// Save as task3_pyramid.dart
import 'dart:io';

void main() {
  stdout.write('Enter an integer n: ');
  String? input = stdin.readLineSync();
  int? n = int.tryParse(input ?? '');
  if (n == null || n <= 0) {
    print('Please enter a positive integer.');
    return;
  }

  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= i; j++) {
      stdout.write(j);
      if (j < i) stdout.write(' ');
    }
    stdout.writeln();
  }
}
