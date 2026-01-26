import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 3)
class Tag {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  int color; // Store Color.value as int
  
  @HiveField(3)
  DateTime createdAt;

  Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  // Copy with method for updates
  Tag copyWith({
    String? id,
    String? name,
    int? color,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
