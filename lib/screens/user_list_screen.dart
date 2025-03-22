import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart'; // Import your ChatScreen

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _users = []; // Use a List of Maps
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "No user logged in.";
        });
        return;
      }
      //get all users except the current user.
      final usersSnapshot = await _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      // Convert the QuerySnapshot into a List of Maps.  This is more efficient
      // than iterating in the UI's build method.
      _users = usersSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Include the user's uid, which is the document ID
        return {'id': doc.id, 'name': data['name'] ?? 'Unknown User'};
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error fetching users: $e";
      });
      print('Error fetching users: $e'); // Log the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['name']),
            onTap: () async {
              // Fetch the user's document
              DocumentSnapshot userDoc = await _firestore.collection('users').doc(user['id']).get();
              Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
              String userName = userData['name'] ?? 'Unknown User';

              // Fetch animals where the user is a donor.
                QuerySnapshot animalDocs = await _firestore
                    .collection('animals')
                    .where('donorUid', isEqualTo: user['id'])
                    .get();

                // Print the user name and the categories of the animals they donated to.
                for (var animalDoc in animalDocs.docs) {
                  Map<String, dynamic> animalData = animalDoc.data() as Map<String, dynamic>;
                  String category = animalData['category'] ?? 'No Category';
                  print('User Name: $userName, Category: $category');
                }
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(
              //   //   builder: (context) => ChatScreen(
              //   //     receiverId: user['id'],
              //   //     receiverName: user['name'],
              //   //   ),
              //   // ),
              // );
            },
            trailing: const Icon(Icons.chat), //indicates that the user can chat.
          );
        },
      ),
    );
  }
}

