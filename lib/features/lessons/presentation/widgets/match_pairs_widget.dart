import 'package:flutter/material.dart';
import '../../domain/models/lesson_models.dart';
import '../../../../nova_main/theme/app_colors.dart';

class MatchPairsWidget extends StatefulWidget {
  final LessonQuestion question;
  final Set<String> completedPairIds;
  final void Function(String leftId, String rightId) onPairMatchAttempt;
  final VoidCallback? onContinue;
  final bool isAllCompleted;

  const MatchPairsWidget({
    super.key,
    required this.question,
    required this.completedPairIds,
    required this.onPairMatchAttempt,
    this.onContinue,
    this.isAllCompleted = false,
  });

  @override
  State<MatchPairsWidget> createState() => _MatchPairsWidgetState();
}

class _MatchPairsWidgetState extends State<MatchPairsWidget> {
  String? _selectedLeftId;
  String? _selectedRightId;
  String? _mismatchLeftId;
  String? _mismatchRightId;

  // Stable shuffled list of right-side items
  late List<MatchingPair> _shuffledRightPairs;

  @override
  void initState() {
    super.initState();
    _initShuffledPairs();
  }

  @override
  void didUpdateWidget(covariant MatchPairsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _initShuffledPairs();
      _selectedLeftId = null;
      _selectedRightId = null;
    }
  }

  void _initShuffledPairs() {
    // Reverse or alternate order for educational matching challenge
    _shuffledRightPairs = List<MatchingPair>.from(widget.question.matchingPairs);
    if (_shuffledRightPairs.length >= 3) {
      // e.g. [Pair 2, Pair 0, Pair 1]
      final p0 = _shuffledRightPairs[0];
      final p1 = _shuffledRightPairs[1];
      final p2 = _shuffledRightPairs[2];
      _shuffledRightPairs = [p1, p2, p0];
    }
  }

  void _onSelectLeft(String pairId) {
    if (widget.completedPairIds.contains(pairId)) return;

    setState(() {
      _mismatchLeftId = null;
      _mismatchRightId = null;
      if (_selectedLeftId == pairId) {
        _selectedLeftId = null;
      } else {
        _selectedLeftId = pairId;
      }
    });

    _checkMatchIfBothSelected();
  }

  void _onSelectRight(String pairId) {
    if (widget.completedPairIds.contains(pairId)) return;

    setState(() {
      _mismatchLeftId = null;
      _mismatchRightId = null;
      if (_selectedRightId == pairId) {
        _selectedRightId = null;
      } else {
        _selectedRightId = pairId;
      }
    });

    _checkMatchIfBothSelected();
  }

  void _checkMatchIfBothSelected() {
    if (_selectedLeftId != null && _selectedRightId != null) {
      final left = _selectedLeftId!;
      final right = _selectedRightId!;

      if (left == right) {
        widget.onPairMatchAttempt(left, right);
        setState(() {
          _selectedLeftId = null;
          _selectedRightId = null;
        });
      } else {
        // Mismatch
        setState(() {
          _mismatchLeftId = left;
          _mismatchRightId = right;
        });
        widget.onPairMatchAttempt(left, right);

        // Clear selection after brief shake/delay
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              if (_selectedLeftId == left) _selectedLeftId = null;
              if (_selectedRightId == right) _selectedRightId = null;
              _mismatchLeftId = null;
              _mismatchRightId = null;
            });
          }
        });
      }
    }
  }

  Widget _buildVisualIcon(String visualKey) {
    IconData icon;
    Color color;

    switch (visualKey) {
      case 'sun':
        icon = Icons.wb_sunny_rounded;
        color = const Color(0xFFF59E0B);
        break;
      case 'bird_roof':
        icon = Icons.roofing_rounded;
        color = const Color(0xFF3B82F6);
        break;
      case 'calf_ground':
        icon = Icons.grass_rounded;
        color = const Color(0xFF10B981);
        break;
      default:
        icon = Icons.auto_awesome;
        color = AppColors.purple;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pairs = widget.question.matchingPairs;
    final total = pairs.length;
    final matched = widget.completedPairIds.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress badge e.g. "2 of 3 pairs matched"
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isAllCompleted
                ? const Color(0xFFD1FAE5)
                : const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isAllCompleted
                  ? const Color(0xFF10B981)
                  : AppColors.purple,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isAllCompleted
                    ? Icons.check_circle_rounded
                    : Icons.join_inner_rounded,
                size: 20,
                color: widget.isAllCompleted
                    ? const Color(0xFF047857)
                    : AppColors.purple,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isAllCompleted
                    ? 'सर्व जोड्या पूर्ण! (All pairs completed!)'
                    : 'जोड्या: $matched / $total पूर्ण ($matched of $total matched)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: widget.isAllCompleted
                      ? const Color(0xFF047857)
                      : AppColors.navy,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Two Column matching cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Pictures
              Expanded(
                child: Column(
                  children: pairs.map((pair) {
                    final isDone = widget.completedPairIds.contains(pair.id);
                    final isSelected = _selectedLeftId == pair.id;
                    final isMismatch = _mismatchLeftId == pair.id;

                    return _buildLeftCard(pair, isDone, isSelected, isMismatch);
                  }).toList(),
                ),
              ),

              const SizedBox(width: 12),

              // Right Column: Words / Concepts
              Expanded(
                child: Column(
                  children: _shuffledRightPairs.map((pair) {
                    final isDone = widget.completedPairIds.contains(pair.id);
                    final isSelected = _selectedRightId == pair.id;
                    final isMismatch = _mismatchRightId == pair.id;

                    return _buildRightCard(pair, isDone, isSelected, isMismatch);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        if (widget.isAllCompleted && widget.onContinue != null) ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
            onPressed: widget.onContinue,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text(
              'पुढे चला (Continue)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLeftCard(
    MatchingPair pair,
    bool isDone,
    bool isSelected,
    bool isMismatch,
  ) {
    Color borderColor;
    Color bgColor;

    if (isDone) {
      borderColor = const Color(0xFF10B981);
      bgColor = const Color(0xFFECFDF5);
    } else if (isMismatch) {
      borderColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEF2F2);
    } else if (isSelected) {
      borderColor = AppColors.purple;
      bgColor = const Color(0xFFF3E8FF);
    } else {
      borderColor = const Color(0xFFE2E8F0);
      bgColor = Colors.white;
    }

    final cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected || isDone ? 2.5 : 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.04),
            blurRadius: isSelected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildVisualIcon(pair.leftVisualKey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pair.leftLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDone ? const Color(0xFF047857) : AppColors.navy,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (pair.leftSublabel != null)
                  Text(
                    pair.leftSublabel!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDone ? const Color(0xFF059669) : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
        ],
      ),
    );

    if (isDone) {
      return cardContent;
    }

    // Draggable card with Tap fallback
    return Draggable<String>(
      data: pair.id,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 160,
          child: Opacity(opacity: 0.9, child: cardContent),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: cardContent),
      child: GestureDetector(
        onTap: () => _onSelectLeft(pair.id),
        child: cardContent,
      ),
    );
  }

  Widget _buildRightCard(
    MatchingPair pair,
    bool isDone,
    bool isSelected,
    bool isMismatch,
  ) {
    Color borderColor;
    Color bgColor;

    if (isDone) {
      borderColor = const Color(0xFF10B981);
      bgColor = const Color(0xFFECFDF5);
    } else if (isMismatch) {
      borderColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEF2F2);
    } else if (isSelected) {
      borderColor = AppColors.purple;
      bgColor = const Color(0xFFF3E8FF);
    } else if (_selectedLeftId != null) {
      // Target highlight when left is selected
      borderColor = AppColors.purple.withValues(alpha: 0.5);
      bgColor = const Color(0xFFFAF5FF);
    } else {
      borderColor = const Color(0xFFE2E8F0);
      bgColor = Colors.white;
    }

    final cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected || isDone ? 2.5 : 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.04),
            blurRadius: isSelected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pair.rightLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDone ? const Color(0xFF047857) : AppColors.navy,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (pair.rightSublabel != null)
                  Text(
                    pair.rightSublabel!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDone ? const Color(0xFF059669) : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
        ],
      ),
    );

    if (isDone) {
      return cardContent;
    }

    // DragTarget accepting left pair dropped on it + Tap fallback
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => !isDone,
      onAcceptWithDetails: (details) {
        final draggedLeftId = details.data;
        widget.onPairMatchAttempt(draggedLeftId, pair.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: () => _onSelectRight(pair.id),
          child: Container(
            decoration: isHovered
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: cardContent,
          ),
        );
      },
    );
  }
}
