import 'package:flutter/material.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search keys...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
          ),
        ),
        const Divider(height: 1),
        // Key List
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('key:name:$index'),
                subtitle: const Text('String'),
                leading: const Icon(Icons.vpn_key, size: 18),
                dense: true,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
