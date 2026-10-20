import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();
}
