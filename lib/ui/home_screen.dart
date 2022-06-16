import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cart.dart';
import 'profile.dart';
import 'shopping.dart';

class HomeScreen extends StatefulWidget {
  final String tab;

  const HomeScreen({
    required this.tab,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  static int indexFrom(String tab) {
    switch (tab) {
      case 'cart':
        return 1;
      case 'profile':
        return 2;
      case 'shop':
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = indexFrom(widget.tab);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = indexFrom(widget.tab);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Navigator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.blue,
        currentIndex: indexFrom(args!['tab']),
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
              switch (index) {
                case 0:
                  context.go('/shop');
                  break;
                case 1:
                  context.go('/cart');
                  break;
                case 2:
                  context.go('/profile');
                  break;
              }
            },
          );
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          Shopping(),
          Cart(),
          Profile(),
        ],
      ),
    );
  }
}
