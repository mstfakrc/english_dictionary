import 'dart:math';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:clay_containers/clay_containers.dart';

import 'package:dictionaryenglish/adsManager.dart';
import 'package:dictionaryenglish/constants/colors.dart';
import 'package:dictionaryenglish/pages/learnPage.dart';
import 'package:dictionaryenglish/pages/listWordPage.dart';
import 'package:dictionaryenglish/pages/searchPage.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  /// %20 olasılıkla reklam gösteren fonksiyon
  Future<void> _showAdIfNeeded() async {
    final random = Random();
    final probability = random.nextDouble();

    if (probability < 0.20) {
      await AdManager.showIntAd(); // Reklam göster
    }
  }

  /// Seçilen sayfayı döndüren fonksiyon
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const SearchPage();
      case 1:
        return const ListWordPage();
      case 2:
        return const LearnPage();
      default:
        return const SearchPage(); // Varsayılan olarak SearchPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _getSelectedPage(_selectedIndex), // Seçilen sayfa
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 65,
        color: primaryColor,
        backgroundColor: backgroundColor,
        buttonBackgroundColor: accentColor,
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          _buildNavBarIcon(Icons.search, _selectedIndex == 0),
          _buildNavBarIcon(Icons.list, _selectedIndex == 1),
          _buildNavBarIcon(Icons.school, _selectedIndex == 2),
        ],
        onTap: (index) async {
          await _showAdIfNeeded();
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  /// Navigasyon butonlarını oluşturan ortak bir fonksiyon
  Widget _buildNavBarIcon(IconData icon, bool isActive) {
    return ClayContainer(
      spread: 1,
      borderRadius: 25,
      color: isActive ? accentColor : primaryColor, // Seçili butonun rengi
      height: 50,
      width: 50,
      child: Icon(
        icon,
        size: 30,
        color: isActive ? textColor : Colors.grey.shade400, // Aktif olan ikon beyaz, diğerleri gri
      ),
    );
  }
}
