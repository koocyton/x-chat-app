import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as dr;
import 'package:flutter/material.dart';
import 'package:chat_hub/utils/cache_utils.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart' as c;
import 'package:path_provider/path_provider.dart';

class HttpUtils {

  static Logger log = Logger("HttpUtils");

  // static final Future<String?> currentLocaleFuture = Devicelocale.currentLocale;

  static final Map<String, String> accountInfoMap = {
    "account" : "",
    "password" : ""
  };

  static final Map<String, String> defaultHeaderMap = {
    'Accept':'text/html,application/json,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    // 'Accept-Encoding':'gzip, deflate, br',
    // 'Accept-Language': "Http:AcceptLanguage".tr,
    'Cache-Control':'max-age=0',
    // 'Connection':'keep-alive',
    // 'sec-ch-ua':'".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
    // 'sec-ch-ua-mobile':'?0',
    // 'sec-ch-ua-platform':'"Windows"',
    // 'Sec-Fetch-Dest':'document',
    // 'Sec-Fetch-Mode':'navigate',
    // 'Sec-Fetch-Site':'none',
    // 'Sec-Fetch-User':'?1',
    // 'Upgrade-Insecure-Requests':'1',
    // 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
  };

  static String md5(String str) {
    return c.md5.convert(
      Utf8Encoder().convert(str)
    ).toString();
  }

  static Dio? _dioInstance;

  static Dio getDioInstance() {
    if (_dioInstance == null) {
      _dioInstance = Dio()..interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            //debugPrint(" >>> onRequest url : ${options.uri}");
            //debugPrint(" >>> onRequest header : ${options.headers}");
            return handler.next(options);
          }, 
          onResponse: (response, handler) {
            //debugPrint(" >>> onResponse : ${response.statusCode}");
            handler.next(response);
          }, 
          onError: (DioError e, handler) {
            //debugPrint(" >>> onError response statusCode : ${e.response!.statusCode}");
            //debugPrint(" >>> onError response data : ${e.response!.data}");
            return handler.next(e);
          })
        );
    }
    return _dioInstance!;
  }

  static Future<String?> stringFormPost(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headerMap, String? postData}) async {
    String? str;
    if (cacheKey!=null) {
      String? str = await CacheUtils.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null && str.isNotEmpty) {
        return str;
      }
    }
    return formPost(url, headerMap: headerMap, postData: postData).then((response){
      str = response.toString();
      if (cacheKey!=null && str!=null && str!.length>=10) {
        CacheUtils.set(cacheKey, str!);
      }
      return str;
    });
  }

  static Future<dr.Response<T>> formPost<T>(String url, {Map<String, String>? headerMap, String? postData}) {
    headerMap ??= {};
    headerMap["content-type"] = "application/x-www-form-urlencoded; charset=UTF-8";
    return getDioInstance().post<T>(url,
      data: postData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status!=null && status < 500; 
        },
        headers: headers(headerMap),
      ),
    );
  }

  static Future<dynamic> dataGet(String url, {Map<String, String>? headerMap}) async {
    headerMap ??= {};
    try {
      return await (getDioInstance().get(url,
        options: Options(
          headers: headers(headerMap),
        ),
      ))
      .then((response){
        return response.data;
      });
    }
    on Exception catch(e) {
      log.info(e);
      return Future.value(null);
    }
  }

  static Future<String?> stringGet(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headerMap}) async {
    String? str;
    if (cacheKey!=null) {
      str = await CacheUtils.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null) {
        return str;
      }
    }
    headerMap ??= {};
    try {
      return await (getDioInstance().get(url,
        options: Options(
          headers: headers(headerMap),
        ),
      ))
      .then((response){
        str = response.toString();
        if (cacheKey!=null && str!=null) {
          CacheUtils.set(cacheKey, str!);
        }
        return str;
      });
    }
    on Exception catch(e) {
      log.info(e);
      return Future.value(null);
    }
  }

  static Future<dynamic> dataPost(String url, {Map<String, String>? headerMap, Map<String, dynamic>? postData}) async {
    // log.info(url);
    headerMap ??= {};
    try {
      return await (getDioInstance().post(url,
        data: postData,
        options: Options(
          headers: headers(headerMap),
        ),
      ))
      .then((response){
        return response.data;
      });
    }
    on Exception catch(e) {
      log.info(e);
      return Future.value(null);
    }
  }

  static Future<String?> stringPost(String url, {String? cacheKey, int? cacheDuration, Map<String, String>? headerMap, dynamic postData}) async {
    if (cacheKey!=null) {
      cacheKey = md5(cacheKey);
    }
    String? str;
    if (cacheKey!=null) {
      str = await CacheUtils.get(cacheKey, expireMinutes: cacheDuration);
      if (str!=null) {
        return str;
      }
    }
    try {
      return await getDioInstance().post(url,
        data: postData,
        options: Options(
          headers: headers(headerMap),
        ),
      ).then((response){
        str = response.toString();
        if (cacheKey!=null && str!=null) {
          CacheUtils.set(cacheKey, str!);
        }
        return str;
      });
    }
    on Exception catch(e) {
      log.info(e);
      debugPrint(e.toString());
      return Future.value(null);
    }
  }

  static Future<String> getAbsolutePath(String relativePath) {
    return getApplicationDocumentsDirectory().then((appDir){
      return "${appDir.path}/$relativePath";
    });
  }

  static Future<String?> downFile(String url, String savePath, {Map<String, String>? headerMap}) {
    try {
      return getAbsolutePath(savePath).then((filePath){
        // Dio dio = Dio();
        // dio.options.connectTimeout = 100000;
        // dio.options.receiveTimeout = 100000;
        return getDioInstance().download(
          url,
          filePath,
          options: Options(
            headers: headers(headerMap??{}),
          ),
        ).then((response){
          return filePath;
        });
      });
    }
    on Exception catch(e) {
      log.info(e);
      return Future.value(null);
    }
  }

  static Map<String, String> headers(Map<String, String>? moreHeaders) {
    Map<String, String> headers = {};
    headers.addAll(defaultHeaderMap);
    if (moreHeaders!=null) {
      for(String key in moreHeaders.keys) {
        headers[key] = moreHeaders[key]!;
      }
    }
    // for(String key in headers.keys) {
    //   log.info("$key : ${headers[key]}");
    // }
    return headers;
  }
}