import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'other_profile_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final AuthService _auth = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _recommendations = [];
  bool _isSearching = false;
  Timer? _debounceTimer;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadRecommendations();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.isEmpty) {
      setState(() {
        _currentQuery = '';
        _searchResults = [];
        _isSearching = false;
      });
      _loadRecommendations();
      return;
    }

    setState(() => _isSearching = true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      _currentQuery = query;
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    final results = await _auth.searchUsersAdvanced(query);
    final currentUser = _auth.getCurrentUser();

    // Filter out current user
    final filteredResults =
        results.where((user) => user['uid'] != currentUser?.uid).toList();

    if (mounted) {
      setState(() {
        _searchResults = filteredResults;
        _isSearching = false;
      });
    }
  }

  Future<void> _loadRecommendations() async {
    // Load popular users atau random users
    final allUsers = await _auth.searchUsersAdvanced('');
    final currentUser = _auth.getCurrentUser();

    // Filter out current user and get random 5 users
    final others =
        allUsers.where((user) => user['uid'] != currentUser?.uid).toList();
    others.shuffle();

    if (mounted) {
      setState(() {
        _recommendations = others.take(5).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(
          'EXPLORE',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: Colors.white),
              decoration: InputDecoration(
                hintText: '🔍 Cari username atau nama...',
                hintStyle: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: const Color.fromRGBO(255, 255, 255, 0.45),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _recommendations = [];
                          });
                          _loadRecommendations();
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Sedang loading
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'SEARCHING...',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                letterSpacing: 2,
                color: Color.fromRGBO(255, 255, 255, 0.45),
              ),
            ),
          ],
        ),
      );
    }

    // Hasil pencarian
    if (_searchController.text.isNotEmpty) {
      if (_searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'TIDAK DITEMUKAN',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  letterSpacing: 2,
                  color: const Color.fromRGBO(255, 255, 255, 0.45),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final user = _searchResults[index];
          return _buildUserTile(user,
              showRelevance: true, searchQuery: _currentQuery);
        },
      );
    }

    // Rekomendasi (saat tidak mencari)
    if (_recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.explore_outlined, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'CARI KUCING LAIN',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                letterSpacing: 2,
                color: const Color.fromRGBO(255, 255, 255, 0.45),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ketik username atau nama di atas',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                color: const Color.fromRGBO(255, 255, 255, 0.3),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            '✨ REKOMENDASI UNTUK ANDA',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              letterSpacing: 1.5,
              color: const Color.fromRGBO(255, 255, 255, 0.45),
            ),
          ),
        ),
        ..._recommendations
            .map((user) => _buildUserTile(user, showRelevance: false)),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: _loadRecommendations,
            child: Text(
              'REFRESH REKOMENDASI',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                letterSpacing: 1,
                color: const Color.fromRGBO(255, 255, 255, 0.45),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user,
      {bool showRelevance = false, String searchQuery = ''}) {
    // Hitung relevance untuk highlight
    final username = user['username']?.toLowerCase() ?? '';
    final fullName = user['fullName']?.toLowerCase() ?? '';
    final query = searchQuery.toLowerCase();

    bool isUsernameMatch = username.contains(query);
    bool isNameMatch = fullName.contains(query);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtherProfilePage(userId: user['uid']),
          ),
        ).then((_) => _loadRecommendations());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF0A0A0A),
              backgroundImage:
                  user['photoUrl'] != null && user['photoUrl'].isNotEmpty
                      ? NetworkImage(user['photoUrl'])
                      : null,
              child: user['photoUrl'] == null || user['photoUrl'].isEmpty
                  ? Text(
                      user['fullName']?[0]?.toUpperCase() ?? '🐱',
                      style: const TextStyle(fontSize: 20),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: _highlightText(
                              user['fullName'] ?? 'Unknown',
                              showRelevance && isNameMatch ? query : '',
                            ),
                          ),
                        ),
                      ),
                      if (showRelevance && isNameMatch)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NAME',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: _highlightText(
                        '@${user['username'] ?? ''}',
                        showRelevance && isUsernameMatch ? query : '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
              ),
              child: const Text(
                'LIHAT',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ];
    }

    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final startIndex = textLower.indexOf(queryLower);
    final endIndex = startIndex + queryLower.length;

    return [
      TextSpan(
        text: text.substring(0, startIndex),
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      TextSpan(
        text: text.substring(startIndex, endIndex),
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF22C55E),
          backgroundColor: Color.fromRGBO(34, 197, 94, 0.2),
        ),
      ),
      TextSpan(
        text: text.substring(endIndex),
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ];
  }
}
