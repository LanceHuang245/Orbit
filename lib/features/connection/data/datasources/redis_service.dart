import 'package:redis/redis.dart' as redis_pkg;
import 'package:orbit/features/connection/domain/models/redis_connection.dart';

/// Redis 服务类，负责处理底层的 Redis 连接和命令执行
class RedisService {
  RedisConnection? _currentConfig;
  redis_pkg.Command? _command;
  redis_pkg.RedisConnection? _connection;

  /// 获取当前连接配置
  RedisConnection? get currentConfig => _currentConfig;
  /// 检查是否已连接
  bool get isConnected => _command != null;

  /// 建立 Redis 连接
  Future<void> connect(RedisConnection config) async {
    // 先断开旧连接
    await disconnect();

    final connection = redis_pkg.RedisConnection();
    try {
      // 尝试连接 Host:Port
      final command = await connection.connect(config.host, config.port);
      
      // 处理 AUTH 认证
      if (config.password != null && config.password!.isNotEmpty) {
        if (config.username != null && config.username!.isNotEmpty) {
          // Redis 6.0+ ACL 认证
          await command.send_object(['AUTH', config.username, config.password]);
        } else {
          // 传统密码认证
          await command.send_object(['AUTH', config.password]);
        }
      }

      // 切换数据库
      if (config.db != 0) {
        await command.send_object(['SELECT', config.db]);
      }

      _connection = connection;
      _command = command;
      _currentConfig = config;
    } catch (e) {
      // 连接失败时清理资源
      try {
        connection.close();
      } catch (_) {}
      throw Exception('Failed to connect to ${config.host}:${config.port}. Error: $e');
    }
  }

  /// 断开当前连接
  Future<void> disconnect() async {
    if (_connection != null) {
      try {
         _connection!.close();
      } catch (e) {
        // 忽略断开连接时的错误
      }
      _connection = null;
      _command = null;
      _currentConfig = null;
    }
  }

  /// 执行 Redis 命令
  Future<dynamic> execute(List<dynamic> args) async {
    if (_command == null) {
      throw Exception('Not connected');
    }
    return await _command!.send_object(args);
  }
}