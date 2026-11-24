import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Erreur lisible renvoyée par le service (message affichable à l'écran).
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Un membre de la famille tel que renvoyé par l'API (table famille_membre).
class FamilyMember {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // AAAA-MM-JJ
  final String parente;

  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    String s(String key) => (json[key] ?? '').toString();
    return FamilyMember(
      id: int.tryParse(s('id')) ?? 0,
      nom: s('nom'),
      postnom: s('postnom'),
      prenom: s('prenom'),
      lieuNaissance: s('lieu_naissance'),
      dateNaissance: s('date_naissance'),
      parente: s('parente'),
    );
  }

  String get nomComplet => [nom, postnom, prenom]
      .where((part) => part.trim().isNotEmpty)
      .join(' ');

  String get initiales {
    final a = nom.trim().isNotEmpty ? nom.trim()[0] : '';
    final b = prenom.trim().isNotEmpty ? prenom.trim()[0] : '';
    final result = (a + b).toUpperCase();
    return result.isEmpty ? '?' : result;
  }
}

/// Centralise tous les appels à l'API PHP (login + CRUD famille).
class ApiService {
  /// Adresse du PC pour un vrai téléphone, passée au lancement :
  /// flutter run --dart-define=API_HOST=192.168.1.20
  static const _customHost = String.fromEnvironment('API_HOST');

  /// - Si API_HOST est fourni : on l'utilise (téléphone physique).
  /// - Émulateur Android : 10.0.2.2 désigne le PC hôte (XAMPP).
  /// - Windows / Chrome : localhost.
  static String get baseUrl {
    const path = 'api-test/public';
    if (_customHost.isNotEmpty) return 'http://$_customHost/$path';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/$path';
    }
    return 'http://localhost/$path';
  }

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static const _timeout = Duration(seconds: 10);

  /// Décode la réponse et vérifie code HTTP + champ `success`.
  static Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body;
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      body = decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    } catch (_) {
      throw ApiException(
          'Réponse invalide du serveur (code ${response.statusCode}).');
    }
    final ok = response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body['success'] != false;
    if (!ok) {
      final msg = body['message'] ?? body['error'] ?? body['erreur'];
      throw ApiException(msg?.toString() ??
          'Le serveur a refusé la requête (code ${response.statusCode}).');
    }
    return body;
  }

  static Future<http.Response> _send(Future<http.Response> request) async {
    try {
      return await request.timeout(_timeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(
          'Impossible de joindre le serveur. Vérifiez qu\'Apache et MySQL '
          'sont démarrés dans XAMPP.');
    }
  }

  static Future<bool> testerConnexion() async {
    try {
      final r = await _send(http.get(Uri.parse('$baseUrl/famille-membres')));
      _decode(r);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Vérifie les identifiants auprès de l'API. Lance une [ApiException]
  /// en cas d'échec.
  static Future<void> seConnecter(String email, String password) async {
    final r = await _send(http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    ));
    _decode(r);
  }

  /// Crée un compte via POST /accounts/register.
  static Future<void> sInscrire(String email, String password) async {
    final r = await _send(http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    ));
    _decode(r);
  }

  static Future<List<FamilyMember>> getFamilyMembers() async {
    final r = await _send(http.get(Uri.parse('$baseUrl/famille-membres'),
        headers: _headers));
    final data = _decode(r)['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => FamilyMember.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Map<String, String> _payload({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) =>
      {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };

  static Future<void> ajouterMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) async {
    final r = await _send(http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: _headers,
      body: jsonEncode(_payload(
        nom: nom,
        postnom: postnom,
        prenom: prenom,
        lieuNaissance: lieuNaissance,
        dateNaissance: dateNaissance,
        parente: parente,
      )),
    ));
    _decode(r);
  }

  static Future<void> modifierMembre({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) async {
    final r = await _send(http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: _headers,
      body: jsonEncode(_payload(
        nom: nom,
        postnom: postnom,
        prenom: prenom,
        lieuNaissance: lieuNaissance,
        dateNaissance: dateNaissance,
        parente: parente,
      )),
    ));
    _decode(r);
  }

  static Future<void> supprimerMembre(int id) async {
    final r = await _send(http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: _headers,
    ));
    _decode(r);
  }
}
