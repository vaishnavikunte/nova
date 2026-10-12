import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

enum ChintuState { idle, walking, running }

class ChintuCharacter extends StatefulWidget {
  final ChintuState state;
  final double size;

  const ChintuCharacter({
    super.key,
    this.state = ChintuState.idle,
    this.size = 200,
  });

  @override
  State<ChintuCharacter> createState() => _ChintuCharacterState();
}

class _ChintuCharacterState extends State<ChintuCharacter> {
  Artboard? _riveArtboard;
  StateMachineController? _smController;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  void didUpdateWidget(covariant ChintuCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _applyState();
    }
  }

  void _loadRiveFile() {
    rootBundle.load('assets/riv-assets/kid.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.artboardByName('Accung') ?? file.mainArtboard;
        
        final controller = StateMachineController.fromArtboard(artboard, 'Alternatif');
        if (controller != null) {
          artboard.addController(controller);
          _smController = controller;
        }

        setState(() => _riveArtboard = artboard);
        _applyState();
      },
    );
  }

  void _applyState() {
    if (_smController == null) return;

    SMITrigger? trigger;
    switch (widget.state) {
      case ChintuState.idle:
        trigger = _smController!.findSMI('IdlePress') as SMITrigger?;
        trigger ??= _smController!.findSMI('IsIdle') as SMITrigger?;
        break;
      case ChintuState.walking:
        trigger = _smController!.findSMI('WalkPress') as SMITrigger?;
        trigger ??= _smController!.findSMI('IsWalking') as SMITrigger?;
        break;
      case ChintuState.running:
        trigger = _smController!.findSMI('RunPress') as SMITrigger?;
        trigger ??= _smController!.findSMI('IsRunning') as SMITrigger?;
        break;
    }
    
    trigger?.fire();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _riveArtboard == null
          ? const Center(child: CircularProgressIndicator())
          : Rive(artboard: _riveArtboard!),
    );
  }
}
