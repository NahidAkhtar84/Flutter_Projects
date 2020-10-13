import 'dart:convert';

Credential credentialFromJson(String str) => Credential.fromJson(json.decode(str));

String credentialToJson(Credential data) => json.encode(data.toJson());

class Credential {
  Credential({
    this.token,
    this.username,
  });

  String token;
  String username;

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    token: json["token"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "username": username,
  };
}