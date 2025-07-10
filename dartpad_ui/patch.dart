import 'dart:io';


void patchConstantsFile(String ipAddress) {
  final filePath = 'pkgs/dartpad_shared/lib/constants.dart';
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Error: File $filePath not found. Skipping constants.dart patch.');
    return;
  }

  var lines = file.readAsLinesSync();
  bool modified = false;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('const localhostIp =')) {
      lines[i] = "const localhostIp = '$ipAddress';";
      modified = true;
      break;
    }
  }

  if (modified) {
    file.writeAsStringSync(lines.join('\n'));
    print('Successfully updated localhostIp to "$ipAddress" in $filePath');
  } else {
    print('Warning: "const localhostIp" not found in $filePath. Constants file not modified.');
  }
}


void patchModelFile() {
  final filePath = 'pkgs/dartpad_shared/lib/model.dart';
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Error: File $filePath not found. Skipping model.dart patch.');
    return;
  }

  var lines = file.readAsLinesSync();
  bool modified = false;
  int startPatchIndex = -1;
  int endPatchIndex = -1;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('static List<Channel> get valuesWithoutLocalhost {')) {
      startPatchIndex = i;
      int braceCount = 0;
      for (int j = i; j < lines.length; j++) {
        
        for (final char in lines[j].trim().split('')) {
          if (char == '{') braceCount++;
          if (char == '}') braceCount--;
        }
        if (braceCount == 0 && j > i) { 
          endPatchIndex = j;
          break;
        }
      }
      if (endPatchIndex != -1) {
        final indentationLevel = lines[startPatchIndex].indexOf('static'); 
        final returnIndentation = ' ' * (indentationLevel + 4); 
        final newBlockLines = [
          lines[startPatchIndex], 
          '${returnIndentation}return values.toList();', 
          lines[endPatchIndex] 
        ];
        lines.replaceRange(startPatchIndex, endPatchIndex + 1, newBlockLines);
        modified = true;
        break; 
      }
    }
  }

  if (modified) {
    file.writeAsStringSync(lines.join('\n').replaceAll("localhostIp:8080/","localhostIp/"));
    print('Successfully updated valuesWithoutLocalhost in $filePath to include localhost.');
  } else {
    print('Warning: "valuesWithoutLocalhost" getter not found or could not be patched in $filePath.');
  }
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart patch_dartpad_shared_files.dart <ip_address>');
    exit(1);
  }
  final ipAddress = arguments[0];
  patchConstantsFile(ipAddress);
  patchModelFile();

  print('All DartPad shared library patches applied.');
}