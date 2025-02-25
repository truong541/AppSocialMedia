import 'package:socialnetwork/services/api_service.dart';

class PostService {
  Future<List<dynamic>> showListPost() async {
    final endpoint = ApiEndpoints.listPost;
    final response =
        await ApiService().request(endpoint: endpoint, method: 'GET');
    return response ?? [];
  }

  Future<List<dynamic>> showListPostByUser(int idUser) async {
    final endpoint =
        ApiEndpoints.listPostByUser.replaceFirst('{id}', idUser.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: 'GET');
    return response ?? [];
  }
}
