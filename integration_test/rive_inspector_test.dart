import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rive/rive.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Rive Inspector', (WidgetTester tester) async {
    await RiveFile.initialize();
    
    final files = [
      'assets/riv-assets/nova.riv',
      'assets/riv-assets/kid.riv',
    ];

    for (final path in files) {
      final fileData = await rootBundle.load(path);
      final riveFile = RiveFile.import(fileData);
      
      print('=== RIVE MANIFEST FOR $path ===');
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
      print('=================================');
    }
  });
}
