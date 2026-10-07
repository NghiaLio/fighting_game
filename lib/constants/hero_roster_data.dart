import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// 12 playable champions organized into 2 rows:
/// Row 1: Mages & Knights
/// Row 2: Samurais & Skeletons
const List<HeroInfo> kHeroRoster = [
  // --- ROW 1: MAGES & KNIGHTS ---
  HeroInfo(
    type: CharacterType.fireWizard,
    name: 'FIRE WIZARD',
    title: 'Fire Dragon Lord (Ignis)',
    role: 'Mage - Firepower',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeCrown,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFF5722),
    atkRating: 0.95,
    defRating: 0.50,
    spdRating: 0.70,
    rngRating: 0.95,
    ultimateName: 'Fire Dragon Burst',
    description:
        'Channels primordial flames incinerating all defenses. Fireballs reach across the entire arena.',
    idleFrames: 7,
  ),
  HeroInfo(
    type: CharacterType.lightningWizard,
    name: 'LIGHTNING MAGE',
    title: 'Thunder Vanguard (Voltis)',
    role: 'Mage - Crowd Control',
    pillarTile: SelectPerTile.pillarBlue,
    badgeTile: SelectPerTile.badgeCrown,
    gemTile: SelectPerTile.gemSapphire,
    primaryColor: Color(0xFF00E5FF),
    atkRating: 0.90,
    defRating: 0.55,
    spdRating: 0.85,
    rngRating: 0.88,
    ultimateName: 'Heavenly Thunder',
    description:
        'Strikes at lightning speed, electrocuting and paralyzing enemies in an instant.',
    idleFrames: 7,
    unlockLevel: 1,
    unlockPrice: 500,
  ),

  HeroInfo(
    type: CharacterType.knight1,
    name: 'HOLY KNIGHT',
    title: 'Knight of Radiance (Arthur)',
    role: 'Tank - Guardian',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeShield,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFFD54F),
    atkRating: 0.80,
    defRating: 0.92,
    spdRating: 0.65,
    rngRating: 0.60,
    ultimateName: 'Excalibur Judgment',
    description:
        'Stout plate armor and a divine ward shield. Deals immense counter damage upon impact.',
    idleFrames: 4,
    unlockLevel: 2,
    unlockPrice: 1200,
  ),



  // --- ROW 2: SAMURAIS & SKELETONS ---
  HeroInfo(
    type: CharacterType.samurai,
    name: 'LONE SAMURAI',
    title: 'Windblade Master (Kenji)',
    role: 'Assassin - Blade Tempest',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeSwords,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFF1744),
    atkRating: 0.96,
    defRating: 0.58,
    spdRating: 0.95,
    rngRating: 0.70,
    ultimateName: 'Infinite Edge',
    description:
        'Supernatural iaido cut at blinding speed. Rapid multi-slash combos decimate targets.',
    idleFrames: 6,
    unlockLevel: 2,
    unlockPrice: 2200,
  ),

  HeroInfo(
    type: CharacterType.samuraiCommander,
    name: 'SAMURAI WARLORD',
    title: 'Supreme Overlord (Nobunaga)',
    role: 'Fighter - Warlord',
    pillarTile: SelectPerTile.pillarBlue,
    badgeTile: SelectPerTile.badgeSwords,
    gemTile: SelectPerTile.gemSapphire,
    primaryColor: Color(0xFF1E88E5),
    atkRating: 0.90,
    defRating: 0.78,
    spdRating: 0.80,
    rngRating: 0.72,
    ultimateName: 'Dominion Cleave',
    description:
        'Grand battle captain possessing earth-shattering strikes that dictate the entire fight.',
    idleFrames: 5,
    unlockLevel: 3,
    unlockPrice: 2800,
  ),
  HeroInfo(
    type: CharacterType.skeletonWarrior,
    name: 'UNDEAD WARRIOR',
    title: 'Risen Remains (Krag)',
    role: 'Fighter - Immortal',
    pillarTile: SelectPerTile.pillarPurple,
    badgeTile: SelectPerTile.badgeSkull,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFF9C27B0),
    atkRating: 0.82,
    defRating: 0.75,
    spdRating: 0.75,
    rngRating: 0.65,
    ultimateName: 'Spiteful Burst',
    description:
        'Netherworld fighter oblivious to pain, relentless in cornering foes with heavy blade swings.',
    idleFrames: 7,
    unlockLevel: 3,
    unlockPrice: 3000,
  ),


];
