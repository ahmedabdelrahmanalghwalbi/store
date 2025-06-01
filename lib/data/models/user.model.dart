import 'package:equatable/equatable.dart';
import '../../utils/app_logger.utils.dart';
import 'base.model.dart';

class UserModel extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final Name? name;
  final Address? address;
  final String? phone;
  final int? v;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.name,
    this.address,
    this.phone,
    this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: BaseModel.parseInt(json['id']),
        username: BaseModel.parseString(json['username']),
        email: BaseModel.parseString(json['email']),
        password: BaseModel.parseString(json['password']),
        name: json['name'] != null ? Name.fromJson(json['name']) : null,
        address:
            json['address'] != null ? Address.fromJson(json['address']) : null,
        phone: BaseModel.parseString(json['phone']),
        v: BaseModel.parseInt(json['__v']),
      );
    } catch (e, s) {
      AppLogger.error(
        "Error parsing UserModel",
        error: e,
        stackTrace: s,
        tag: "UserModel",
      );
      return const UserModel();
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'name': name?.toJson(),
    'address': address?.toJson(),
    'phone': phone,
    '__v': v,
  };

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    Name? name,
    Address? address,
    String? phone,
    int? v,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    password,
    name,
    address,
    phone,
    v,
  ];
}

class Name extends Equatable {
  final String? firstname;
  final String? lastname;

  const Name({this.firstname, this.lastname});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstname: BaseModel.parseString(json['firstname']),
      lastname: BaseModel.parseString(json['lastname']),
    );
  }

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
  };

  String get fullName =>
      [firstname, lastname].where((n) => n != null).join(' ');

  Name copyWith({String? firstname, String? lastname}) {
    return Name(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
    );
  }

  @override
  List<Object?> get props => [firstname, lastname];
}

class Address extends Equatable {
  final Geolocation? geolocation;
  final String? city;
  final String? street;
  final int? number;
  final String? zipcode;

  const Address({
    this.geolocation,
    this.city,
    this.street,
    this.number,
    this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      geolocation:
          json['geolocation'] != null
              ? Geolocation.fromJson(json['geolocation'])
              : null,
      city: BaseModel.parseString(json['city']),
      street: BaseModel.parseString(json['street']),
      number: BaseModel.parseInt(json['number']),
      zipcode: BaseModel.parseString(json['zipcode']),
    );
  }

  Map<String, dynamic> toJson() => {
    'geolocation': geolocation?.toJson(),
    'city': city,
    'street': street,
    'number': number,
    'zipcode': zipcode,
  };

  String get fullAddress => [
    number?.toString(),
    street,
    city,
    zipcode,
  ].where((p) => p != null).join(', ');

  Address copyWith({
    Geolocation? geolocation,
    String? city,
    String? street,
    int? number,
    String? zipcode,
  }) {
    return Address(
      geolocation: geolocation ?? this.geolocation,
      city: city ?? this.city,
      street: street ?? this.street,
      number: number ?? this.number,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  @override
  List<Object?> get props => [geolocation, city, street, number, zipcode];
}

class Geolocation extends Equatable {
  final String? lat;
  final String? long;

  const Geolocation({this.lat, this.long});

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(
      lat: BaseModel.parseString(json['lat']),
      long: BaseModel.parseString(json['long']),
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'long': long};

  Geolocation copyWith({String? lat, String? long}) {
    return Geolocation(lat: lat ?? this.lat, long: long ?? this.long);
  }

  @override
  List<Object?> get props => [lat, long];
}
