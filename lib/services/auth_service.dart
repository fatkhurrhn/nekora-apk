import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register dengan lengkap
  Future<User?> registerWithEmailPassword({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Cek username udah dipake atau belum
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw 'Username @$username sudah dipake, cari yang lain ya!';
      }

      // Cek email udah dipake atau belum
      final emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .get();

      if (emailQuery.docs.isNotEmpty) {
        throw 'Email sudah terdaftar!';
      }

      // Buat user di Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'fullName': fullName,
        'username': username.toLowerCase(),
        'email': email.toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'bio': '🐱 Cat lover | Nekora user',
        'photoUrl': '',
        'followerCount': 0,
        'followingCount': 0,
        'postCount': 0,
        'role': 'user', // user atau admin
      });

      // Simpan login status ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', result.user!.uid);
      await prefs.setString('userEmail', email.toLowerCase());

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email sudah terdaftar!';
      }
      throw e.message ?? 'Register gagal';
    } catch (e) {
      throw e.toString();
    }
  }

  // Login dengan username/email + password
  Future<User?> loginWithUsernamePassword(
      String identifier, String password) async {
    try {
      String email;

      // Cek apakah identifier itu email atau username
      if (identifier.contains('@')) {
        email = identifier.toLowerCase();
      } else {
        // Cari user berdasarkan username di Firestore
        final userQuery = await _firestore
            .collection('users')
            .where('username', isEqualTo: identifier.toLowerCase())
            .limit(1)
            .get();

        if (userQuery.docs.isEmpty) {
          throw 'Username @$identifier tidak ditemukan';
        }

        email = userQuery.docs.first.data()['email'];
      }

      // Login pake email & password
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan login status ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', result.user!.uid);
      await prefs.setString('userEmail', email);

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw 'Username/Email atau password salah';
      }
      throw e.message ?? 'Login gagal';
    } catch (e) {
      throw e.toString();
    }
  }

  // Cek apakah user sudah login (dari SharedPreferences)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Get saved user ID
  Future<String?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();

    // Hapus semua data login dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('userEmail');
  }

  // Get current user dari Firebase Auth
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current user data dari Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  // Get user by UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  // Search users by username
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final result = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return result.docs.map((doc) => doc.data()).toList();
  }

  // Follow user
  Future<void> followUser(String targetUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentUid = currentUser.uid;

    // Cek apakah sudah follow
    final existingFollow = await _firestore
        .collection('follows')
        .doc('$currentUid-$targetUid')
        .get();

    if (existingFollow.exists) return;

    // Add to following list
    await _firestore.collection('users').doc(currentUid).update({
      'followingCount': FieldValue.increment(1),
    });

    await _firestore.collection('users').doc(targetUid).update({
      'followerCount': FieldValue.increment(1),
    });

    // Create follow relationship
    await _firestore.collection('follows').doc('$currentUid-$targetUid').set({
      'followerId': currentUid,
      'followingId': targetUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Create notification
    final currentUserData = await getCurrentUserData();
    await _createNotification(
      targetUid: targetUid,
      type: 'follow',
      message:
          '${currentUserData?['fullName'] ?? 'Someone'} mulai mengikuti kamu',
      actorId: currentUid,
    );
  }

  // Unfollow user
  Future<void> unfollowUser(String targetUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentUid = currentUser.uid;

    await _firestore.collection('users').doc(currentUid).update({
      'followingCount': FieldValue.increment(-1),
    });

    await _firestore.collection('users').doc(targetUid).update({
      'followerCount': FieldValue.increment(-1),
    });

    await _firestore
        .collection('follows')
        .doc('$currentUid-$targetUid')
        .delete();
  }

  // Check if following
  Future<bool> isFollowing(String targetUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    final doc = await _firestore
        .collection('follows')
        .doc('${currentUser.uid}-$targetUid')
        .get();

    return doc.exists;
  }

  // Get followers list
  Future<List<Map<String, dynamic>>> getFollowers(String uid) async {
    final follows = await _firestore
        .collection('follows')
        .where('followingId', isEqualTo: uid)
        .get();

    List<Map<String, dynamic>> followers = [];
    for (var doc in follows.docs) {
      final followerId = doc.data()['followerId'];
      final userData = await getUserData(followerId);
      if (userData != null) {
        followers.add(userData);
      }
    }
    return followers;
  }

  // Get following list
  Future<List<Map<String, dynamic>>> getFollowing(String uid) async {
    final follows = await _firestore
        .collection('follows')
        .where('followerId', isEqualTo: uid)
        .get();

    List<Map<String, dynamic>> following = [];
    for (var doc in follows.docs) {
      final followingId = doc.data()['followingId'];
      final userData = await getUserData(followingId);
      if (userData != null) {
        following.add(userData);
      }
    }
    return following;
  }

  // Create notification
  Future<void> _createNotification({
    required String targetUid,
    required String type,
    required String message,
    required String actorId,
  }) async {
    await _firestore.collection('notifications').add({
      'userId': targetUid,
      'type': type,
      'message': message,
      'actorId': actorId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get notifications for current user
  Stream<QuerySnapshot> getNotifications() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return 0;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  // Search users canggih (by username OR fullName)
  Future<List<Map<String, dynamic>>> searchUsersAdvanced(String query) async {
    if (query.isEmpty) return [];

    final searchQuery = query.toLowerCase().trim();

    // Search di username (prefix match)
    final usernameResult = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchQuery)
        .where('username', isLessThanOrEqualTo: '$searchQuery\uf8ff')
        .limit(15)
        .get();

    // Search di fullName (prefix match)
    final nameResult = await _firestore
        .collection('users')
        .where('fullName', isGreaterThanOrEqualTo: searchQuery)
        .where('fullName', isLessThanOrEqualTo: '$searchQuery\uf8ff')
        .limit(15)
        .get();

    // Gabung hasil, hapus duplikat
    final Map<String, Map<String, dynamic>> uniqueUsers = {};

    for (var doc in usernameResult.docs) {
      uniqueUsers[doc.id] = doc.data();
    }

    for (var doc in nameResult.docs) {
      uniqueUsers[doc.id] = doc.data();
    }

    // Konversi ke list dan urutkan berdasarkan relevance
    List<Map<String, dynamic>> results = uniqueUsers.values.toList();

    // Sort: yang username match lebih dulu, lalu fullName match
    results.sort((a, b) {
      final aUsername = a['username']?.toLowerCase() ?? '';
      final bUsername = b['username']?.toLowerCase() ?? '';
      final aName = a['fullName']?.toLowerCase() ?? '';
      final bName = b['fullName']?.toLowerCase() ?? '';

      final aExactUsername = aUsername == searchQuery ? 3 : 0;
      final bExactUsername = bUsername == searchQuery ? 3 : 0;
      final aStartsWithUsername = aUsername.startsWith(searchQuery) ? 2 : 0;
      final bStartsWithUsername = bUsername.startsWith(searchQuery) ? 2 : 0;
      final aContainsUsername = aUsername.contains(searchQuery) ? 1 : 0;
      final bContainsUsername = bUsername.contains(searchQuery) ? 1 : 0;
      final aContainsName = aName.contains(searchQuery) ? 1 : 0;
      final bContainsName = bName.contains(searchQuery) ? 1 : 0;

      final aScore = aExactUsername +
          aStartsWithUsername +
          aContainsUsername +
          aContainsName;
      final bScore = bExactUsername +
          bStartsWithUsername +
          bContainsUsername +
          bContainsName;

      return bScore.compareTo(aScore);
    });

    return results;
  }

  // Stream user status
  Stream<User?> get userStream => _auth.authStateChanges();
}
