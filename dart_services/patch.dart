import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart modify_packages.dart <comma-separated-packages>');
    exit(1);
  }
  final newPackagesString = arguments[0];
  final packagesToAdd = newPackagesString
      .split(',')
      .map((p) => p.trim()) 
      .where((p) => p.isNotEmpty)
      .toSet(); 

  if (packagesToAdd.isEmpty) {
    print('No valid packages provided to add. Exiting.');
    exit(0);
  }
  final filePath = 'pkgs/dart_services/lib/src/project_templates.dart';
  final file = File(filePath);
  if (!file.existsSync()) {
    print('Error: File $filePath not found. Make sure you are in the correct directory context.');
    exit(1);
  }
  var lines = file.readAsLinesSync();
  int startBlockIndex = -1;
  int endBlockIndex = -1;
  final existingPackages = <String>{};
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('const Set<String> supportedFlutterPackages = {')) {
      startBlockIndex = i;
    } else if (startBlockIndex != -1 && lines[i].trim() == '};') {
      endBlockIndex = i;
      break;
    } else if (startBlockIndex != -1) {
      final match = RegExp(r"^\s*'([^']+)'\s*,").firstMatch(lines[i]);
      if (match != null && match.group(1) != null) {
        existingPackages.add(match.group(1)!.trim());
      }
    }
  }
  if (startBlockIndex == -1 || endBlockIndex == -1) {
    print('Error: Could not find the supportedFlutterPackages block in $filePath.');
    exit(1);
  }
  final allUniquePackages = existingPackages.union(packagesToAdd);
  final sortedPackages = allUniquePackages.toList()..sort();
  final indentation = ' ' * 4; 
  final newPackageLines = sortedPackages.map((pkg) => '$indentation\'$pkg\',').toList();
  final modifiedBlock = [
    lines[startBlockIndex], 
    ...newPackageLines,     
    lines[endBlockIndex]    
  ];
  lines.replaceRange(startBlockIndex, endBlockIndex + 1, modifiedBlock);
  file.writeAsStringSync(lines.join('\n'));
  print('Successfully updated supportedFlutterPackages in $filePath.');
  print('Total unique packages after update: ${sortedPackages.length}');
}