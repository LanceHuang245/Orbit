import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit/features/connection/data/repositories/local_connection_repository.dart';
import 'package:orbit/features/connection/domain/models/redis_connection.dart';

/// 本地连接仓库提供者
final connectionRepositoryProvider = Provider((ref) => ConnectionRepository());

/// 已保存连接列表的状态管理 Provider (异步)
final savedConnectionsProvider = AsyncNotifierProvider<SavedConnectionsNotifier, List<RedisConnection>>(
  SavedConnectionsNotifier.new,
);

/// 管理已保存连接列表的 Notifier
class SavedConnectionsNotifier extends AsyncNotifier<List<RedisConnection>> {
  
  /// 初始化并加载连接
  @override
  Future<List<RedisConnection>> build() async {
    return _loadConnections();
  }

  /// 内部方法：加载连接
  Future<List<RedisConnection>> _loadConnections() {
    final repository = ref.read(connectionRepositoryProvider);
    return repository.loadConnections();
  }

  /// 添加新连接
  Future<void> addConnection(RedisConnection connection) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(connectionRepositoryProvider);
      await repository.addConnection(connection);
      return _loadConnections();
    });
  }
  
  /// 删除连接
  Future<void> removeConnection(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(connectionRepositoryProvider);
      await repository.removeConnection(id);
      return _loadConnections();
    });
  }

  /// 更新连接
  Future<void> updateConnection(RedisConnection connection) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(connectionRepositoryProvider);
      await repository.updateConnection(connection);
      return _loadConnections();
    });
  }
}