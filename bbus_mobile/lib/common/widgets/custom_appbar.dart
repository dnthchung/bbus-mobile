import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget {
  final String childName;
  final String? avatarUrl; // Nullable, uses default image if null

  const CustomAppbar({
    super.key,
    required this.childName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),

          // Child Avatar
          avatarUrl != null && avatarUrl!.startsWith('http')
              ? ClipOval(
                  child: Image.network(
                    avatarUrl!,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        image: AssetImage('assets/images/default_avatar.png'),
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              : ClipOval(
                  child: const Image(
                  image: AssetImage('assets/images/default_avatar.png'),
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                )),
          const SizedBox(width: 10),

          // Child Name
          Expanded(
            child: Text(
              childName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  overflow: TextOverflow.clip),
            ),
          ),
        ],
      ),
    );
  }
}
