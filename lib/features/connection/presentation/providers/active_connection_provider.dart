import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit/features/connection/data/datasources/redis_service.dart';
import 'package:orbit/features/connection/domain/models/redis_connection.dart';

/// Redis 服务实例提供者
final redisServiceProvider = Provider((ref) => RedisService());

/// 当前活跃连接的状态管理 (是否已连接，连接的哪个 Redis)
final activeConnectionProvider = AsyncNotifierProvider<ActiveConnectionNotifier, RedisConnection?>(
  ActiveConnectionNotifier.new,
);

/// 管理活跃连接状态的 Notifier
class ActiveConnectionNotifier extends AsyncNotifier<RedisConnection?> {
  
  @override
  Future<RedisConnection?> build() async {
    // 初始状态无连接
    return null;
  }

  /// 发起连接
  Future<void> connect(RedisConnection connection) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(redisServiceProvider);
      await service.connect(connection);
      return connection; // 返回当前连接对象表示成功
    });
  }

  /// 断开连接
  Future<void> disconnect() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(redisServiceProvider);
      await service.disconnect();
      return null; // 返回 null 表示无连接
    });
  }
}