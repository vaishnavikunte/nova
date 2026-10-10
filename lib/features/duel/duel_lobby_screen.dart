import 'package:rive/rive.dart' hide LinearGradient;
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../nova_main/widgets/child_character_widget.dart';
import 'duel_arena_screen.dart';

class DuelLobbyScreen extends StatefulWidget {
  const DuelLobbyScreen({super.key});

  @override
  State<DuelLobbyScreen> createState() => _DuelLobbyScreenState();
}

class _DuelLobbyScreenState extends State<DuelLobbyScreen> {
  bool _isHosting = false;
  bool _isScanning = true;
  List<ScanResult> _nearbyPlayers = [];
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _mockIncomingTimer;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() async {
    try {
      // In a real app, ensure Bluetooth is on and permissions are granted
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      _scanSub = FlutterBluePlus.scanResults.listen((results) {
        if (mounted) {
          setState(() {
            // Filter to devices with names to make the list cleaner
            _nearbyPlayers = results
                .where((r) => r.device.platformName.isNotEmpty)
                .toList();
          });
        }
      });
      // Handle timeout to stop scanning
      Future.delayed(const Duration(seconds: 15), () {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Scan error: $e');
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    _scanSub?.cancel();
    _mockIncomingTimer?.cancel();
    super.dispose();
  }

  void _hostDuel() {
    setState(() {
      _isHosting = true;
    });

    // Simulate broadcasting BLE name
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broadcasting as Host... Waiting for players!'),
        backgroundColor: Colors.green,
      ),
    );

    // Mock an incoming connection request after a few seconds for the demo
    _mockIncomingTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) _showIncomingConnectionDialog("Ramesh (Mock Device)");
    });
  }

  void _requestDuel(BluetoothDevice device) {
    // In a real scenario, we would connect to the device and send a request via GATT.
    // Here we simulate the connection process.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: RiveAnimation.asset(
                'assets/riv-assets/7143-13720-children-loading.riv',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Connecting to ${device.platformName}...\n(Requesting Duel)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    // Simulate host accepting and sending back a seed
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pop(context); // Close connecting dialog
      final int seed = Random().nextInt(65536);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DuelArenaScreen(seed: seed, isHost: false),
        ),
      );
    });
  }

  void _showIncomingConnectionDialog(String playerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '🔥 New Challenger!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: RiveAnimation.asset(
                'assets/riv-assets/8315-15931-cat-playing-animation.riv',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$playerName wants to play!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isHosting = false;
              });
            },
            child: const Text(
              'Reject (नाही)',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  final int seed = Random().nextInt(65536);
                  // In real code: send `seed` via GATT characteristic to the client.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DuelArenaScreen(seed: seed, isHost: true),
                    ),
                  );
                },
                child: const Text(
                  'Accept (होय)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 1.05, duration: 600.ms),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Ganit Dangal Lobby',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Massive Host Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHosting 
                    ? [Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), const Color(0xFF4054C8).withValues(alpha: 0.5)]
                    : [Theme.of(context).colorScheme.primary, const Color(0xFF4054C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: _isHosting ? null : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: _isHosting ? null : _hostDuel,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 40, color: Colors.white),
                    const SizedBox(width: 16),
                    Text(
                      _isHosting
                          ? 'Broadcasting...\n(खेळ तयार आहे)'
                          : '⚔️ Host a Duel\n(खेळ तयार करा)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate(target: _isHosting ? 1 : 0)
            .shimmer(duration: 2.seconds, color: Colors.white54),

            if (_isHosting)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child:
                    const Center(
                          child: Text(
                            'Waiting for challengers...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 800.ms),
              ),

            const SizedBox(height: 48),

            // Nearby Players Section
            Row(
              children: [
                const Icon(Icons.radar, size: 32, color: Colors.deepOrange),
                const SizedBox(width: 12),
                Text(
                  '🔍 Players Nearby (जवळचे मित्र)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 2, color: Colors.white24),
            const SizedBox(height: 16),

            Expanded(
              child: _nearbyPlayers.isEmpty
                  ? Center(
                      child: _isScanning 
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: RiveAnimation.asset(
                                  'assets/riv-assets/7143-13720-children-loading.riv',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                    'Searching for players...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.repeat(reverse: true))
                                  .fadeIn(),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_off_rounded, size: 64, color: Colors.white54),
                              const SizedBox(height: 16),
                              const Text(
                                'जवळचे खेळाडू सापडले नाहीत',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'मित्र उपलब्ध झाल्यावर येथे दिसतील.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                    )
                  : ListView.builder(
                      itemCount: _nearbyPlayers.length,
                      itemBuilder: (context, index) {
                        final result = _nearbyPlayers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors
                                      .primaries[index %
                                          Colors.primaries.length]
                                      .shade100,
                                  radius: 28,
                                  child: Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Colors
                                        .primaries[index %
                                            Colors.primaries.length]
                                        .shade700,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.device.platformName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Signal: ${result.rssi} dBm',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () =>
                                          _requestDuel(result.device),
                                      child: const Text(
                                        'DUEL!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (c) => c.repeat(reverse: true),
                                    )
                                    .scaleXY(
                                      begin: 1.0,
                                      end: 1.05,
                                      duration: 800.ms,
                                    ),
                              ],
                            ),
                          ),
                        ).animate().slideX(
                          begin: 1,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutQuad,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
