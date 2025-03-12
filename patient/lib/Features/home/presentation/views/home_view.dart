import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient/Core/utils/assets.dart';
import 'package:patient/Features/auth/splash_screen.dart';
import 'package:patient/Features/home/presentation/views/widgets/custom_card.dart';
import 'package:patient/Features/home/presentation/views/widgets/custom_level_slider.dart';
import 'package:patient/constants.dart';


class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});
  static const route = '/Home';

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
int _selectedIndex = 0;

  // Function to navigate to the appropriate screen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate screen based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height*.02),
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Text(
              "Mohsin",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Autism Level Slider Card
            buildAutismLevelCard(),

            const SizedBox(height: 20),

            // Therapy Goals Card
            buildFeatureCard(
              title: "Therapy Goals",
              imagePath: AssetsData.therapy,
              height: height*.17,
              color: const Color(0xffF9F3E3), context: context, routeName: '/TherapyGoals', // Light Yellow
            ),

             SizedBox(height: height*.02),

            // Daily Activities Card
            buildFeatureCard(
              title: "Daily Activities",
              imagePath: AssetsData.actvts,
              height: height*.17,
              color: const Color(0xffFEF4F0), context: context, routeName: '/DailyActivities', // Light Pink
            ),

             SizedBox(height: height*.02),

            // Development Milestones Card
            buildFeatureCard(
              title: "Development Milestones",
              imagePath: AssetsData.milestone,
              height: height*.17,
              color: const Color(0xffF5FAF4), context: context, routeName: null, // Light Green
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }


  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.kPrimaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped, // Handle item tap and navigation
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(AssetsData.home)),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AssetsData.report, width: 24, height: 24), // Use SvgPicture.asset for SVG images
          label: "Report",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(AssetsData.calender)),
          label: "Calender",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(AssetsData.notify)), // Correct icon for Notifications
          label: "Notifications",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(AssetsData.profile)),
          label: "Profile",
        ),
      ],
    );
  }
}
