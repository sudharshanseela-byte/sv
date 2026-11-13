import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const OwnAiStudioApp());

class OwnAiStudioApp extends StatelessWidget {
  const OwnAiStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF8067D8);
    return MaterialApp(
      title: 'OwnAI Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101018),
        cardTheme: CardTheme(
          color: const Color(0xFF1C1B27),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1B1A25),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        ),
      ),
      home: const StudioHome(),
    );
  }
}

class StudioScene {
  StudioScene({
    required this.title,
    required this.visual,
    required this.voice,
  });

  String title;
  String visual;
  String voice;
}

class StudioHome extends StatefulWidget {
  const StudioHome({super.key});

  @override
  State<StudioHome> createState() => _StudioHomeState();
}

class _StudioHomeState extends State<StudioHome> {
  final _project = TextEditingController(text: 'My first video');
  final _topic = TextEditingController();
  final List<StudioScene> _scenes = [
    StudioScene(
      title: 'Scene 1 — Powerful hook',
      visual: 'A cinematic opening shot that immediately creates curiosity.',
      voice: 'Open with a surprising question or a bold statement.',
    ),
    StudioScene(
      title: 'Scene 2 — Main message',
      visual: 'Show the central idea using clear, relevant supporting visuals.',
      voice: 'Explain the first key point in simple, engaging language.',
    ),
    StudioScene(
      title: 'Scene 3 — Strong ending',
      visual: 'A memorable closing shot with room for a call to action.',
      voice: 'Summarise the message and invite viewers to follow the channel.',
    ),
  ];

  @override
  void dispose() {
    _project.dispose();
    _topic.dispose();
    super.dispose();
  }

  String _allText() {
    final out = StringBuffer()
      ..writeln(_project.text)
      ..writeln('TOPIC: ${_topic.text}')
      ..writeln();
    for (var i = 0; i < _scenes.length; i++) {
      final s = _scenes[i];
      out
        ..writeln(s.title)
        ..writeln('VISUAL: ${s.visual}')
        ..writeln('VOICE OVER: ${s.voice}')
        ..writeln('BGM: Choose instrumental music to match the emotion.')
        ..writeln('CAMERA: Use a gentle push-in and clean transitions.')
        ..writeln();
    }
    return out.toString();
  }

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied')),
    );
  }

  void _addScene() {
    setState(() {
      _scenes.add(
        StudioScene(
          title: 'Scene ${_scenes.length + 1}',
          visual: 'Describe what viewers should see.',
          voice: 'Write the narration for this scene.',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OwnAI Studio',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'About',
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'OwnAI Studio',
              applicationVersion: '0.1.0',
              applicationLegalese:
                  'Personal video planning workspace. AI generation features are planned.',
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addScene,
        icon: const Icon(Icons.add),
        label: const Text('Add scene'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5942A4), Color(0xFF262044)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR CREATIVE WORKSPACE',
                  style: TextStyle(
                    letterSpacing: 1.4,
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Turn an idea into a video plan.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Plan narration and scene-by-scene visuals in one place.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const _SectionTitle('PROJECT DETAILS'),
          const SizedBox(height: 10),
          TextField(
            controller: _project,
            decoration: const InputDecoration(
              labelText: 'Project name',
              prefixIcon: Icon(Icons.movie_creation_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _topic,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Video topic or idea',
              hintText: 'Example: Chanakya’s 10 rules to earn respect',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionTitle('STORYBOARD'),
              Text(
                '${_scenes.length} scenes',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._scenes.asMap().entries.map(
                (entry) => _SceneCard(
                  key: ValueKey(entry.value),
                  number: entry.key + 1,
                  scene: entry.value,
                  onDelete: () => setState(() => _scenes.remove(entry.value)),
                  onCopy: (text) => _copy(text, 'Scene prompt'),
                ),
              ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _copy(_allText(), 'Complete storyboard'),
            icon: const Icon(Icons.copy_all),
            label: const Text('Copy complete storyboard'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _topic.clear();
              _scenes
                ..clear()
                ..add(
                  StudioScene(
                    title: 'Scene 1 — Hook',
                    visual: 'A striking opening visual.',
                    voice: 'Start with a compelling question.',
                  ),
                );
            }),
            icon: const Icon(Icons.refresh),
            label: const Text('Start a fresh storyboard'),
          ),
          const SizedBox(height: 22),
          const Text(
            'AI script writing, image generation, voice generation and MP4 export are planned for future milestones. They are not active in this first build.',
            style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      );
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    super.key,
    required this.number,
    required this.scene,
    required this.onDelete,
    required this.onCopy,
  });

  final int number;
  final StudioScene scene;
  final VoidCallback onDelete;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  child: Text('$number'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: scene.title,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    onChanged: (value) => scene.title = value,
                  ),
                ),
                IconButton(
                  tooltip: 'Delete scene',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: scene.visual,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Visual prompt',
                alignLabelWithHint: true,
              ),
              onChanged: (value) => scene.visual = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: scene.voice,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Voice-over',
                alignLabelWithHint: true,
              ),
              onChanged: (value) => scene.voice = value,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => onCopy(
                  '${scene.title}\nVISUAL: ${scene.visual}\nVOICE OVER: ${scene.voice}',
                ),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy scene'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
