import 'package:grad_ease/core/common/entities/auth_login_entity.dart';
import 'package:grad_ease/core/common/entities/author_entity.dart';
import 'package:grad_ease/core/common/entities/student_enity.dart';
import 'package:grad_ease/features/auth/data/models/auth_login_model.dart';
import 'package:grad_ease/features/auth/data/models/student_model.dart';
import 'package:hive/hive.dart';

abstract interface class LocalDetailsRepository {
  void updateLoginDetail(AuthLoginModel authLoginModel, String authToken);
  void updateStudentDetails(StudentModel studentEntity);
  void clearLoginCredientials();

  AuthLoginEntity? getLoginDetail();
  String? getLoginAuthToken();
  String? getUserId();
  StudentEntity? getStudentDetail();
  AuthorEntity? getAuthorEntity();
}

class LocalDetailsRepositoryImpl implements LocalDetailsRepository {
  final Box box;

  LocalDetailsRepositoryImpl(this.box);

  @override
  void updateLoginDetail(AuthLoginModel authLoginModel, String authToken) {
    box.put('authToken', authToken);
    box.put('authLoginDetail', authLoginModel.toJson());
  }

  @override
  void updateStudentDetails(StudentModel studentModel) {
    _updateUserId(studentModel.id);
    _updateAuthorDetail(AuthorEntity(
        id: studentModel.id,
        fullName: studentModel.fullName,
        email: studentModel.email!,
        profileImage: studentModel.profileImage!));
    box.put('studentDetail', studentModel.toMap());
  }

  void _updateUserId(String userId) {
    box.put('userId', userId);
  }

  void _updateAuthorDetail(AuthorEntity authorEntity) {
    box.put('authorDetail', authorEntity.toMap());
  }

  @override
  String? getLoginAuthToken() {
    return box.get('authToken', defaultValue: null);
  }

  @override
  StudentEntity? getStudentDetail() {
    final studentDetail = box.get('studentDetail', defaultValue: null);
    return StudentModel.fromMap(studentDetail).toEntity();
  }

  @override
  AuthLoginModel? getLoginDetail() {
    final loginDetail = box.get('authLoginDetail', defaultValue: null);
    return AuthLoginModel.fromJson(loginDetail);
  }

  @override
  void clearLoginCredientials() {
    box.put('authToken', null);
    box.put('authLoginDetail', null);
  }

  @override
  String? getUserId() {
    return box.get('userId', defaultValue: null);
  }

  @override
  AuthorEntity? getAuthorEntity() {
    final loginDetail = box.get('authorDetail', defaultValue: null);
    return AuthorEntity.fromMap(loginDetail);
  }
}