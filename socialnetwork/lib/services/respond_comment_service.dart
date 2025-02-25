import 'package:socialnetwork/services/api_service.dart';

class RespondCommentService {
  Future<bool> createRespondComment(
      int idPost, int idComment, Map<String, dynamic>? body) async {
    String endpoint = ApiEndpoints.createRespondComment
        .replaceFirst('{id1}', idPost.toString())
        .replaceFirst('{id2}', idComment.toString());

    final response = await ApiService()
        .request(endpoint: endpoint, method: 'POST', body: body);

    return response;
  }

  // Future<List<String, dynamic>> listRespondComment(int idComment) async {
  //   String endpoint = ApiEndpoints.listRespondComment
  //       .replaceFirst('{id}', idComment.toString());
  //   final response =
  //       await ApiService().request(endpoint: endpoint, method: 'GET');

  // }
}
