class RestResources {
  static String restApiBaseUrl(value) => value
      ? "https://gradease.onrender.com/api/v1/"
      : "http://192.168.0.10:8080/api/v1/";

  static const String studentLogin = "/auth/student";
  static const String adminLogin = "auth/admin";
  static String getStudentDetail(String email) => "student/$email";

// Feed Post API path api/v1/post
  static const String feedPosts = "/post";
  static const String likePost = "$feedPosts/like";
  static const String dislikePost = "$feedPosts/dislike";
  static String deletePost(String id) => "$feedPosts/$id";
  static String getPostById(String id) => "$feedPosts/$id";
  static String getPostReplies(String id) => "$feedPosts/$id/replies";
  static String addReply(String id) => "$feedPosts/$id/replies";
  static String deleteReply(String postId, String replyId) =>
      "$feedPosts/$postId/replies/$replyId";
}
