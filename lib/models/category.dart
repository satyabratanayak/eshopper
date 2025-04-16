const List<Category> categoryList = [
  Category(
    title: 'Mobiles',
    image: 'assets/images/mobiles.jpeg',
  ),
  Category(
    title: 'Essentials',
    image: 'assets/images/essentials.jpeg',
  ),
  Category(
    title: 'Appliances',
    image: 'assets/images/appliances.jpeg',
  ),
  Category(
    title: 'Books',
    image: 'assets/images/books.jpeg',
  ),
  Category(
    title: 'Fashion',
    image: 'assets/images/fashion.jpeg',
  ),
];

class Category {
  final String title;
  final String image;

  const Category({
    required this.title,
    required this.image,
  });
}
