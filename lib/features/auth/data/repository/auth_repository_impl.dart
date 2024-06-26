// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:grad_ease/core/common/entities/auth_detail_enity.dart';
import 'package:grad_ease/core/common/models/upload_file_response_model.dart';
import 'package:grad_ease/core/local/local_repository.dart';
import 'package:grad_ease/core/remote/response_wrapper.dart';
import 'package:grad_ease/core/remote/rest_exception.dart';
import 'package:grad_ease/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:grad_ease/features/auth/data/models/auth_login_model.dart';
import 'package:grad_ease/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final LocalDetailsRepository authLocalDataSource;

  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, String>> adminLogin(
      {required String email, required String password}) async {
    try {
      final response = await authRemoteDataSource.adminLogin(
          email: email, password: password);
      authLocalDataSource.updateLoginDetail(
        AuthLoginModel(email: email, password: password),
        response.data!,
      );
      return right(response.data!);
    } catch (e) {
      authLocalDataSource.clearLoginCredientials();
      return left(Failure.handleException(e));
    }
  }

  @override
  Future<Either<Failure, RestResponse<String>>> studentLogin(
      {required String email, required String password}) async {
    try {
      final response = await authRemoteDataSource.studentLogin(
        email: email,
        password: password,
      );
      if (response.data != null) {
        authLocalDataSource.updateLoginDetail(
          AuthLoginModel(email: email, password: password),
          response.data!,
        );
        return right(response);
      }
      return left(Failure("Error while logging in!"));
    } on RestResponseException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      authLocalDataSource.clearLoginCredientials();
      return left(Failure.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthDetailEntity?>> getStudentDetail(
      String email) async {
    try {
      final studentEntity = await authRemoteDataSource.getStudentDetail(email);
      if (studentEntity != null) {
        if (studentEntity.isApproved!) {
          authLocalDataSource.updateStudentDetails(studentEntity);
        } else {
          authLocalDataSource.clearLoginCredientials();
          return left(Failure(
              "Your account is not approvred, please contact college admin"));
        }
      }
      return right(studentEntity!.toEntity());
    } catch (e) {
      return left(Failure.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthDetailEntity?>> registerStudent(
    String fullName,
    String fatherName,
    DateTime dob,
    String gender,
    String course,
    String email,
    String studentPhone,
    String parentPhone,
    String password,
    String profileImage,
  ) async {
    try {
      final response = await authRemoteDataSource.registerStudent(
        fullName,
        fatherName,
        dob,
        gender,
        course,
        email,
        studentPhone,
        parentPhone,
        password,
        profileImage,
      );
      return right(response.toEntity());
    } on RestResponseException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      authLocalDataSource.clearLoginCredientials();
      return left(Failure.handleException(e));
    }
  }

  @override
  Future<UploadFileResponseModel> uploadStudentProfile(
      String fileName, String filePath) async {
    try {
      final response =
          await authRemoteDataSource.uploadImage(fileName, filePath);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
