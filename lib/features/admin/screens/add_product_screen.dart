import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:eshopper/common/widgets/custom_button.dart';
import 'package:eshopper/common/widgets/custom_textfield.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/models/category.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  static const String routeName = '/add-product';
  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  List<File> images = [];
  int _current = 0;
  final _addProductFormKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isAddProductEnabled = false;

  List<String> productCategories = categoryList.map((e) => e.title).toList();
  String category = categoryList.first.title;

  Future<File> urlToFile(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final fileName = imageUrl.split('/').last;
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void existingData() async {
    final product = widget.product;
    if (product != null) {
      final image = product.images;
      for (String imageUrl in image) {
        File file = await urlToFile(imageUrl);
        images.add(file);
      }
      _productNameController.text = product.name;
      _descriptionController.text = product.description;
      _mrpController.text = product.mrp.toString();
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      category = product.category;
    }
    setState(() {
      isLoading = false;
    });
  }

  void _updateButtonState() {
    final isProductNameFilled = _productNameController.text.isNotEmpty;
    final isDescriptionFilled = _descriptionController.text.isNotEmpty;
    final isMrpFilled = _mrpController.text.isNotEmpty;
    final isPriceFilled = _priceController.text.isNotEmpty;
    final isQuantityFilled = _quantityController.text.isNotEmpty;
    setState(() {
      isAddProductEnabled = isProductNameFilled &&
          isDescriptionFilled &&
          isMrpFilled &&
          isPriceFilled &&
          isQuantityFilled &&
          category.isNotEmpty &&
          images.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    existingData();
    _productNameController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);
    _mrpController.addListener(_updateButtonState);
    _priceController.addListener(_updateButtonState);
    _quantityController.addListener(_updateButtonState);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            StringConstants.addProduct,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CarouselSlider.builder(
                                itemCount: images.length + 1,
                                itemBuilder: (context, index, realIdx) {
                                  if (index == images.length) {
                                    return GestureDetector(
                                      onTap: selectImages,
                                      child: Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: Icon(Icons.add,
                                              size: 40, color: Colors.black54),
                                        ),
                                      ),
                                    );
                                  }
                                  final image = images[index];
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              images.removeAt(index);
                                              if (_current >= images.length &&
                                                  _current > 0) {
                                                _current = images.length - 1;
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                options: CarouselOptions(
                                  animateToClosest: true,
                                  height: double.infinity,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (_current != images.length)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black38,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_current != images.length)
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Row(
                                children: images.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == entry.key
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.4),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  StringConstants.selectProductImages,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _productNameController,
                  hintText: StringConstants.productName,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: StringConstants.productDescription,
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _mrpController,
                  hintText: StringConstants.productMrp,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _priceController,
                  hintText: StringConstants.productPrice,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _quantityController,
                  hintText: StringConstants.productQuantity,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        if (newVal != null && newVal.isNotEmpty) {
                          category = newVal;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: StringConstants.sell,
                  color: GlobalVariables.secondaryColor,
                  onTap: sellProduct,
                  isEnabled: isAddProductEnabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: _productNameController.text,
        description: _descriptionController.text,
        mrp: double.parse(_mrpController.text),
        price: double.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
        category: category,
        images: images,
      );
    }
  }
}
