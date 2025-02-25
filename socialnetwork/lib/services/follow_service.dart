import 'package:socialnetwork/models/user.dart';
import 'package:socialnetwork/services/api_service.dart';

class FollowService {
  //Hiện danh sách user chưa follow của user hiện tại
  Future<List<UserModel>> listUnfollowUser(int idUser) async {
    String endpoint =
        ApiEndpoints.listUnfollowedUser.replaceFirst("{id}", idUser.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: "GET");
    if (response is List) {
      // return List<Map<String, dynamic>>.from(response);
      return response.map((e) => UserModel.fromJson(e)).toList();
    }

    return [];
  }

  //Hiện trạng thái follow (true or false)
  Future<bool> followStatus(int idUser) async {
    String endpoint =
        ApiEndpoints.followStatus.replaceFirst("{id}", idUser.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: "GET");
    if (response != null && response is Map<String, dynamic>) {
      return response['is_following'] ?? false;
    }

    return false;
  }

  //Thực hiện follow/unfollow user
  Future<bool> followUser(int idUser) async {
    String endpoint =
        ApiEndpoints.followUser.replaceFirst("{id}", idUser.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: 'POST');
    if (response != null) {
      return response.containsKey("message");
    }
    return false;
  }
}
