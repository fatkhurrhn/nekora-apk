import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class OtherProfilePage extends StatefulWidget {
  final String userId;
  const OtherProfilePage({super.key, required this.userId});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? _userData;
  bool _isFollowing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _auth.getUserData(widget.userId);
    final following = await _auth.isFollowing(widget.userId);

    setState(() {
      _userData = data;
      _isFollowing = following;
      _isLoading = false;
    });
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);

    if (_isFollowing) {
      await _auth.unfollowUser(widget.userId);
      setState(() => _isFollowing = false);
    } else {
      await _auth.followUser(widget.userId);
      setState(() => _isFollowing = true);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _userData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(
          '@${_userData!['username']}',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF161616),
                  child: Text(
                    _userData!['fullName']?[0]?.toUpperCase() ?? '🐱',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('${_userData!['postCount'] ?? 0}', 'POSTS'),
                      _buildStat(
                          '${_userData!['followerCount'] ?? 0}', 'FOLLOWERS'),
                      _buildStat(
                          '${_userData!['followingCount'] ?? 0}', 'FOLLOWING'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData!['fullName'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${_userData!['username'] ?? ''}',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    color: const Color.fromRGBO(255, 255, 255, 0.45),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _userData!['bio'] ?? '🐱 Cat lover | Nekora user',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFollowing ? Colors.transparent : Colors.white,
                      foregroundColor:
                          _isFollowing ? Colors.white : Colors.black,
                      side: _isFollowing
                          ? const BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.2))
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isFollowing ? 'FOLLOWING' : 'FOLLOW',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            color: const Color.fromRGBO(255, 255, 255, 0.45),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
