import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    this.onAddCategory,
    this.onCategorySelected,
  });

  final VoidCallback? onAddCategory;
  final ValueChanged<String>? onCategorySelected;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _showExpenses = true;

  static const List<_CategoryItem> _expenseCategories = [
    _CategoryItem('Food', Icons.restaurant, Color(0xFFFF7A1A)),
    _CategoryItem('Transport', Icons.directions_car, Color(0xFF0565BA)),
    _CategoryItem('Shopping', Icons.shopping_bag, Color(0xFFE81576)),
    _CategoryItem('Bill', Icons.receipt_long, Color(0xFF269CC1)),
    _CategoryItem('Entertainment', Icons.videogame_asset, Color(0xFF8B15B7)),
    _CategoryItem('Health', Icons.health_and_safety, Color(0xFF2DD838)),
    _CategoryItem('Others', Icons.more_horiz, Color(0xFF929292)),
  ];

  static const List<_CategoryItem> _incomeCategories = [
    _CategoryItem('Salary', Icons.account_balance_wallet, Color(0xFF0565BA)),
    _CategoryItem('Business', Icons.business_center, Color(0xFF8B15B7)),
    _CategoryItem('Investments', Icons.trending_up, Color(0xFF2DD838)),
    _CategoryItem('Gifts', Icons.card_giftcard, Color(0xFFFF7A1A)),
    _CategoryItem('Others', Icons.more_horiz, Color(0xFF929292)),
  ];

  @override
  Widget build(BuildContext context) {
    final categories =
        _showExpenses ? _expenseCategories : _incomeCategories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, size: 28),
        ),
        titleSpacing: 4,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Add category',
            onPressed: () {
              if (widget.onAddCategory != null) {
                widget.onAddCategory!();
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AddCategoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 27),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            child: _CategoryToggle(
              showExpenses: _showExpenses,
              onChanged: (value) => setState(() => _showExpenses = value),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD8D8D8)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    children: [
                      for (final category in categories)
                        _CategoryTile(
                          category: category,
                          onTap: () =>
                              widget.onCategorySelected?.call(category.name),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryToggle extends StatelessWidget {
  const _CategoryToggle({
    required this.showExpenses,
    required this.onChanged,
  });

  final bool showExpenses;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'Expense',
              selected: showExpenses,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: 'Income',
              selected: !showExpenses,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF0565BA) : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF292929),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final _CategoryItem category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, color: Colors.white, size: 25),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '23 Transaction',
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF272727),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'New Category',
  );

  bool _isExpense = true;
  int _selectedIcon = 0;
  int _selectedColor = 4;

  static const List<IconData> _icons = [
    Icons.restaurant,
    Icons.shopping_bag_outlined,
    Icons.local_mall_outlined,
    Icons.favorite_border,
    Icons.card_giftcard,
    Icons.add,
    Icons.directions_car,
    Icons.account_balance_wallet_outlined,
  ];

  static const List<Color> _iconColors = [
    Color(0xFFFF7011),
    Color(0xFFF13C06),
    Color(0xFF2197B8),
    Color(0xFF8318B9),
    Color(0xFFFF7917),
    Color(0xFF8E8E8E),
    Color(0xFF0061B7),
    Color(0xFF22D839),
  ];

  static const List<Color> _colors = [
    Color(0xFFFF6066),
    Color(0xFF24479C),
    Color(0xFF24D62F),
    Color(0xFF128042),
    Color(0xFF0061AF),
    Color(0xFFE50067),
    Color(0xFF0FAFC8),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name.')),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _HeaderButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        titleSpacing: 4,
        title: const Text(
          'Add Categories',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          _HeaderButton(icon: Icons.check, onTap: _save),
          const SizedBox(width: 22),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFF0061B7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x28000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF0F0F0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Category Name'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFFCAD3DF),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFF0061B7),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    const _FieldLabel('Type'),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        _TypeChoice(
                          label: 'Expense',
                          selected: _isExpense,
                          onTap: () => setState(() => _isExpense = true),
                        ),
                        const SizedBox(width: 24),
                        _TypeChoice(
                          label: 'Income',
                          selected: !_isExpense,
                          onTap: () => setState(() => _isExpense = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FieldLabel('Icon'),
                    const SizedBox(height: 11),
                    Wrap(
                      spacing: 10,
                      runSpacing: 14,
                      children: List.generate(_icons.length, (index) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIcon = index),
                          child: Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: _iconColors[index],
                              shape: BoxShape.circle,
                              border: _selectedIcon == index
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            child: Icon(
                              _icons[index],
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Color'),
                    const SizedBox(height: 11),
                    Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      children: List.generate(_colors.length, (index) {
                        final selected = _selectedColor == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = index),
                          child: Container(
                            width: 31,
                            height: 31,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(
                                      color: _colors[index],
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _colors[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F8FC),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, color: const Color(0xFF0061B7), size: 23),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF65778D),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TypeChoice extends StatelessWidget {
  const _TypeChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0061B7)
                      : const Color(0xFF7A8BA0),
                  width: 2,
                ),
              ),
              child: selected
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF0061B7),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF27364A)
                    : const Color(0xFF65778D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
