import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/profile/presentation/widgets/profile_tab.dart';
import 'package:math_trainer_app/features/topics/presentation/widgets/topics_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.initialIndex = 0, super.key});

  final int initialIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _index = widget.initialIndex <= 0 ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: switch (_index) {
        0 => const TopicsTab(),
        _ => const ProfileTab(),
      },
      bottomNavigationBar: NavigationBar(
        backgroundColor: colors.surface,
        indicatorColor: colors.accent.withValues(alpha: 0.24),
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.topicsTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profileTab,
          ),
        ],
      ),
    );
  }
}
