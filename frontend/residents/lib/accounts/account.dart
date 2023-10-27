import 'dart:convert';

class Account {
  int id;
  String email;
  String firstName;
  String lastName;
  String phone;

  Account({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  Account copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    return Account(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'first_name': firstName});
    result.addAll({'last_name': lastName});
    result.addAll({'phone': phone});
  
    return result;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(id: $id, email: $email, first_name: $firstName, last_name: $lastName, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Account &&
      other.id == id &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      phone.hashCode;
  }
}
