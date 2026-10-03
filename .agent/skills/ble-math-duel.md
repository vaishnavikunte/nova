# BLE Math Duel (Ganit Dangal)

- The "Ganit Dangal" multiplayer feature must use `flutter_blue_plus` (or Android Nearby Connections) for zero-internet peer-to-peer matchmaking.
- The host generates a 16-bit random seed and sends it to the client over BLE.
- Both devices use that exact seed to generate an identical sequence of rapid-fire math questions without cloud servers.
