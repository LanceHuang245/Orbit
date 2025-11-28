import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit/features/connection/domain/models/redis_connection.dart';
import 'package:orbit/features/connection/presentation/dialogs/add_connection_dialog.dart';
import 'package:orbit/features/connection/presentation/providers/active_connection_provider.dart';
import 'package:orbit/features/connection/presentation/providers/connection_provider.dart';

/// 左侧连接列表侧边栏
class ConnectionSidebar extends ConsumerWidget {
  const ConnectionSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // 监听保存的连接列表
    final connectionsAsync = ref.watch(savedConnectionsProvider);
    // 监听当前活跃连接
    final activeConnectionAsync = ref.watch(activeConnectionProvider);

    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Connections', style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  tooltip: 'Reload',
                  onPressed: () {
                    ref.invalidate(savedConnectionsProvider);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: connectionsAsync.when(
              data: (connections) {
                if (connections.isEmpty) {
                  return Center(
                    child: Text(
                      'No connections',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: connections.length,
                  itemBuilder: (context, index) {
                    final connection = connections[index];
                    final isActive =
                        activeConnectionAsync.value?.id == connection.id;

                    return ListTile(
                      leading: Icon(
                        Icons.storage,
                        color: isActive ? theme.colorScheme.primary : null,
                      ),
                      title: Text(
                        connection.name,
                        style: TextStyle(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive ? theme.colorScheme.primary : null,
                        ),
                      ),
                      subtitle: Text('${connection.host}:${connection.port}'),
                      dense: true,
                      selected: isActive,
                      selectedTileColor: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.2),
                      onTap: () {
                        ref
                            .read(activeConnectionProvider.notifier)
                            .connect(connection);
                      },
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit'),
                            onTap: () {
                              // TODO: Implement Edit Dialog
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text('Delete'),
                            onTap: () {
                              ref
                                  .read(savedConnectionsProvider.notifier)
                                  .removeConnection(connection.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          if (activeConnectionAsync.isLoading) const LinearProgressIndicator(),
          if (activeConnectionAsync.hasError)
            Container(
              padding: const EdgeInsets.all(8),
              color: theme.colorScheme.errorContainer,
              child: Text(
                'Connection Error: ${activeConnectionAsync.error}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final newConnection = await showDialog<RedisConnection>(
                    context: context,
                    builder: (context) => const AddConnectionDialog(),
                  );

                  if (newConnection != null) {
                    ref
                        .read(savedConnectionsProvider.notifier)
                        .addConnection(newConnection);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('New Connection'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
