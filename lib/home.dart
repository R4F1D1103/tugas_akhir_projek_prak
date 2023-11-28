import 'package:flutter/material.dart';
import 'package:projectakhir_kelompok_resep/detail_resep.dart';
import 'package:projectakhir_kelompok_resep/feedback.dart';
import 'package:projectakhir_kelompok_resep/resep/resep.api.dart';
import 'package:projectakhir_kelompok_resep/resep/model_resep.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projectakhir_kelompok_resep/resep_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorit.dart';
import 'halaman_login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<Resep> _resep;
  bool _isLoading = true;
  List<bool> _bookmarkStates = [];

  Future<void> _logout() async {
    // Clear the username from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('login');

    // Navigate to the login page and remove the previous routes from the stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    getResep();
  }

  Future<void> getResep() async {
    _resep = await ResepApi.getRecipe();
    setState(() {
      _isLoading = false;
      _bookmarkStates = List.generate(_resep.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 20, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'Resep Makanan',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
            )
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            buildHome(),
            FavoriteRecipesScreen(),
            FeedbackForm(),

          ],
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(Colors.grey[200]!.value),
        color: Color.fromARGB(255, 255, 202, 69),
        buttonBackgroundColor: Colors.black,
        height: 50,
        items: <Widget>[
          Icon(Icons.restaurant, size: 20, color: Colors.white),
          Icon(Icons.bookmark, size: 20, color: Colors.white),
          Icon(Icons.feedback, size: 20, color: Colors.white),

        ],
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          });
        },
      ),
    );
  }

  Widget buildHome() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _resep.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: ResepCard(
                  title: _resep[index].name,
                  cookTime: _resep[index].totalTime,
                  rating: _resep[index].rating.toString(),
                  thumbnailUrl: _resep[index].images,
                  videoUrl: _resep[index].videoUrl,
                  isBookmarked: _bookmarkStates[index],
                ),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailResep(
                        name: _resep[index].name,
                        totalTime: _resep[index].totalTime,
                        rating: _resep[index].rating.toString(),
                        images: _resep[index].images,
                        description: _resep[index].description,
                        videoUrl: _resep[index].videoUrl,
                        instruction: _resep[index].instruction,
                        sections: _resep[index].sections,
                      ),
                    ),
                  ),
                },
              );
            },
          );
  }
}
