import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/product_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'api_service/api.dart';
//import 'model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Product>> getProducts() async {
    List<Product> products = [];

    try {
      final url = Uri.parse(Api.getProductsUrl);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        for (var eachProduct in responseData as List) {
          products.add(Product.fromJson(eachProduct));
        }
      } else {
        Fluttertoast.showToast(msg: "Error fetching products");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: errorMsg.toString());
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_bag_rounded, color: Colors.white),
        title: const Text(
          'Our Products',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Times New Roman',
              //fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dataSnapShot.hasError || dataSnapShot.data == null) {
            return const Center(
                child: Text(
              "No Products Found!",
              style: TextStyle(color: Colors.red),
            ));
          }

          if (dataSnapShot.data!.isEmpty) {
            return const Center(
                child: Text(
              "No Products Found!",
              style: TextStyle(color: Colors.red),
            ));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: dataSnapShot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                Product eachProduct = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ProductDetails(productInfo: eachProduct));
                        },
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Hero(
                                  tag: eachProduct.image!,
                                  child: CachedNetworkImage(
                                    imageUrl: eachProduct.image ?? '',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Text(
                                eachProduct.title ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Times New Roman',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text("Tk. ${eachProduct.price ?? '0'}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Times New Roman',
                                    fontStyle: FontStyle.italic,
                                  )),
                              const SizedBox(height: 5),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(20),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                label: 
                                 const Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Times New Roman',
                                      fontStyle: FontStyle.italic),
                                ),
                                icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 15,),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
