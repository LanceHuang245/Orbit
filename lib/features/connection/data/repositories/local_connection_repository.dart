import 'package:shared_preferences/shared_preferences.dart';
import 'package:orbit/features/connection/domain/models/redis_connection.dart';

/// 本地连接存储仓库 (基于 SharedPreferences)
class ConnectionRepository {
  static const String _storageKey = 'saved_connections';

  /// 加载所有已保存的连接
  Future<List<RedisConnection>> loadConnections() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey);

    if (jsonList == null) return [];

    return jsonList
        .map((jsonStr) => RedisConnection.fromJson(jsonStr))
        .toList();
  }

  /// 保存连接列表到本地
  Future<void> saveConnections(List<RedisConnection> connections) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = connections.map((conn) => conn.toJson()).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  /// 添加新连接
  Future<void> addConnection(RedisConnection connection) async {
    final connections = await loadConnections();
    connections.add(connection);
    await saveConnections(connections);
  }

  /// 根据 ID 删除连接
  Future<void> removeConnection(String id) async {
    final connections = await loadConnections();
    connections.removeWhere((conn) => conn.id == id);
    await saveConnections(connections);
  }

  /// 更新现有连接信息
  Future<void> updateConnection(RedisConnection updatedConnection) async {
    final connections = await loadConnections();
    final index = connections.indexWhere((c) => c.id == updatedConnection.id);
    if (index != -1) {
      connections[index] = updatedConnection;
      await saveConnections(connections);
    }
  }
}
