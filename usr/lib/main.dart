import 'package:flutter/material.dart';

void main() {
  runApp(const MaintenanceApp());
}

class MaintenanceApp extends StatelessWidget {
  const MaintenanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maintenance Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MaintenanceDashboard(),
      },
    );
  }
}

class MaintenanceItem {
  final String name;
  bool isChecked;
  String? notes;

  MaintenanceItem({required this.name, this.isChecked = false, this.notes});
}

class MaintenanceCategory {
  final String title;
  final IconData icon;
  final List<MaintenanceItem> items;

  MaintenanceCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class MaintenanceDashboard extends StatefulWidget {
  const MaintenanceDashboard({super.key});

  @override
  State<MaintenanceDashboard> createState() => _MaintenanceDashboardState();
}

class _MaintenanceDashboardState extends State<MaintenanceDashboard> {
  late List<MaintenanceCategory> categories;

  @override
  void initState() {
    super.initState();
    categories = [
      MaintenanceCategory(
        title: 'Rooms',
        icon: Icons.bedroom_parent,
        items: [
          MaintenanceItem(name: 'Shampoo bottle bracket paint'),
          MaintenanceItem(name: 'Muslim shower leakage'),
          MaintenanceItem(name: 'Door lock cylinders'),
          MaintenanceItem(name: 'Washroom flush'),
          MaintenanceItem(name: 'Exhaust fans'),
          MaintenanceItem(name: 'Paint touch ups'),
          MaintenanceItem(name: 'Washbasin stand paint'),
        ],
      ),
      MaintenanceCategory(
        title: 'Outside Areas',
        icon: Icons.deck,
        items: [
          MaintenanceItem(name: 'Bulbs'),
          MaintenanceItem(name: 'Holders'),
          MaintenanceItem(name: 'Wires'),
          MaintenanceItem(name: 'Generator service'),
          MaintenanceItem(name: 'Generator oil change'),
        ],
      ),
      MaintenanceCategory(
        title: 'Kitchen',
        icon: Icons.kitchen,
        items: [
          MaintenanceItem(name: 'Stove cleaning'),
          MaintenanceItem(name: 'Apron'),
          MaintenanceItem(name: 'Knife sharpening'),
          MaintenanceItem(name: 'Duster'),
          MaintenanceItem(name: 'Chef hair nets'),
          MaintenanceItem(name: 'Surf'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maintenance Checklist'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: categories.map((cat) {
              return Tab(
                icon: Icon(cat.icon),
                text: cat.title,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((cat) {
            return CategoryListView(
              category: cat,
              onChanged: () => setState(() {}),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryListView extends StatelessWidget {
  final MaintenanceCategory category;
  final VoidCallback onChanged;

  const CategoryListView({
    super.key,
    required this.category,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: category.items.length,
      itemBuilder: (context, index) {
        final item = category.items[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12.0),
          child: CheckboxListTile(
            title: Text(
              item.name,
              style: TextStyle(
                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: item.isChecked,
            onChanged: (bool? value) {
              item.isChecked = value ?? false;
              onChanged();
            },
            secondary: IconButton(
              icon: const Icon(Icons.edit_note),
              onPressed: () {
                _showNotesDialog(context, item);
              },
            ),
          ),
        );
      },
    );
  }

  void _showNotesDialog(BuildContext context, MaintenanceItem item) {
    final textController = TextEditingController(text: item.notes);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notes for ${item.name}'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Add observation or issue details...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                item.notes = textController.text;
                onChanged();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
