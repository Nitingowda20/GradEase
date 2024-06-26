import 'package:dio/dio.dart';
import 'package:grad_ease/core/common/models/upload_file_response_model.dart';
import 'package:grad_ease/core/constants/rest_resources.dart';
import 'package:grad_ease/core/remote/gradease_rest_service.dart';
import 'package:grad_ease/features/admin/data/models/student_detail.dart';
import 'package:grad_ease/features/admin/data/models/students_response_model.dart';
import 'package:grad_ease/features/admin/data/models/time_table_response_model.dart';
import 'package:grad_ease/features/assignment/data/models/assignment_model.dart';
import 'package:grad_ease/features/assignment/data/models/assignment_response_model.dart';
import 'package:grad_ease/features/auth/data/models/student_model.dart';
import 'package:grad_ease/features/communities/data/models/communites_reponse_model.dart';
import 'package:grad_ease/features/communities/data/models/communtiy_model.dart';
import 'package:grad_ease/features/timetable/data/models/time_table_respose_model.dart'
    as tt;
import 'package:grad_ease/features/timetable/data/models/time_table_model.dart'
    as ttdto;

abstract interface class AdminRemoteDataSource {
  Future<StudentsResponseModel> getAllStudents();
  Future<StudentDetail> approveStudent(String studentEmail);
  Future<StudentDetail> deleteStudent(String studentEmail);
  Future<AuthLoginDetailModel> updateStudentData(
    String fullName,
    String fatherName,
    DateTime dob,
    String gender,
    String course,
    int year,
    String section,
    String email,
    String studentPhone,
    String parentPhone,
    String profileImage,
    String role,
  );
  Future<TimeTableResponseModel> getAllTimeTables();
  Future<tt.TimeTableResponseModel> addTimeTable(
      ttdto.TimeTableModel timeTable);
  Future<tt.TimeTableResponseModel> updateTimeTable(
      ttdto.TimeTableModel timeTable);
  Future<tt.TimeTableResponseModel> deleteTimeTable(
      ttdto.TimeTableModel timeTable);
  Future<CommunityRespnseModel> getCommunites();
  Future<UploadFileResponseModel> uploadImage(String fileName, String filePath);
  Future<CommunityModel> addCommunity(String communityName,
      String communityDescription, String profilePath, int year, String course);
  Future<CommunityModel> updateCommunity(String id, String communityName,
      String communityDescription, String profilePath, int year, String course);
  Future<CommunityModel> deleteCommunity(String id);
  Future<AssignmentResponseModel> getAllAssignment();
  Future<AssignmentModel> deleteAssignment(String id);
  Future<AssignmentModel> addAssignment(
    String title,
    String description,
    String submissionDate,
    int year,
    String course,
    String authorName,
    String authorEmail,
  );
  Future<AssignmentModel> updateAssignment(
    String assignmentId,
    String title,
    String description,
    String submissionDate,
    int year,
    String course,
    String authorName,
    String authorEmail,
  );
}

class AdminRemoteDataSourceImpl extends GradEaseRestService
    implements AdminRemoteDataSource {
  @override
  Future<StudentsResponseModel> getAllStudents() async {
    final restRequest = createGetRequest(RestResources.getAllStudents);
    final response = await executeRequest(restRequest);
    return StudentsResponseModel.fromJson(response.data);
  }

  @override
  Future<StudentDetail> approveStudent(String studentEmail) async {
    final restRequest =
        createPutRequest(RestResources.studentByEmail(studentEmail), body: {
      "isApproved": true,
    });
    final response = await executeRequest(restRequest);
    return StudentDetail.fromJson(response.data['data']);
  }

  @override
  Future<StudentDetail> deleteStudent(String studentEmail) async {
    final restRequest =
        createDeleteRequest(RestResources.studentByEmail(studentEmail));
    final response = await executeRequest(restRequest);
    return StudentDetail.fromJson(response.data['data']);
  }

  @override
  Future<TimeTableResponseModel> getAllTimeTables() async {
    final restRequest = createGetRequest(RestResources.timetable);
    final response = await executeRequest(restRequest);
    return TimeTableResponseModel.fromJson(response.data);
  }

  @override
  Future<tt.TimeTableResponseModel> addTimeTable(
      ttdto.TimeTableModel timeTable) async {
    final restRequest = createPostRequest(RestResources.timetable,
        body: timeTable.toPostJson());
    final response = await executeRequest(restRequest);
    return tt.TimeTableResponseModel.fromJson(response.data);
  }

  @override
  Future<tt.TimeTableResponseModel> deleteTimeTable(
      ttdto.TimeTableModel timeTable) async {
    final restRequest = createDeleteRequest(RestResources.getTimeTable(
      timeTable.course,
      timeTable.year,
      timeTable.section,
    ));
    final response = await executeRequest(restRequest);
    return tt.TimeTableResponseModel.fromJson(response.data);
  }

  @override
  Future<tt.TimeTableResponseModel> updateTimeTable(
      ttdto.TimeTableModel timeTable) async {
    final restRequest = createPutRequest(
        RestResources.getTimeTable(
          timeTable.course,
          timeTable.year,
          timeTable.section,
        ),
        body: timeTable.toPostJson());
    final response = await executeRequest(restRequest);
    return tt.TimeTableResponseModel.fromJson(response.data);
  }

  @override
  Future<CommunityRespnseModel> getCommunites() async {
    final restRequest = createGetRequest(RestResources.getAllCommunites);
    final response = await executeRequest(restRequest);
    return CommunityRespnseModel.fromJson(response.data);
  }

  @override
  Future<CommunityModel> addCommunity(
      String communityName,
      String communityDescription,
      String profilePath,
      int year,
      String course) async {
    final restRequest = createPostRequest(RestResources.communites, body: {
      "name": communityName,
      'description': communityDescription,
      "profileImage": profilePath,
      "course": course,
      "year": year,
    });
    final response = await executeRequest(restRequest);
    return CommunityModel.fromJson(response.data['data']);
  }

  @override
  Future<UploadFileResponseModel> uploadImage(
      String fileName, String filePath) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });
    final restRequest =
        createPostRequest(RestResources.uploadCommunityImage, body: formData);
    final response = await executeRequest(restRequest);
    return UploadFileResponseModel.fromJson(response.data);
  }

  @override
  Future<CommunityModel> updateCommunity(
      String id,
      String communityName,
      String communityDescription,
      String profilePath,
      int year,
      String course) async {
    final restRequest =
        createPutRequest(RestResources.communityById(id), body: {
      "name": communityName,
      'description': communityDescription,
      "profileImage": profilePath,
      "course": course,
      "year": year,
    });
    final response = await executeRequest(restRequest);
    return CommunityModel.fromJson(response.data['data']);
  }

  @override
  Future<CommunityModel> deleteCommunity(String id) async {
    final restRequest = createDeleteRequest(RestResources.communityById(id));
    final response = await executeRequest(restRequest);
    return CommunityModel.fromJson(response.data['data']);
  }

  @override
  Future<AuthLoginDetailModel> updateStudentData(
      String fullName,
      String fatherName,
      DateTime dob,
      String gender,
      String course,
      int year,
      String section,
      String email,
      String studentPhone,
      String parentPhone,
      String profileImage,
      String role) async {
    final restRequest =
        createPutRequest(RestResources.studentByEmail(email), body: {
      "fullName": fullName,
      "fatherName": fatherName,
      "dob": dob.toIso8601String(),
      "gender": gender,
      "course": course,
      "courseYear": year,
      "email": email,
      "studentPhone": studentPhone,
      "parentPhone": parentPhone,
      "profileImage": profileImage,
      "section": section,
      "role": role,
    });
    final response = await executeRequest(restRequest);
    return AuthLoginDetailModel.fromMap(response.data['data']);
  }

  @override
  Future<AssignmentResponseModel> getAllAssignment() async {
    final restRequest = createGetRequest(RestResources.assignment);
    final respone = await executeRequest(restRequest);
    return AssignmentResponseModel.fromJson(respone.data);
  }

  @override
  Future<AssignmentModel> deleteAssignment(String id) async {
    final restRequest =
        createDeleteRequest(RestResources.getAssingmentById(id));
    final respone = await executeRequest(restRequest);
    return AssignmentModel.fromJson(respone.data['data']);
  }

  @override
  Future<AssignmentModel> addAssignment(
      String title,
      String description,
      String submissionDate,
      int year,
      String course,
      String authorName,
      String authorEmail) async {
    final restRequest = createPostRequest(RestResources.assignment, body: {
      "title": title,
      "description": description,
      "uploadedBy": {"fullName": authorName, "email": authorEmail},
      "year": year,
      "course": course,
      "submittionDate": submissionDate
    });
    final response = await executeRequest(restRequest);
    return AssignmentModel.fromJson(response.data['data']);
  }

  @override
  Future<AssignmentModel> updateAssignment(
      String assignmentId,
      String title,
      String description,
      String submissionDate,
      int year,
      String course,
      String authorName,
      String authorEmail) async {
    final restRequest =
        createPutRequest(RestResources.getAssingmentById(assignmentId), body: {
      "title": title,
      "description": description,
      "uploadedBy": {"fullName": authorName, "email": authorEmail},
      "year": year,
      "course": course,
      "submittionDate": submissionDate
    });
    final response = await executeRequest(restRequest);
    return AssignmentModel.fromJson(response.data['data']);
  }
}
