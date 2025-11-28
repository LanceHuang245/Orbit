import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:orbit/features/connection/presentation/connection_sidebar.dart';
import 'package:orbit/features/editor/presentation/editor_view.dart';
import 'package:orbit/features/explorer/presentation/explorer_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MultiSplitViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MultiSplitViewController(
      areas: [
        Area(
          size: 250,
          min: 200,
          builder: (context, area) => const ConnectionSidebar(),
        ),
        Area(
          size: 300,
          min: 250,
          builder: (context, area) => const ExplorerView(),
        ),
        Area(
          builder: (context, area) => const EditorView(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: 4,
          dividerPainter: DividerPainters.grooved1(
            color: theme.colorScheme.outlineVariant,
            highlightedColor: theme.colorScheme.primary,
          ),
        ),
        child: MultiSplitView(
          controller: _controller,
        ),
      ),
    );
  }
}
