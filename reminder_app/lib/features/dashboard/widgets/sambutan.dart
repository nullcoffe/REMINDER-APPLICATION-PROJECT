
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/neu_card.dart';

// Card sapaan di bagian atas dashboard.
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Mengambil foto profil dari Firebase Authentication.
    final photoUrl = FirebaseAuth.instance.currentUser?.photoURL;

    return NeuCard(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Mahasiswa! 👋',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semangat tuntaskan kuliah, Urusan tugas ntar diingetin sama zilla-chan ya....',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: AppSizes.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Foto profil atau ikon person.
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: photoUrl != null && photoUrl.isNotEmpty
                  ? Image.network(
                      photoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person,
                        size: 35,
                        color: colorScheme.primary,
                      ),
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: colorScheme.primary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}