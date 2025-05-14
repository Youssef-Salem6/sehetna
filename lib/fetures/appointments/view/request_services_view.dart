import 'package:flutter/material.dart';
import 'package:sehetna/const.dart' show kPrimaryColor;
import 'package:sehetna/fetures/appointments/models/serviceDetailsModel.dart';
import 'package:sehetna/generated/l10n.dart';

class RequestServicesView extends StatelessWidget {
  final List services;
  const RequestServicesView({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        title: Text(
          S.of(context).requestServices,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with service count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              "${services.length} ${S.of(context).services}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor.withOpacity(0.8),
              ),
            ),
          ),

          // Service cards list
          Expanded(
            child: services.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).noservices,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      Servicedetailsmodel service =
                          Servicedetailsmodel.fromjson(
                        json: services[index],
                        languageCode:
                            Localizations.localeOf(context).languageCode,
                      );

                      // Determine category icon and color
                      IconData categoryIcon = _getCategoryIcon(
                        service.category ?? "",
                      );
                      Color categoryColor = _getCategoryColor(
                        service.category ?? "",
                      );

                      return ServiceCard(
                        service: service,
                        categoryIcon: categoryIcon,
                        categoryColor: categoryColor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    // Map category to Material icon
    switch (category.toLowerCase()) {
      case 'consultation':
        return Icons.medical_information;
      case 'laboratory':
        return Icons.science;
      case 'imaging':
        return Icons.image;
      case 'nutrition':
        return Icons.restaurant;
      case 'physiotherapy':
        return Icons.fitness_center;
      default:
        return Icons.medical_services;
    }
  }

  Color _getCategoryColor(String category) {
    // Map category to color
    switch (category.toLowerCase()) {
      case 'consultation':
        return const Color(0xFF4CAF50);
      case 'laboratory':
        return const Color(0xFF2196F3);
      case 'imaging':
        return const Color(0xFF9C27B0);
      case 'nutrition':
        return const Color(0xFFFF9800);
      case 'physiotherapy':
        return const Color(0xFF03A9F4);
      default:
        return kPrimaryColor;
    }
  }
}

class ServiceCard extends StatelessWidget {
  final Servicedetailsmodel service;
  final IconData categoryIcon;
  final Color categoryColor;

  const ServiceCard({
    super.key,
    required this.service,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Service info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 30),
                ),

                const SizedBox(width: 16),

                // Service details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service name
                      Text(
                        service.name ?? "Unknown Service",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Category
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service.category ?? "General",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Price tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "EGP ${service.price}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: const SizedBox(width: 4),
          ),
        ],
      ),
    );
  }
}
