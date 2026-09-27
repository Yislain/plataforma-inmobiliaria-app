import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State {
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(1000, 10000);
  String _selectedReview = '4.5 & Above';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Cabecera del modal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance para centrar el título
              ],
            ),
          ),
          const Divider(height: 1),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categorías
                  const Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildPillButton('All'),
                      _buildPillButton('Villa'),
                      _buildPillButton('Independent'),
                      _buildPillButton('Apartments'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Rango de Precio
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: _priceRange,
                    min: 500,
                    max: 20000,
                    divisions: 20,
                    activeColor: Colors.blue.shade500,
                    inactiveColor: Colors.grey.shade200,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹500', style: TextStyle(color: Colors.grey)),
                      Text('₹20,000', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Reseñas
                  const Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildReviewOption('4.5 & Above', 5),
                  _buildReviewOption('4.0 - 4.5', 4),
                  _buildReviewOption('3.5 - 4.0', 3),
                  _buildReviewOption('3.0 - 3.5', 2),
                  _buildReviewOption('2.5 - 3.0', 1),
                ],
              ),
            ),
          ),

          // Botones Inferiores Fijos
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), 
                  blurRadius: 10, 
                  offset: const Offset(0, -4)
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide.none,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('Reset Filter', style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton(String label) {
    final isSelected = _selectedCategory == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() => _selectedCategory = label);
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300),
      ),
    );
  }

  Widget _buildReviewOption(String label, int starCount) {
    return InkWell(
      onTap: () => setState(() => _selectedReview = label),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < starCount ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                );
              }),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Radio(
              value: label,
              groupValue: _selectedReview,
              activeColor: Colors.blue.shade600,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedReview = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}