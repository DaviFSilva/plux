// Plux — Stress-test screen.
//
// One screen that exercises every component the Plux design must answer
// for. See docs/plux-direction.md for the spec. Live at /?theme=plux.
//
// Layout (top to bottom, scrollable):
//   1. Top app bar with title, 3 action buttons, overflow menu
//   2. Hero: greeting + 4 stat cards with sparkline-style indicators
//   3. Metaball nav demo: chip row showing the active-filter effect
//   4. Form section: text fields, dropdown, slider, segmented control
//   5. Data section: line chart + bar chart + data table
//   6. List section: mixed rows (avatar, badge, progress)
//   7. Grid section: image-tile placeholders
//   8. Feedback: snackbar trigger, skeleton loader, empty state
//   9. Modal trigger buttons (bottom sheet + dialog)
//
// All cards use LiquidCard. All buttons use LiquidButton. Charts use
// fl_chart. Tabs/segmented use Material 3 widgets but themed.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../widgets/liquid.dart';

class StressTestScreen extends StatefulWidget {
  const StressTestScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  final bool isDark;
  final VoidCallback toggleTheme;

  @override
  State<StressTestScreen> createState() => _StressTestScreenState();
}

class _StressTestScreenState extends State<StressTestScreen> {
  int _selectedNav = 0;
  String? _activeFilter;
  bool _loading = false;
  bool _skeleton = false;

  void _showSnackbar(String message, {bool isError = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: scheme.onPrimary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor:
            isError ? scheme.errorContainer : scheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Bottom sheet',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This is a bottom sheet with a drag handle, rounded top, '
              'and the Plux surface color.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: LiquidButton(
                label: 'Done',
                onPressed: () => Navigator.pop(ctx),
                primary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialog() async {
    final scheme = Theme.of(context).colorScheme;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: scheme.surface,
        title: Text('Confirm', style: Theme.of(ctx).textTheme.titleLarge),
        content: Text(
          'This is a Plux-themed dialog. Buttons below use the liquid '
          'interaction primitive.',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        actions: [
          LiquidButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(ctx),
          ),
          const SizedBox(width: 8),
          LiquidButton(
            label: 'Confirm',
            primary: true,
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackbar('Action confirmed');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plux · Stress test'),
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Light mode' : 'Dark mode',
            onPressed: widget.toggleTheme,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_outlined
                  : Icons.brightness_6_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => _showSnackbar('Refreshed'),
            icon: const Icon(Icons.refresh_outlined),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showSnackbar('No new notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () => _showSnackbar('Search is mocked'),
            icon: const Icon(Icons.search_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: (v) => _showSnackbar('Menu: $v'),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'help', child: Text('Help')),
              const PopupMenuItem(value: 'about', child: Text('About Plux')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
        children: [
          _section(
            'HERO',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Davi',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '3 cards due for review · 2 journal entries this week',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                _statsGrid(context),
              ],
            ),
          ),
          _section(
            'METABALL NAV (active filter chips)',
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final f in ['All', 'Learning', 'Life log', 'Notes', 'Archive'])
                  _FilterChip(
                    label: f,
                    active: _activeFilter == f,
                    onTap: () => setState(
                      () => _activeFilter = _activeFilter == f ? null : f,
                    ),
                  ),
              ],
            ),
          ),
          _section(
            'FORM CONTROLS',
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Deck name',
                    helperText: 'A short name for this deck',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: 'English',
                  decoration: InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                    DropdownMenuItem(value: 'Portuguese', child: Text('Portuguese')),
                    DropdownMenuItem(value: 'Japanese', child: Text('Japanese')),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Cards per day:'),
                    Expanded(
                      child: Slider(
                        value: 20,
                        min: 5,
                        max: 100,
                        divisions: 19,
                        label: '20',
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Light')),
                    ButtonSegment(value: 1, label: Text('Medium')),
                    ButtonSegment(value: 2, label: Text('Heavy')),
                  ],
                  selected: const {1},
                  onSelectionChanged: (_) {},
                ),
              ],
            ),
          ),
          _section(
            'CHARTS',
            Column(
              children: [
                LiquidCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cards reviewed (7 days)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: LineChart(_lineChartData()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                LiquidCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Retention by week',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: BarChart(_barChartData()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _section(
            'DATA TABLE',
            LiquidCard(
              child: Column(
                children: [
                  _tableHeader(context),
                  const Divider(height: 1),
                  _tableRow(context, 'Spanish vocab', '12 cards', '92%'),
                  const Divider(height: 1),
                  _tableRow(context, 'Capital cities', '5 cards', '85%'),
                  const Divider(height: 1),
                  _tableRow(context, 'Rust ownership', '24 cards', '71%'),
                  const Divider(height: 1),
                  _tableRow(context, 'Kanji radicals', '30 cards', '64%'),
                ],
              ),
            ),
          ),
          _section(
            'LIST',
            LiquidCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _listRow(
                    context,
                    avatar: 'D',
                    title: 'Reviewed 12 cards in "Spanish vocab"',
                    subtitle: 'Today · 4 min',
                  ),
                  const Divider(height: 1),
                  _listRow(
                    context,
                    avatar: 'M',
                    title: 'Journal entry: "Coffee with Marina"',
                    subtitle: 'Yesterday',
                    badge: 'New',
                  ),
                  const Divider(height: 1),
                  _listRow(
                    context,
                    avatar: '·',
                    title: 'Added note: "Spaced repetition primer"',
                    subtitle: '2 days ago',
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reading progress',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.65,
                          borderRadius: BorderRadius.circular(8),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '65% of "Capital cities" deck',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _section(
            'GRID',
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                for (final c in [
                  ('History', Icons.history_edu_outlined),
                  ('Languages', Icons.translate_outlined),
                  ('Code', Icons.code_outlined),
                  ('Music', Icons.music_note_outlined),
                  ('Cooking', Icons.restaurant_outlined),
                  ('Science', Icons.science_outlined),
                ])
                  _gridTile(context, label: c.$1, icon: c.$2),
              ],
            ),
          ),
          _section(
            'FEEDBACK',
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                LiquidButton(
                  label: 'Show snackbar',
                  primary: true,
                  icon: Icons.notifications_outlined,
                  onPressed: () => _showSnackbar('Saved successfully'),
                ),
                LiquidButton(
                  label: 'Show error',
                  icon: Icons.error_outline,
                  onPressed: () =>
                      _showSnackbar('Something went wrong', isError: true),
                ),
                LiquidButton(
                  label: _loading ? 'Loading…' : 'Toggle loader',
                  icon: Icons.hourglass_empty_outlined,
                  onPressed: () => setState(() => _loading = !_loading),
                ),
                LiquidButton(
                  label: _skeleton ? 'Hide skeleton' : 'Show skeleton',
                  icon: Icons.view_agenda_outlined,
                  onPressed: () => setState(() => _skeleton = !_skeleton),
                ),
              ],
            ),
          ),
          if (_loading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_skeleton) ...[
            const SizedBox(height: 16),
            _skeletonCard(context),
            const SizedBox(height: 12),
            _skeletonCard(context),
          ],
          _section(
            'EMPTY STATE',
            LiquidCard(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No archive items',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Archived decks appear here when you finish them.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          _section(
            'MODALS',
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                LiquidButton(
                  label: 'Open bottom sheet',
                  icon: Icons.open_in_full_outlined,
                  onPressed: _openBottomSheet,
                ),
                LiquidButton(
                  label: 'Open dialog',
                  icon: Icons.chat_bubble_outline,
                  onPressed: _openDialog,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNav,
        onDestinationSelected: (i) => setState(() => _selectedNav = i),
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
            icon: Icon(Icons.note_add_outlined),
            selectedIcon: Icon(Icons.note_add),
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

  Widget _section(String label, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 1.4,
                  ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  Widget _statsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _statCard(context, label: 'Decks', value: '8', delta: '+2 this month'),
        _statCard(context, label: 'Cards', value: '142', delta: '+24 today'),
        _statCard(context, label: 'Streak', value: '12d', delta: 'Best: 28d'),
        _statCard(context, label: 'Journal', value: '47', delta: '+2 this week'),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String label,
    required String value,
    required String delta,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            delta,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Deck', style: style)),
          Expanded(flex: 2, child: Text('Cards', style: style)),
          Expanded(flex: 2, child: Text('Retention', style: style)),
        ],
      ),
    );
  }

  Widget _tableRow(
    BuildContext context,
    String name,
    String cards,
    String retention,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            flex: 2,
            child: Text(
              cards,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              retention,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listRow(
    BuildContext context, {
    required String avatar,
    required String title,
    required String subtitle,
    String? badge,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Text(avatar),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onTertiaryContainer,
                    ),
              ),
            )
          : null,
    );
  }

  Widget _gridTile(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidCard(
      padding: const EdgeInsets.all(12),
      onTap: () => _showSnackbar('Tapped $label'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: scheme.primary),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _skeletonCard(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surface;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1200),
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  LineChartData _lineChartData() {
    final scheme = Theme.of(context).colorScheme;
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: scheme.primary,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          spots: const [
            FlSpot(0, 8),
            FlSpot(1, 14),
            FlSpot(2, 10),
            FlSpot(3, 18),
            FlSpot(4, 16),
            FlSpot(5, 22),
            FlSpot(6, 28),
          ],
        ),
      ],
    );
  }

  BarChartData _barChartData() {
    final scheme = Theme.of(context).colorScheme;
    return BarChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: [
        for (var i = 0; i < 5; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: (i + 1) * 20.0,
                color: scheme.secondaryContainer,
                width: 18,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Filter chip with the metaball effect: when active, renders a bigger
/// pill that visually merges with adjacent active chips (the "goo" look).
///
/// We can't apply an SVG gooey filter to Flutter widgets directly, so
/// the visual is approximated: the active chip gets a noticeably larger
/// border-radius and a tonal background, suggesting the same "fluid"
/// character without the actual metaball.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: active ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(active ? 24 : 16),
        border: Border.all(
          color: active ? scheme.primary : scheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(active ? 24 : 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: active ? scheme.onPrimary : scheme.onSurface,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}