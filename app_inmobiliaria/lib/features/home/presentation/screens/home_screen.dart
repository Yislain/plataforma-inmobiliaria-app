import 'package:flutter/material.dart';
import '../../../core/widgets/property_card.dart';
import '../filter_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  int _selectedIndex = 0;
  
  final _properties = [

    {
      'imageUrl':
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'type': 'Villa',
      'rating': 4.8,
      'title': 'Naples Villa',
      'location': 'Panjim, Goa',
      'price': '86,000',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'type': 'Villa',
      'rating': 4.9,
      'title': 'Colina - Villa',
      'location': 'Coorg, Kerala',
      'price': '100,000',
    },
  ];

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Buscador y Botón de Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black87),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categorías
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem(Icons.home_outlined, 'House', true),
                  _buildCategoryItem(Icons.domain_outlined, 'Villa', false),
                  _buildCategoryItem(
                    Icons.apartment_outlined,
                    'Apartment',
                    false,
                  ),
                  _buildCategoryItem(Icons.cottage_outlined, 'Cottage', false),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sección: Recommended Property
            _buildSectionHeader('Recommended Property'),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 24.0),
                scrollDirection: Axis.horizontal,
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final prop = _properties[index];
                  return PropertyCard(
                    imageUrl: prop['imageUrl'] as String,
                    type: prop['type'] as String,
                    rating: prop['rating'] as double,
                    title: prop['title'] as String,
                    location: prop['location'] as String,
                    price: prop['price'] as String,
                    onTap: () {},
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Sección: Nearby Property
            _buildSectionHeader('Nearby Property'),
            const SizedBox(height: 16),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade50,
      elevation: 0,
      titleSpacing: 24,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.blue.shade700,
                size: 18,
              ),
              const SizedBox(width: 4),
              const Text(
                'New Delhi',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black87,
                size: 20,
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(icon, color: Colors.blue.shade700, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              Icons.home,
              'Home',
              isActive: _selectedIndex == 0,
            ),
            _buildNavItem(
              1,
              Icons.search,
              'Explore',
              isActive: _selectedIndex == 1,
            ),
            _buildNavItem(
              2,
              Icons.message_outlined,
              'Messages',
              isActive: _selectedIndex == 2,
              badgeCount: '9',
            ),
            _buildNavItem(
              3,
              Icons.person_outline,
              'Profile',
              isActive: _selectedIndex == 3,
              hasDot: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label, {
    bool isActive = false,
    String? badgeCount,
    bool hasDot = false,
  }) {
    final color = isActive ? Colors.blue.shade700 : Colors.grey.shade500;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border:
              isActive
                  ? Border(
                    top: BorderSide(color: Colors.blue.shade700, width: 2),
                  )
                  : const Border(
                    top: BorderSide(color: Colors.transparent, width: 2),
                  ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 26),
                if (badgeCount != null)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (hasDot)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}