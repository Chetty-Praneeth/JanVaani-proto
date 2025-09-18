import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../core/app_routes.dart';
import '../core/app_colors.dart';

class ComplaintListPage extends StatefulWidget {
  const ComplaintListPage({super.key});

  @override
  State<ComplaintListPage> createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  String? selectedCategory;
  String? selectedStatus;

  final List<IssueModel> dummyIssues = [
  IssueModel(
    id: 1,
    title: "Large pothole near Chinnacoonoor",
    description: "Bus stop area",
    category: "Roads",
    status: "In Progress",
    createdBy: "dummyUser123",
    location: "Chinnacoonoor",
    createdAt: DateTime.now(),
  ),
  IssueModel(
    id: 2,
    title: "Streetlight not working at Kailudai",
    description: "Park road",
    category: "Lighting",
    status: "Pending",
    createdBy: "dummyUser123",
    location: "Kailudai",
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  IssueModel(
    id: 3,
    title: "Garbage overflow at Cotty Market",
    description: "Near shop line",
    category: "Garbage",
    status: "Resolved",
    createdBy: "dummyUser123",
    location: "Cotty Market",
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];


  @override
  Widget build(BuildContext context) {
    // Apply filters
    final filteredIssues = dummyIssues.where((issue) {
      final matchesCategory =
          selectedCategory == null || issue.category == selectedCategory;
      final matchesStatus =
          selectedStatus == null || issue.status == selectedStatus;
      return matchesCategory && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Complaints"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                DropdownButton<String>(
                  hint: const Text("Category"),
                  value: selectedCategory,
                  items: ["Roads", "Lighting", "Garbage"]
                      .map((cat) => DropdownMenuItem(
                          value: cat,
                          child:
                              Text(cat, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint: const Text("Status"),
                  value: selectedStatus,
                  items: ["Pending", "In Progress", "Resolved"]
                      .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status,
                              style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                ),
                const Spacer(),
                if (selectedCategory != null || selectedStatus != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                        selectedStatus = null;
                      });
                    },
                    child: const Text("Clear Filters"),
                  ),
              ],
            ),
          ),

          // Complaints list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredIssues.length,
              itemBuilder: (context, index) {
                final issue = filteredIssues[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.complaintDetail,
                      arguments: issue,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: Container(
                            height: 90,
                            width: 90,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(issue.title,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  issue.description,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      issue.createdAt
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    _statusChip(issue.status),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case "Pending":
        color = Colors.orange;
        break;
      case "In Progress":
        color = Colors.blue;
        break;
      case "Resolved":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: color),
      ),
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
