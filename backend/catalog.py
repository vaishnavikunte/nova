"""Placeholder asset catalogue. Replace/extend when the Gemini-generated art list is ready.
Every name here must match a file name on the Flutter side (e.g. char_tiger_happy.webp)."""

BACKDROPS = {"bg_banyan_grove", "bg_village_square", "bg_river_bank", "bg_school_yard"}
CHARACTERS = {"char_chintu", "char_tiger", "char_meena"}
EXPRESSIONS = {"idle", "happy", "curious", "encouraging", "surprised"}
PROPS = {"prop_mango", "prop_banana", "prop_pot", "prop_coin", "prop_book",
         "prop_flower", "prop_ball", "prop_basket", "prop_stone", "prop_star"}
MOTIONS = {"walk_in_left", "walk_in_right", "slide_in", "pop_in_staggered", "fade_in",
           "idle_bounce", "jump", "head_tilt", "shake", "wave", "point_at"}
ACTOR_SLOTS = {"left", "center", "right"}
PROP_SLOTS = {"ground_left", "ground_center", "ground_right", "sky", "hand"}
SFX = {"sfx_cheer", "sfx_oops", "sfx_pop", "sfx_whoosh"}
TIMELINE_ACTIONS = {"narrate", "show_question", "point_at", "play", "set_expression"}
QUESTION_TYPES = {"voice_input", "match_following", "spot_item", "fill_blanks"}
LANGS = ("mr", "en")
MAX_ACTORS = 3
MAX_SCENES = 6
MAX_WORDS_PER_SCENE = {1: 25, 2: 30, 3: 40, 4: 50}   # per language, by grade
BANNED_WORDS_EN = {"kill", "die", "dead", "blood", "ghost", "monster", "gun", "fight", "hurt", "scary"}
