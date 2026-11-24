import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services/api_service.dart';

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
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _idController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Saisissez votre e-mail et votre mot de passe.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ApiService.seConnecter(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
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
                  const _FieldLabel('Adresse e-mail'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      'Entrez votre adresse e-mail',
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
                    onPressed: _loading ? null : _login,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Se connecter',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            final email = await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()),
                            );
                            if (email != null && mounted) {
                              _idController.text = email;
                              _passwordController.clear();
                              setState(() => _error = null);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Compte créé. Vous pouvez vous connecter.')),
                              );
                            }
                          },
                    child: const Text('Pas de compte ? Créer un compte'),
                  ),
                  const SizedBox(height: 12),
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _email.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = 'Saisissez une adresse e-mail valide.');
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _error = 'Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Les mots de passe ne correspondent pas.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ApiService.sInscrire(email, _password.text);
      if (!mounted) return;
      Navigator.of(context).pop(email);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _FieldLabel('Adresse e-mail'),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                      'Entrez votre adresse e-mail', Icons.email_outlined),
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Mot de passe'),
                TextField(
                  controller: _password,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                      'Au moins 6 caractères', Icons.lock_outline),
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Confirmer le mot de passe'),
                TextField(
                  controller: _confirm,
                  obscureText: true,
                  onSubmitted: (_) => _register(),
                  decoration: _inputDecoration(
                      'Répétez le mot de passe', Icons.lock_outline),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _loading ? null : _register,
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Créer le compte',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
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

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<FamilyMember>> _future = ApiService.getFamilyMembers();

  void _reload() {
    setState(() => _future = ApiService.getFamilyMembers());
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _add() async {
    final data = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _MemberDialog(),
    );
    if (data == null) return;
    try {
      await ApiService.ajouterMembre(
        nom: data['nom']!,
        postnom: data['postnom']!,
        prenom: data['prenom']!,
        lieuNaissance: data['lieu_naissance']!,
        dateNaissance: data['date_naissance']!,
        parente: data['parente']!,
      );
      _message('Membre ajouté.');
      _reload();
    } on ApiException catch (e) {
      _message(e.message);
    }
  }

  Future<void> _edit(FamilyMember member) async {
    final data = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _MemberDialog(member: member),
    );
    if (data == null) return;
    try {
      await ApiService.modifierMembre(
        id: member.id,
        nom: data['nom']!,
        postnom: data['postnom']!,
        prenom: data['prenom']!,
        lieuNaissance: data['lieu_naissance']!,
        dateNaissance: data['date_naissance']!,
        parente: data['parente']!,
      );
      _message('Membre modifié.');
      _reload();
    } on ApiException catch (e) {
      _message(e.message);
    }
  }

  Future<void> _delete(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('${member.nomComplet} sera supprimé définitivement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.supprimerMembre(member.id);
      _message('Membre supprimé.');
      _reload();
    } on ApiException catch (e) {
      _message(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _reload();
          await _future.catchError((_) => <FamilyMember>[]);
        },
        child: FutureBuilder<List<FamilyMember>>(
          future: _future,
          builder: (context, snapshot) {
            final header = <Widget>[
              const Text(
                'Ma famille',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF29243D)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Les personnes qui occupent une place importante dans ma vie.',
                style: TextStyle(color: Color(0xFF777386), height: 1.4),
              ),
              const SizedBox(height: 22),
            ];

            Widget status(Widget child) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
                  children: [...header, child],
                );

            if (snapshot.connectionState != ConnectionState.done) {
              return status(const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              ));
            }

            if (snapshot.hasError) {
              return status(Column(
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ));
            }

            final members = snapshot.data ?? [];
            if (members.isEmpty) {
              return status(const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'Aucun membre enregistré. Appuyez sur « Ajouter » pour en créer un.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF777386)),
                ),
              ));
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
              children: [
                ...header,
                ...members.map((m) => _FamilyCard(
                      member: m,
                      onEdit: () => _edit(m),
                      onDelete: () => _delete(m),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FamilyCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final details = [
      member.parente,
      if (member.lieuNaissance.isNotEmpty || member.dateNaissance.isNotEmpty)
        'Né(e) ${member.lieuNaissance.isNotEmpty ? 'à ${member.lieuNaissance} ' : ''}'
            '${member.dateNaissance.isNotEmpty ? 'le ${member.dateNaissance}' : ''}'
                .trim(),
    ].where((e) => e.trim().isNotEmpty).join('\n');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 14, right: 4, top: 8, bottom: 8),
          leading: _ProfilePhoto(
            // Photo locale facultative : assets/images/<prenom>.jpg,
            // sinon les initiales s'affichent.
            asset: 'assets/images/${member.prenom.trim().toLowerCase()}.jpg',
            initials: member.initiales,
            size: 54,
          ),
          title: Text(member.nomComplet,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(details,
              style: const TextStyle(color: Color(0xFF777386), height: 1.4)),
          isThreeLine: details.contains('\n'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Modifier')),
              PopupMenuItem(value: 'delete', child: Text('Supprimer')),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberDialog extends StatefulWidget {
  final FamilyMember? member;
  const _MemberDialog({this.member});

  @override
  State<_MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<_MemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nom = TextEditingController(text: widget.member?.nom);
  late final _postnom = TextEditingController(text: widget.member?.postnom);
  late final _prenom = TextEditingController(text: widget.member?.prenom);
  late final _lieu = TextEditingController(text: widget.member?.lieuNaissance);
  late final _date = TextEditingController(text: widget.member?.dateNaissance);
  late final _parente = TextEditingController(text: widget.member?.parente);

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _date, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null;

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_date.text) ?? DateTime(2000);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      _date.text = '${picked.year}-$m-$d';
    }
  }

  Widget _field(String label, TextEditingController c,
      {bool date = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        validator: _required,
        readOnly: date,
        onTap: date ? _pickDate : null,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: date ? const Icon(Icons.calendar_today, size: 18) : null,
          hintText: date ? 'AAAA-MM-JJ' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null
          ? 'Ajouter un membre'
          : 'Modifier le membre'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field('Nom', _nom),
              _field('Postnom', _postnom),
              _field('Prénom', _prenom),
              _field('Lieu de naissance', _lieu),
              _field('Date de naissance', _date, date: true),
              _field('Parenté (ex. Père, Sœur)', _parente),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, {
              'nom': _nom.text.trim(),
              'postnom': _postnom.text.trim(),
              'prenom': _prenom.text.trim(),
              'lieu_naissance': _lieu.text.trim(),
              'date_naissance': _date.text.trim(),
              'parente': _parente.text.trim(),
            });
          },
          child: const Text('Valider'),
        ),
      ],
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
