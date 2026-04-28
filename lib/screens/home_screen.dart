import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../l10n/app_strings.dart';
import '../l10n/locale_provider.dart';
import '../theme/theme_provider.dart';
import '../models/group.dart';
import 'add_word_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() async {
    groups = await DatabaseHelper.instance.getGroups();
    setState(() {});
  }

  void _addGroup(AppStrings s) async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.newGroup),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: s.groupName,
            hintText: s.groupNameHint,
          ),
        ),
        actions: [
          TextButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton(
            child: Text(s.save),
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.insertGroup(
                  Group(name: nameController.text.trim()),
                );
                _loadGroups();
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _editGroup(Group group, AppStrings s) {
    final controller = TextEditingController(text: group.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.editGroup),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: s.groupName),
        ),
        actions: [
          TextButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton(
            child: Text(s.save),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.updateGroup(
                  Group(id: group.id, name: controller.text.trim()),
                );
                _loadGroups();
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deleteGroup(Group group, AppStrings s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.deleteGroupTitle),
        content: Text(s.deleteGroupMessage(group.name)),
        actions: [
          TextButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: Text(s.delete),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.deleteGroup(group.id!);
      _loadGroups();
    }
  }

  void _showLanguagePicker(BuildContext context, AppStrings s) {
    final provider = context.read<LocaleProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                s.chooseLanguage,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _LangTile(
              flag: '🇺🇿',
              label: "O'zbek",
              locale: AppLocale.uz,
              current: provider.locale,
              onTap: () {
                provider.setLocale(AppLocale.uz);
                Navigator.pop(context);
              },
            ),
            _LangTile(
              flag: '🇷🇺',
              label: 'Русский',
              locale: AppLocale.ru,
              current: provider.locale,
              onTap: () {
                provider.setLocale(AppLocale.ru);
                Navigator.pop(context);
              },
            ),
            _LangTile(
              flag: '🇬🇧',
              label: 'English',
              locale: AppLocale.en,
              current: provider.locale,
              onTap: () {
                provider.setLocale(AppLocale.en);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLowest,
        title: Text(
          s.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(themeProvider.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
              tooltip:
                  themeProvider.isDark ? s.lightMode : s.darkMode,
              onPressed: themeProvider.toggle,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: s.language,
            onPressed: () => _showLanguagePicker(context, s),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: groups.isEmpty
          ? _buildEmptyState(context, s)
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return _GroupCard(
                  group: groups[index],
                  s: s,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddWordScreen(group: groups[index]),
                    ),
                  ).then((_) => _loadGroups()),
                  onTest: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestScreen(group: groups[index]),
                    ),
                  ),
                  onEdit: () => _editGroup(groups[index], s),
                  onDelete: () => _deleteGroup(groups[index], s),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addGroup(s),
        icon: const Icon(Icons.add),
        label: Text(s.addGroup),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppStrings s) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 52,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              s.noGroups,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              s.noGroupsDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _addGroup(s),
              icon: const Icon(Icons.add),
              label: Text(s.addGroup),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final AppStrings s;
  final VoidCallback onTap;
  final VoidCallback onTest;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupCard({
    required this.group,
    required this.s,
    required this.onTap,
    required this.onTest,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.play_circle_rounded,
                    color: colorScheme.tertiary, size: 28),
                tooltip: s.test,
                onPressed: onTest,
              ),
              IconButton(
                icon: Icon(Icons.edit_rounded,
                    color: colorScheme.primary, size: 22),
                tooltip: s.edit,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded,
                    color: Colors.redAccent, size: 22),
                tooltip: s.delete,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String flag;
  final String label;
  final AppLocale locale;
  final AppLocale current;
  final VoidCallback onTap;

  const _LangTile({
    required this.flag,
    required this.label,
    required this.locale,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = locale == current;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 26)),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.5) : null,
      onTap: onTap,
    );
  }
}
