import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:universal_html/html.dart' as html;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload image (mobile: File, web: html.File)
  Future<String> uploadSchoolImage(
    String nameColletion,
    String id,
    dynamic imageFile,
  ) async {
    try {
      final ref = _storage
          .ref()
          .child(nameColletion)
          .child(id)
          .child('profile.jpg');

      UploadTask uploadTask;

      if (kIsWeb) {
        // Web : imageFile doit être html.File
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = ref.putBlob(imageFile, metadata);
      } else {
        // Mobile : imageFile est un File
        uploadTask = ref.putFile(imageFile);
      }

      final snapshot = await uploadTask.whenComplete(() => {});

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image : $e');
    }
  }
}
