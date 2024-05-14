import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              'Profile Screen',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 100),
          const Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Dark Mode',
          //         style: TextStyle(
          //           color: _isDarkMode ? Colors.white : Colors.black,
          //           fontSize: 18,
          //         ),
          //       ),
          //       Switch(
          //         value: _isDarkMode,
          //         onChanged: (value) {
          //           setState(() {
          //             _isDarkMode = value;
          //           });
          //         },
          //         activeColor: Colors.blueAccent,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
