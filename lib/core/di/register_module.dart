import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/network/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  @lazySingleton
  Dio dio() {
    const baseUrl = String.fromEnvironment('API_BASE_URL');
    return Dio(BaseOptions(baseUrl: baseUrl));
  }

  @lazySingleton
  RestClient restClient(Dio dio) => RestClient(dio);

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
