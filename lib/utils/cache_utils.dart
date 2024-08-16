import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

class CacheUtils {

  static final Logger log = Logger("CacheUtils");

  static Future<File> set(String key, String value) {
    return getCacheFile(key).then((file) async {
      return await file.writeAsString(value, mode: FileMode.write, flush: true);
    });
  }

  static Future<File> setBytes(String key, List<int> value) {
    return getCacheFile(key).then((file) async {
      return await file.writeAsBytes(value, mode: FileMode.write, flush: true);
    });
  }

  static Future<List<String>> getDirFiles(String path) {
    return getApplicationDocumentsDirectory()
      .then((appDir) {
        return Directory("${appDir.path}/aiCache/$path");
      })
      .then((dir) {
        if (dir.existsSync()) {
          return dir.list().map((s){
            return s.path;
          }).toList();
        }
        return [];
      });
  }

  static Future<String?> get(String key, {int? expireMinutes}) {
    return getCacheFile(key).then((file){
      if (!file.existsSync()) {
        return null;
      }
      if (expireMinutes!=null) {
        if (DateTime.now().difference(file.lastModifiedSync()).inMinutes>expireMinutes) {
          return null;
        }
      }
      return file.readAsStringSync();
    });
  }

  static Future<List<int>?> getBytes(String key, {int? expireMinutes}) {
    return getCacheFile(key).then((file){
        if (!file.existsSync()) {
          return null;
        }
        if (expireMinutes!=null) {
          if (DateTime.now().difference(file.lastModifiedSync()).inMinutes>expireMinutes) {
            return null;
          }
        }
        return file.readAsBytesSync();
    });
  }

  static Future<int> clearCacheFile(String key) {
    return getApplicationDocumentsDirectory()
    .then((appDir) {
      File f = File("${appDir.path}/aiCache/$key");
      return f.exists().then((isExists){
        if (isExists) {
          try {
            f.delete();
          }
          catch (e) {
            return 0;
          }
          return 1;
        }
        return 2;
      });
    });
  }

  static Future<File> getCacheFile(String key) {
    return getApplicationDocumentsDirectory()
      .then((appDir) {
        return File("${appDir.path}/aiCache/$key");
      })
      .then((file) {
        if (!file.parent.existsSync()) {
          file.parent.createSync(recursive: true);
        }
        return file;
      });
  }
}