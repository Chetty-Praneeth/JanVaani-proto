import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';

class ComplaintDetailPage extends StatelessWidget {
  final IssueModel issue;

  const ComplaintDetailPage({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(issue.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status tracker
            _StatusTimeline(currentStatus: issue.status),

            const SizedBox(height: 24),

            // Attachments
            const Text(
              "Attachments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Sample image placeholder",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, AppRoutes.reportIssue);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, AppRoutes.mapView);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String currentStatus;

  const _StatusTimeline({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = ["Pending", "Assigned", "Resolved", "Verified"];
    final timestamps = [
      "2025-09-10 10:00 AM",
      "2025-09-11 12:30 PM",
      "2025-09-12 3:45 PM",
      "2025-09-13 6:00 PM",
    ];
    int currentIndex = steps.indexOf(currentStatus);

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentIndex;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor:
                      isCompleted ? AppColors.primary : Colors.grey.shade300,
                  child: Icon(Icons.check,
                      size: 14,
                      color: isCompleted ? Colors.white : Colors.grey.shade500),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color:
                        isCompleted ? AppColors.primary : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isCompleted ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? AppColors.primary : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timestamps[index],
                      style:
                          const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
