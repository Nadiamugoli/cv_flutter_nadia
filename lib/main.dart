import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const NadiaCvApp());
}

class NadiaCvApp extends StatelessWidget {
  const NadiaCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6554C0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV de ABANABO MUGOLI Nadia',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6FC),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // Sur l'émulateur ou un vrai téléphone Android, l'application occupe
      // tout l'écran. Sur un écran large (Chrome, tablette), elle reste
      // centrée avec une largeur de téléphone, sans rien qui dépasse.
      builder: (context, child) {
        return ColoredBox(
          color: const Color(0xFFE9E6F5),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        );
      },
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final id = _idController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (id == 'nadia' && password == '1234') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      setState(() {
        _error = 'Identifiant ou mot de passe incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Center(
                    child: _ProfilePhoto(
                      asset: 'assets/images/nadia.jpg',
                      initials: 'NAM',
                      size: 120,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Bienvenue !',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF29243D),
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connectez-vous pour découvrir mon CV et mon univers.',
                    style: TextStyle(color: Color(0xFF777386), height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  const _FieldLabel('Identifiant'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      'Entrez votre identifiant',
                      Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _FieldLabel('Mot de passe'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    onSubmitted: (_) => _login(),
                    decoration: _inputDecoration(
                      'Entrez votre mot de passe',
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(_hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _login,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Se connecter',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Application personnelle • CV de ABANABO MUGOLI Nadia',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF9994A8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFEAE7F2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF6554C0), width: 1.5),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF373247),
        ),
      );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  late final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    CvPage(),
    FamilyPage(),
    ContactPage(),
  ];

  final List<String> _titles = const [
    'Mon CV',
    'Ma famille',
    'Contact',
  ];

  void _selectPage(int index) {
    setState(() => _index = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index],
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          Navigator.pop(context);
          _selectPage(index);
        },
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
            child: Text('ABANABO MUGOLI Nadia',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Color(0xFF6554C0))),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: Text('Mon CV'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: Text('Ma famille'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.contact_mail_outlined),
            selectedIcon: Icon(Icons.contact_mail),
            label: Text('Contact'),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _index = index),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            selectedIcon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const _ProfilePhoto(
                  asset: 'assets/images/nadia.jpg',
                  initials: 'NAM',
                  size: 116,
                ),
                const SizedBox(height: 16),
                const Text(
                  'ABANABO MUGOLI Nadia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                    color: Color(0xFF29243D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Étudiante en informatique appliquée à la gestion des entreprises',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6554C0),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Étudiante motivée, curieuse et intéressée par les technologies numériques, la programmation et la création de solutions informatiques utiles à la gestion des activités.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.55, color: Color(0xFF777386)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Formation', Icons.school_outlined),
        const _InfoCard(
          title: 'Informatique appliquée à la gestion des entreprises',
          subtitle: 'Institut Supérieur d’Informatique et de Gestion (ISIG) • Goma',
          details: 'Études supérieures en cours',
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Expériences', Icons.work_outline),
        const _InfoCard(
          title: 'Stage académique — Afrix Global',
          subtitle: 'Stage académique',
          details:
              'Participation aux activités de stage et découverte du fonctionnement professionnel. Expérience réalisée dans le cadre de la formation.',
        ),
        const _InfoCard(
          title: 'Participation à la boutique familiale',
          subtitle: 'Expérience pratique',
          details:
              'Découverte de la gestion quotidienne d’une activité commerciale et intérêt pour l’amélioration de son organisation.',
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Projets et objectifs', Icons.lightbulb_outline),
        const _InfoCard(
          title: 'Créer ma propre boutique',
          subtitle: 'Projet personnel',
          details:
              'Développer une boutique et mettre en pratique mes connaissances en informatique pour informatiser la gestion, le suivi des produits et les activités commerciales.',
        ),
        const _InfoCard(
          title: 'Apprendre et développer des applications',
          subtitle: 'Projet d’apprentissage',
          details:
              'Continuer à progresser en programmation et apprendre à concevoir des applications adaptées à des besoins réels.',
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Compétences techniques', Icons.computer_outlined),
        const _InfoCard(
          title: 'Notions et apprentissage en programmation',
          subtitle: 'C# • JavaScript • HTML • CSS',
          details:
              'Connaissances en cours de développement. Intérêt pour la programmation, le développement web et les applications avec Flutter.',
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Langues', Icons.language_outlined),
        const _InfoCard(
          title: 'Français: Experte • Anglais: Courant • Espagnol: Initiation • Swahili: courant',
          subtitle: 'Profil quadrilingue',
          details:
              'Langues pratiquées.',
        ),
        const SizedBox(height: 18),
        const _SectionTitle('Centres d’intérêt', Icons.favorite_border),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _InterestChip('Informatique'),
            _InterestChip('Programmation'),
            _InterestChip('Bricolage'),
            _InterestChip('Jeux vidéo'),
            _InterestChip('Entrepreneuriat'),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'CV personnel • ABANABO MUGOLI Nadia',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF9994A8), fontSize: 12),
        ),
      ],
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final String asset;
  final String initials;

  const FamilyMember(this.name, this.relation, this.asset, this.initials);
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const parents = [
    FamilyMember('Jeanson Abanabo', 'Père', 'assets/images/jeanson.jpg', 'JE'),
    FamilyMember('Anuarite Bengehia Abamwezi', 'Mère',
        'assets/images/anuarite.jpg', 'AN'),
  ];

  static const children = [
    FamilyMember('Lydia Abanabo', 'Grande sœur', 'assets/images/lydia.jpg', 'LA'),
    FamilyMember('Claudia Abanabo', 'Sœur', 'assets/images/claudia.jpg', 'CA'),
    FamilyMember('Nadia Abanabo', 'Moi', 'assets/images/nadia.jpg', 'NA'),
    FamilyMember('Johny Abanabo', 'Frère', 'assets/images/johny.jpg', 'JH'),
    FamilyMember('Jonathan Abanabo', 'Frère', 'assets/images/jonathan.jpg', 'JA'),
    FamilyMember('Joachim Abanabo', 'Frère', 'assets/images/joachim.jpg', 'JA'),
  ];

  static const cousin =
      FamilyMember('Dorcas Bahati', 'Cousine', 'assets/images/dorcas.jpg', 'DB');

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        const Text(

          'Ma famille',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF29243D)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Les personnes qui occupent une place importante dans ma vie.',
          style: TextStyle(color: Color(0xFF777386), height: 1.4),
        ),
        const SizedBox(height: 22),
        const _SectionTitle('Mes parents', Icons.diversity_1_outlined),
        ...parents.map((member) => _FamilyCard(member: member)),
        const SizedBox(height: 18),
        const _SectionTitle('Les enfants de la famille', Icons.family_restroom),
        ...children.map((member) => _FamilyCard(member: member)),
        const SizedBox(height: 18),
        const _SectionTitle('Ma cousine', Icons.people_outline),
        const _FamilyCard(member: cousin),
      ],
    );
  }
}

class _FamilyCard extends StatelessWidget {
  final FamilyMember member;
  const _FamilyCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: _ProfilePhoto(
            asset: member.asset,
            initials: member.initials,
            size: 54,
          ),
          title: Text(member.name,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(member.relation,
              style: const TextStyle(color: Color(0xFF777386))),
          trailing: const Icon(Icons.favorite_outline,
              color: Color(0xFF6554C0)),
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const phone = '+243849473994';
  static const email = 'abanabomugolinadia@gmail.com';
  static const github = 'https://github.com/NadiaMugoli';

  Future<void> _open(BuildContext context, String value) async {
    final uri = Uri.parse(value);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir ce lien sur cet appareil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        const Text(
          'Restons en contact',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF29243D)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Vous pouvez me joindre ou consulter mon profil en utilisant les liens ci-dessous.',
          style: TextStyle(color: Color(0xFF777386), height: 1.5),
        ),
        const SizedBox(height: 22),
        _ContactTile(
          icon: Icons.phone,
          title: 'Téléphone',
          value: '+243 84 94 73 994',
          onTap: () => _open(context, 'tel:$phone'),
        ),
        const SizedBox(height: 12),
        _ContactTile(
          icon: Icons.email_outlined,
          title: 'Adresse e-mail',
          value: email,
          onTap: () => _open(context, 'mailto:$email'),
        ),
        const SizedBox(height: 12),
        _ContactTile(
          imageAsset: 'assets/images/github.png',
          title: 'GitHub',
          value: 'NadiaMugoli',
          onTap: () => _open(context, github),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('À propos',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Color(0xFF29243D))),
                SizedBox(height: 8),
                Text(
                  'Merci de votre visite. Je reste ouverte aux échanges, aux occasions d’apprentissage et aux projets qui me permettront de développer mes compétences.',
                  style: TextStyle(height: 1.55, color: Color(0xFF777386)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    this.icon,
    this.imageAsset,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAE6FF),
          foregroundColor: const Color(0xFF6554C0),
          child: imageAsset != null
              ? Image.asset(imageAsset!, width: 26, height: 26)
              : Icon(icon),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(value),
        trailing: const Icon(Icons.open_in_new_rounded, size: 19),
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  final String asset;
  final String initials;
  final double size;

  const _ProfilePhoto({
    required this.asset,
    required this.initials,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: const Color(0xFFEAE6FF),
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF6554C0),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6554C0)),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF29243D),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String details;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF29243D))),
              const SizedBox(height: 5),
              Text(subtitle,
                  style: const TextStyle(
                      color: Color(0xFF6554C0),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(height: 8),
              Text(details,
                  style: const TextStyle(
                      color: Color(0xFF777386), height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  const _InterestChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFEAE6FF),
      side: BorderSide.none,
      labelStyle: const TextStyle(
        color: Color(0xFF51419F),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
