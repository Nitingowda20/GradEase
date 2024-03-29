import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import StudentModel from "../models/studentModel.js";
import ResponseError from "../utils/RestResponseError.js";

export async function loginStudent(email, password) {
  const existingStudent = await StudentModel.findOne({ email });

  if (!existingStudent) {
    throw new ResponseError(404, "Invalid email, email is not registered");
  }

  const isPasswordCorrect = await bcrypt.compare(
    password,
    existingStudent.password
  );

  if (!isPasswordCorrect) {
    throw new ResponseError(
      404,
      "Invalid password, please enter the correct password"
    );
  }

  const tokenObject = {
    _id: existingStudent._id,
    fullName: existingStudent.fullName,
    email: existingStudent.email,
  };

  const jwtToken = jwt.sign(tokenObject, process.env.JWT_STUDENT_SECRET, {
    expiresIn: "12h",
  });

  return jwtToken;
}

export async function registerStudent(studentModel) {
  const existingStudent = await StudentModel.findOne({
    email: studentModel.email,
  });

  if (existingStudent) {
    throw new ResponseError(
      404,
      "Student already exists with this email address"
    );
  }

  studentModel.password = await bcrypt.hash(studentModel.password, 10);
  const response = await studentModel.save();
  response.password = undefined;
  return response;
}

export async function getStudentByEmail(email) {
  const studentDetail = await StudentModel.findOne({ email }, { password: 0 });
  if (!studentDetail) {
    throw new ResponseError(404, "Invalid email, Student not found");
  }
  return studentDetail;
}

export async function getAllStudentsDetails() {
  const studentDetail = await StudentModel.find({}, { password: 0 });
  if (!studentDetail) {
    throw new ResponseError(404, "No data found");
  }
  return studentDetail;
}

export async function updateStudentDetail(email, updatedData) {
  const updatedStudent = await StudentModel.findOneAndUpdate(
    { email },
    updatedData,
    { new: true }
  );

  if (!updatedStudent) {
    throw new ResponseError(404, "Invalid email, Student not found");
  }

  return updatedStudent;
}
