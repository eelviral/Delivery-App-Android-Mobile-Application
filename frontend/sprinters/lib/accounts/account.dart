import 'dart:convert';

class Account {
  int id;
  String email;
  String firstName;
  String lastName;
  String homeAddress;
  String homeState;
  String homeUnit;
  String homeCity;
  DateTime dateOfBirth;
  String mailingAddress;
  String mailingState;
  String mailingUnit;
  String mailingCity;

  Account({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.homeAddress,
    required this.homeState,
    required this.homeUnit,
    required this.homeCity,
    required this.dateOfBirth,
    required this.mailingAddress,
    required this.mailingState,
    required this.mailingUnit,
    required this.mailingCity,
  });

  Account copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? homeAddress,
    String? homeState,
    String? homeUnit,
    String? homeCity,
    DateTime? dateOfBirth,
    String? mailingAddress,
    String? mailingState,
    String? mailingUnit,
    String? mailingCity,
  }) {
    return Account(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      homeAddress: homeAddress ?? this.homeAddress,
      homeState: homeState ?? this.homeState,
      homeUnit: homeUnit ?? this.homeUnit,
      homeCity: homeCity ?? this.homeCity,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      mailingState: mailingState ?? this.mailingState,
      mailingUnit: mailingUnit ?? this.mailingUnit,
      mailingCity: mailingCity ?? this.mailingCity,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'first_name': firstName});
    result.addAll({'last_name': lastName});
    result.addAll({'home_address': homeAddress});
    result.addAll({'home_state': homeState});
    result.addAll({'home_unit': homeUnit});
    result.addAll({'home_city': homeCity});
    result.addAll({'date_of_birth': dateOfBirth.millisecondsSinceEpoch});
    result.addAll({'mailing_address': mailingAddress});
    result.addAll({'mailing_state': mailingState});
    result.addAll({'mailing_unit': mailingUnit});
    result.addAll({'mailing_city': mailingCity});

    return result;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      homeAddress: map['home_address'] ?? '',
      homeState: map['home_state'] ?? '',
      homeUnit: map['home_unit'] ?? '',
      homeCity: map['home_city'] ?? '',
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      mailingAddress: map['mailing_address'] ?? '',
      mailingState: map['mailing_state'] ?? '',
      mailingUnit: map['mailing_unit'] ?? '',
      mailingCity: map['mailing_city'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(id: $id, email: $email, first_name: $firstName, last_name: $lastName, home_address: $homeAddress, home_state: $homeState, home_unit: $homeUnit, home_city: $homeCity, date_of_birth: $dateOfBirth, mailing_address: $mailingAddress, mailing_state: $mailingState, mailing_unit: $mailingUnit, mailing_city: $mailingCity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.homeAddress == homeAddress &&
        other.homeState == homeState &&
        other.homeUnit == homeUnit &&
        other.homeCity == homeCity &&
        other.dateOfBirth == dateOfBirth &&
        other.mailingAddress == mailingAddress &&
        other.mailingState == mailingState &&
        other.mailingUnit == mailingUnit &&
        other.mailingCity == mailingCity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        homeAddress.hashCode ^
        homeState.hashCode ^
        homeUnit.hashCode ^
        homeCity.hashCode ^
        dateOfBirth.hashCode ^
        mailingAddress.hashCode ^
        mailingState.hashCode ^
        mailingUnit.hashCode ^
        mailingCity.hashCode;
  }
}
