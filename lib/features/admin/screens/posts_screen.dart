import 'package:eshopper/common/product_card/product_card.dart';
import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/features/admin/screens/add_product_screen.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product> products = [];
  final AdminServices adminServices = AdminServices();

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? const Loader()
        : Scaffold(
            body: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: List.generate(
                  products.length,
                  (index) {
                    final product = products[index];
                    return ProductCard(
                      cardType: CardType.horizontal,
                      product: product,
                      autoScroll: false,
                      userType: UserType.admin,
                      onDelete: () {
                        deleteProduct(product, index);
                      },
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AddProductScreen.routeName,
                          arguments: product,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products.removeAt(index);
        setState(() {});
      },
    );
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }
}
