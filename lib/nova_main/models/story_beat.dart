/// Background themes for story screens.
enum SceneType { observatory, market, factory, garden, cave, treasure, general }

/// Mascot mood states driving animations and facial expressions.
enum NovaMood {
  happy,
  excited,
  thinking,
  encouraging,
  sleepy,
  listening,
  speaking,
  celebrating,
}

/// Optional interactive touch activity embedded in a story beat.
enum InteractionType { none, tapToCount, dragToShare }

/// A narrative story beat delivered by NOVA.
class StoryBeat {
  final String id;
  final String narration;
  final SceneType sceneType;
  final NovaMood novaMood;
  final InteractionType interactionType;
  final int itemsToCount;
  final int itemsToShare;
  final int basketCount;

  const StoryBeat({
    required this.id,
    required this.narration,
    this.sceneType = SceneType.general,
    this.novaMood = NovaMood.happy,
    this.interactionType = InteractionType.none,
    this.itemsToCount = 8,
    this.itemsToShare = 8,
    this.basketCount = 2,
  });
}
