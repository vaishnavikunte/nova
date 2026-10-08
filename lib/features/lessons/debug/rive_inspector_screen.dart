import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RiveInspectorScreen(),
    );
  }
}

class RiveInspectorScreen extends StatefulWidget {
  const RiveInspectorScreen({super.key});

  @override
  State<RiveInspectorScreen> createState() => _RiveInspectorScreenState();
}

class _RiveInspectorScreenState extends State<RiveInspectorScreen> {
  @override
  void initState() {
    super.initState();
    _inspectFiles();
  }

  Future<void> _inspectFiles() async {
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
    print('INSPECTION_COMPLETE');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Inspecting Rive Files...")),
    );
  }
}
