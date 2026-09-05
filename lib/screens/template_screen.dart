// Plux — Template screen.
//
// Built per docs/template-screen.md. Exercises every component and pattern
// the design must answer for: type hierarchy, color roles, AppBar,
// NavigationBar, Card, ListTile, Button variants, section headers,
// empty state. One screen, two modes (light/dark), three states.
//
// Render with: `flutter run -d chrome --web-port=8080` then visit
// http://localhost:8080. Toggle the floating action button (top-right) to
// switch between light and dark mode for visual comparison.

import 'package:flutter/material.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  final VoidCallback toggleTheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Plux template'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.brightness_6_outlined,
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: (value) {
              // Placeholder; navigation not implemented for the template.
              debugPrint('Overflow menu: $value');
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download_outlined),
                  title: Text('Export data'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete-all',
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    'Delete all decks',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          // Greeting
          Text(
            'Good evening, Davi',
            style: theme.textTheme.displaySmall?.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '3 cards due for review · 2 journal entries this week',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // Decks section
          Text(
            'DECKS',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ..._decks.map(
            (deck) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DeckCard(
                title: deck.title,
                subtitle: deck.subtitle,
                count: deck.count,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick add
          Text(
            'QUICK ADD',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.style_outlined),
                label: const Text('New deck'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('New card'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.edit_note_outlined),
                label: const Text('New note'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent activity
          Text(
            'RECENT ACTIVITY',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _ActivityRow(
                  icon: Icons.check_circle_outline,
                  title: 'Reviewed 12 cards in "Spanish vocab"',
                  subtitle: 'Today · 4 min',
                ),
                const Divider(height: 1),
                _ActivityRow(
                  icon: Icons.edit_note_outlined,
                  title: 'Journal entry: "Coffee with Marina"',
                  subtitle: 'Yesterday',
                ),
                const Divider(height: 1),
                _ActivityRow(
                  icon: Icons.bookmark_added_outlined,
                  title: 'Added note: "Spaced repetition primer"',
                  subtitle: '2 days ago',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Review CTA
          Text(
            'REVIEW',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start review'),
            ),
          ),

          const SizedBox(height: 32),

          // Empty state — demonstrates the empty pattern
          Text(
            'EMPTY STATE EXAMPLE',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.style_outlined,
                    size: 48,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No decks yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create your first deck to start learning.\nDecDecks group cards by topic — try "Spanish vocab" or "Capital cities".',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create deck'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Decks',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  static final _decks = [
    _DeckData(
      title: 'Spanish vocab',
      subtitle: 'Last reviewed 2 days ago',
      count: 12,
    ),
    _DeckData(
      title: 'Capital cities',
      subtitle: 'Last reviewed yesterday',
      count: 5,
    ),
    _DeckData(
      title: 'Rust ownership',
      subtitle: 'New deck',
      count: 24,
    ),
  ];
}

class _DeckData {
  _DeckData({
    required this.title,
    required this.subtitle,
    required this.count,
  });

  final String title;
  final String subtitle;
  final int count;
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({
    required this.title,
    required this.subtitle,
    required this.count,
  });

  final String title;
  final String subtitle;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: const Icon(Icons.style_outlined),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$count',
              style: theme.textTheme.titleLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count == 1 ? 'card' : 'cards',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}