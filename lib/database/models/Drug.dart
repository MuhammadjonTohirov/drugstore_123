// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:drugstore/database/media_manager.dart';

class Drug {
  static const tableName = 'drugs';
  late int? id;
  late String name;
  late String description;
  late String image;

  Drug({
    this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  Drug copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
  }) {
    return Drug(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Drug(name: $name, description: $description, image: $image)';

  @override
  bool operator ==(covariant Drug other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ image.hashCode;

  Future<Uint8List?> get imageBytes => MediaManager.instance.get(image);
}
