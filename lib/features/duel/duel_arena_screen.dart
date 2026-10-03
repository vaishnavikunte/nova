import 'dart:async';
import 'package:flutter/material.dart';
import 'package:majhe_gaon/features/duel/duel_services.dart';
import 'package:majhe_gaon/features/duel/duel_question_generator.dart';

class DuelArenaScreen extends StatefulWidget {
  final int seed;
  final bool isHost;

  const DuelArenaScreen({super.key, required this.seed, required this.isHost});

  @override
  State<DuelArenaScreen> createState() => _DuelArenaScreenState();
}

class _DuelArenaScreenState extends State<DuelArenaScreen> {
  late List<MathQuestion> _questions;
  int _currentIndex = 0;
  
  int _myScore = 0;
  int _opponentScore = 0;

  int _timeLeft = 60;
  Timer? _timer;

  // Assuming service is passed or provided via Riverpod in production
  final DuelClientService _clientService = DuelClientService();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 1. Generate exact identical questions using the shared 16-bit seed
    _questions = DuelQuestionGenerator.generateQuestions(widget.seed);
    
    // 2. Start 60-second rapid fire timer
    _startTimer();

    // 3. Listen to opponent score updates over BLE
    if (!widget.isHost) {
      _clientService.opponentScoreStream?.listen((value) {
        if (value.isNotEmpty && value[0] == 0x01) {
          setState(() {
            _opponentScore++;
          });
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _endDuel();
      }
    });
  }

  void _submitAnswer() {
    if (_timeLeft <= 0 || _currentIndex >= _questions.length) return;

    final currentQ = _questions[_currentIndex];
    final input = int.tryParse(_answerController.text.trim());

    if (input == currentQ.answer) {
      setState(() {
        _myScore++;
        _currentIndex++;
      });
      _answerController.clear();
      
      // Transmit single-byte payload (0x01) over BLE
      if (!widget.isHost) {
        _clientService.sendScoreUpdate(true);
      }
      
      if (_currentIndex >= _questions.length) {
        _timer?.cancel();
        _endDuel();
      }
    } else {
      _answerController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('चुकीचे उत्तर! (Wrong!)'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  void _endDuel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('सामना संपला! (Duel Ended)'),
        content: Text('Your Score: $_myScore\nOpponent Score: $_opponentScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length && _timeLeft > 0) {
      return const Scaffold(body: Center(child: Text("Waiting for opponent to finish...")));
    }

    final currentQ = _currentIndex < _questions.length ? _questions[_currentIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganit Dangal (Math Duel)'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Score: $_myScore', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _timeLeft <= 10 ? Colors.red.shade100 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Text('$_timeLeft', style: TextStyle(fontSize: 24, color: _timeLeft <= 10 ? Colors.red : Colors.black)),
                ),
                Text('Opponent: $_opponentScore', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const Spacer(),
            if (currentQ != null) ...[
              Text(
                currentQ.equation,
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '?',
                ),
                onSubmitted: (_) => _submitAnswer(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('SUBMIT', style: TextStyle(fontSize: 20)),
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
