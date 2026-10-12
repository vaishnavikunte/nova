import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

enum NovaState { idle, talking, listening, happy }

class NovaCharacter extends StatefulWidget {
  final NovaState state;
  final double size;

  const NovaCharacter({
    super.key,
    this.state = NovaState.idle,
    this.size = 200,
  });

  @override
  State<NovaCharacter> createState() => _NovaCharacterState();
}

class _NovaCharacterState extends State<NovaCharacter> {
  Artboard? _riveArtboard;
  RiveAnimationController? _currentController;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  void didUpdateWidget(covariant NovaCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _applyState();
    }
  }

  void _loadRiveFile() {
    rootBundle.load('assets/riv-assets/nova.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.artboardByName('SOBO-Motion-V02') ?? file.mainArtboard;
        setState(() => _riveArtboard = artboard);
        _applyState();
      },
    );
  }

  void _applyState() {
    if (_riveArtboard == null) return;
    
    // Remove current controller
    if (_currentController != null) {
      _riveArtboard!.removeController(_currentController!);
    }

    String animName = 'Idle';
    switch (widget.state) {
      case NovaState.idle:
        animName = 'Idle';
        break;
      case NovaState.talking:
        animName = 'Talk';
        break;
      case NovaState.listening:
        animName = 'Listen';
        break;
      case NovaState.happy:
        animName = 'Yes'; // or Hello/Sparkles
        break;
    }

    _currentController = SimpleAnimation(animName);
    _riveArtboard!.addController(_currentController!);
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
