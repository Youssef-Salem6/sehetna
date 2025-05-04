import 'package:flutter/material.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/core/nav_view.dart';
import 'package:sehetna/generated/l10n.dart';

class RequestAcceptedView extends StatelessWidget {
  final Map<String, dynamic> providerData;
  final String serviceName;
  final String expectedTime;

  const RequestAcceptedView({
    super.key,
    required this.providerData,
    required this.serviceName,
    required this.expectedTime,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🏁 RequestAcceptedPage built with provider: ${providerData['name']}');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(S.of(context).acceptRequest,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 60),
                    const SizedBox(height: 15),
                    Text(
                      S.of(context).requestAccepted,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${S.of(context).Your} $serviceName ${S.of(context).requestConfirmed}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Service details card
              _buildDetailCard(
                icon: Icons.construction,
                title: S.of(context).serviceDetails,
                children: [
                  // _buildDetailRow(S.of(context).serviceType, serviceName),
                  _buildDetailRow(S.of(context).expextedTime, expectedTime),
                  _buildDetailRow(S.of(context).status, S.of(context).confirmed,
                      isHighlighted: true),
                ],
              ),

              const SizedBox(height: 20),

              // Provider details card
              _buildDetailCard(
                icon: Icons.person,
                title: S.of(context).providerDetails,
                children: [
                  if (providerData['profile_image'] != null)
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "$imagesBaseUrl/${providerData['profile_image']}"),
                        radius: 50,
                      ),
                    ),
                  const SizedBox(height: 15),
                  _buildDetailRow(S.of(context).name, providerData['name']),
                  _buildDetailRow(S.of(context).contact, providerData['phone']),
                  _buildDetailRow(
                      S.of(context).rating, '${providerData['rating']} ⭐',
                      isHighlighted: true),
                  _buildDetailRow(S.of(context).distance,
                      '${providerData['distance']} away'),
                ],
              ),

              const SizedBox(height: 30),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('✅ User confirmed provider acceptance');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const NavView()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    S.of(context).backToHome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[800], size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          // Fixed: Added Flexible widget to handle overflow with ellipsis
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.green[800] : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
