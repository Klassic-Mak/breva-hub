// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZmVtYWxlfGVufDB8fDB8fHww', // Replace with your image URL
            ),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Ebenezer Zakari',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            '@eben10',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(color: Colors.grey[400]!),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  _ProfileTile(
                    icon: Icons.verified_user,
                    title: 'Verification',
                    trailing: Icon(Icons.check, color: Colors.green, size: 20),
                  ),
                  _ProfileTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  _ProfileTile(
                    icon: Icons.lock_outline,
                    title: 'Change password',
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  _ProfileTile(
                    icon: Icons.group_outlined,
                    title: 'Refer friends',
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(10),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: trailing,
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    );
  }
}
