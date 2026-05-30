import 'package:equatable/equatable.dart';

class Soundscape extends Equatable {
  final String id;
  final String name;
  final String nameEn;
  final String assetPath;
  final int durationMinutes;
  final bool isPremium;
  final bool isLooping;

  Soundscape({
    required this.id,
    required this.name,
    required this.nameEn,
    this.assetPath = '',
    this.durationMinutes = 30,
    this.isPremium = false,
    this.isLooping = true,
  });

  static final List<Soundscape> free = [
    Soundscape(
      id: 'rain',
      name: 'مطر هادئ',
      nameEn: 'Gentle Rain',
      assetPath: 'sounds/rain.mp3',
    ),
  ];

  static final List<Soundscape> premium = [
    Soundscape(
      id: 'ocean',
      name: 'أمواج المحيط',
      nameEn: 'Ocean Waves',
      assetPath: 'sounds/ocean.mp3',
      isPremium: true,
    ),
    Soundscape(
      id: 'forest',
      name: 'غابة ليلية',
      nameEn: 'Night Forest',
      assetPath: 'sounds/forest.mp3',
      isPremium: true,
    ),
    Soundscape(
      id: 'fire',
      name: 'دفء المدفأة',
      nameEn: 'Fireplace',
      assetPath: 'sounds/fireplace.mp3',
      isPremium: true,
    ),
    Soundscape(
      id: 'wind',
      name: 'نسيم خفيف',
      nameEn: 'Gentle Wind',
      assetPath: 'sounds/wind.mp3',
      isPremium: true,
    ),
  ];

  static List<Soundscape> all(bool hasPremium) =>
    hasPremium ? [...free, ...premium] : free;

  @override
  List<Object?> get props => [id, name, nameEn, isPremium];
}
