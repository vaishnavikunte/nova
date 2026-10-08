import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  test('Rive Inspector', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    final files = [
      'assets/riv-assets/nova.riv',
      'assets/riv-assets/kid.riv',
    ];

    for (final path in files) {
      final fileData = File(path).readAsBytesSync();
      final riveFile = RiveFile.import(ByteData.view(fileData.buffer));
      
      print('File: $path');
      print('Artboards:');
      for (final artboard in riveFile.artboards) {
        print(' └ Artboard "${artboard.name}"');
        
        print('    State machines:');
        for (final sm in artboard.stateMachines) {
          print('      └ "${sm.name}" inputs:');
          for (final input in sm.inputs) {
            String typeStr = input.runtimeType.toString();
            print('          - ${input.name} : $typeStr');
          }
        }
        
        print('    Animations:');
        for (final anim in artboard.animations) {
          print('      └ "${anim.name}"');
        }
      }
      print('---');
    }
  });
}
