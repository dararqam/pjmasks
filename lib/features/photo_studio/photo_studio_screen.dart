import 'package:flutter/material.dart';
import '../../core/audio/audio_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/hero_character.dart';
import '../../widgets/pj_button.dart';
import '../ar_mask/hero_mask_painter.dart';

class PhotoStudioScreen extends StatefulWidget {
  final HeroId heroId;

  const PhotoStudioScreen({super.key, required this.heroId});

  @override
  State<PhotoStudioScreen> createState() => _PhotoStudioScreenState();
}

class _PhotoStudioScreenState extends State<PhotoStudioScreen> {
  final List<_StickerItem> _stickers = [];

  @override
  void initState() {
    super.initState();
    // Default stickers added
    _stickers.add(
      _StickerItem(
        emoji: '🏆',
        text: 'TIME TO BE A HERO!',
        offset: const Offset(120, 360),
        color: AppColors.cyan,
      ),
    );
  }

  void _addSticker(String emoji, String text, Color color) {
    setState(() {
      _stickers.add(
        _StickerItem(
          emoji: emoji,
          text: text,
          offset: const Offset(140, 200),
          color: color,
        ),
      );
    });
    AudioService.instance.playClick();
  }

  void _savePhoto() {
    AudioService.instance.playVictory();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.blue,
        content: Text('💾 Photo Saved to Device! You are a Hero!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E20),
      appBar: AppBar(
        title: const Text('HERO BADGE STUDIO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () {
              setState(() {
                _stickers.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Safe Badge Guidelines Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              color: Colors.cyan.withOpacity(0.12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.cyan, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Superhero Avatar & Badge Studio — Family Safe Only',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Photo Canvas Area with Border Frame
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cyan, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background hero gradient
                        Container(
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              colors: [Color(0xFF132863), Color(0xFF050C20)],
                              radius: 0.9,
                            ),
                          ),
                        ),
                        // Render hero mask
                        CustomPaint(
                          painter: HeroMaskPainter(
                            heroId: widget.heroId,
                            headX: 0.5,
                            headY: 0.45,
                            scale: 0.9,
                          ),
                        ),
                        // Draggable stickers
                        ..._stickers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final sticker = entry.value;

                          return Positioned(
                            left: sticker.offset.dx,
                            top: sticker.offset.dy,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  _stickers[idx] = sticker.copyWith(
                                    offset: sticker.offset + details.delta,
                                  );
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: sticker.color.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(sticker.emoji, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 6),
                                    Text(
                                      sticker.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Sticker Selection Tray
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _trayButton('🐱', 'CATBOY', const Color(0xFF0052CC)),
                  _trayButton('🦉', 'OWLETTE', const Color(0xFFCC0033)),
                  _trayButton('🦎', 'GEKKO', const Color(0xFF00802B)),
                  _trayButton('⚡', 'SPEED!', const Color(0xFF00D4FF)),
                  _trayButton('🪶', 'WINGS!', const Color(0xFFFFCC00)),
                  _trayButton('💪', 'MUSCLES!', const Color(0xFF66FF99)),
                  _trayButton('⭐', 'STAR', Colors.amber),
                ],
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: PjButton(
                      text: 'RETAKE',
                      variant: PjButtonVariant.ghost,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PjButton(
                      text: 'SAVE PHOTO',
                      variant: PjButtonVariant.blue,
                      onPressed: _savePhoto,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trayButton(String emoji, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        avatar: Text(emoji),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        backgroundColor: color.withOpacity(0.35),
        side: BorderSide(color: color),
        onPressed: () => _addSticker(emoji, text, color),
      ),
    );
  }
}

class _StickerItem {
  final String emoji;
  final String text;
  final Offset offset;
  final Color color;

  _StickerItem({
    required this.emoji,
    required this.text,
    required this.offset,
    required this.color,
  });

  _StickerItem copyWith({Offset? offset}) {
    return _StickerItem(
      emoji: emoji,
      text: text,
      offset: offset ?? this.offset,
      color: color,
    );
  }
}
