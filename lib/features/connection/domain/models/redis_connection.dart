import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Redis 连接配置模型
class RedisConnection {
  /// 唯一标识符，创建时自动生成
  final String id;
  /// 连接名称 (显示用)
  final String name;
  /// 主机地址 (如 127.0.0.1)
  final String host;
  /// 端口号 (默认 6379)
  final int port;
  /// 密码 (可选)
  final String? password;
  /// 用户名 (Redis ACL 认证用，可选)
  final String? username;
  /// 默认数据库索引 (默认 0)
  final int db;

  RedisConnection({
    String? id,
    required this.name,
    required this.host,
    this.port = 6379,
    this.password,
    this.username,
    this.db = 0,
  }) : id = id ?? const Uuid().v4();

  RedisConnection copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? password,
    String? username,
    int? db,
  }) {
    return RedisConnection(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      password: password ?? this.password,
      username: username ?? this.username,
      db: db ?? this.db,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'password': password,
      'username': username,
      'db': db,
    };
  }

  factory RedisConnection.fromMap(Map<String, dynamic> map) {
    return RedisConnection(
      id: map['id'] as String,
      name: map['name'] as String,
      host: map['host'] as String,
      port: map['port'] as int,
      password: map['password'] as String?,
      username: map['username'] as String?,
      db: map['db'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RedisConnection.fromJson(String source) =>
      RedisConnection.fromMap(json.decode(source) as Map<String, dynamic>);
  
  @override
  String toString() => '$name ($host:$port)';
}
