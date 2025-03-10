class SushiSet {
  final String id;
  final String name;
  final List<String> rolls;
  final String ownerId;

  SushiSet({
    required this.id,
    required this.name,
    required this.rolls,
    required this.ownerId,
  });

  factory SushiSet.fromFirestore(Map<String, dynamic> data, String id) {
    return SushiSet(
      id: id,
      name: data['setName'] ?? 'Без названия',
      rolls: List<String>.from(data['rolls'] ?? []),
      ownerId: data['owner'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'setName': name,
      'rolls': rolls,
      'owner': ownerId,
    };
  }
}
