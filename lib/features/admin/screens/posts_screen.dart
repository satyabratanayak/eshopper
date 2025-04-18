import 'package:eshopper/common/widgets/app_network_image.dart';
import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/star_ratings.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/admin/screens/add_product_screen.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class AddProductCard extends StatelessWidget {
  final Product productData;

  const AddProductCard({
    super.key,
    required this.productData,
  });

  @override
  Widget build(BuildContext context) {
    // Average Rating Calculation
    double avgRating = 0;
    if (productData.rating.isNotEmpty) {
      double totalRating =
          productData.rating.fold(0, (sum, r) => sum + r.rating);
      avgRating = totalRating / productData.rating.length;
    }

    // Offer Percent Calculation
    double offerPercent = 0;
    if (productData.mrp > 0) {
      offerPercent = 100 - ((productData.price / productData.mrp) * 100);
    }

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(imageUrl: productData.images[0]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                StarRating(
                  rating: avgRating,
                  reviewCount: productData.rating.length,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${offerPercent.toInt()}% off',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${productData.price}',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '₹${productData.mrp}',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    final productData = products[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 4,
                      child: AddProductCard(productData: productData),
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: StringConstants.addProduct,
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }
}
