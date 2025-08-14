import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // ATTENTION : NE JAMAIS HARDCODER DE CLÉ EN PRODUCTION.
  // Ceci est un exemple. Pour une application réelle, la clé doit être
  // stockée et gérée de manière sécurisée (ex: via un service de gestion
  // de secrets) et ne jamais être visible dans le code source.
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
  final _iv = encrypt.IV.fromLength(16);

  late final encrypt.Encrypter _encrypter;

  EncryptionService() {
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  // Chiffre un texte
  String encryptText(String plainText) {
    if (plainText.isEmpty) return '';
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Déchiffre un texte
  String decryptText(String encryptedText) {
    if (encryptedText.isEmpty) return '';
    try {
      final encryptedData = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encryptedData, iv: _iv);
    } catch (e) {
      // Si le déchiffrement échoue (ex: ancien message non chiffré),
      // retourne le texte original en indiquant une erreur.
      print("Erreur de déchiffrement: $e");
      return "[Message non déchiffrable]";
    }
  }
}