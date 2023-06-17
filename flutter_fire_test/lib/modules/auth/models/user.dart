// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LocalUserInfo {
  final String uid;
  final String name;
  LocalUserInfo({
    required this.uid,
    required this.name,
  });

  LocalUserInfo copyWith({
    String? uid,
    String? name,
  }) {
    return LocalUserInfo(
      uid: uid ?? this.uid,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
    };
  }

  factory LocalUserInfo.fromMap(Map<String, dynamic> map) {
    return LocalUserInfo(
      uid: map['uid'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalUserInfo.fromJson(String source) =>
      LocalUserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocalUserInfo(uid: $uid, name: $name)';

  @override
  bool operator ==(covariant LocalUserInfo other) => other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
