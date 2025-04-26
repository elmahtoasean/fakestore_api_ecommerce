import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'model/product.dart';

class ProductDetails extends StatefulWidget {
  final Product? productInfo;

  const ProductDetails({super.key, this.productInfo});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        leading: Icon(Icons.info, color: Colors.white),
        title: Text(
          "Product Details",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Times New Roman',
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: widget.productInfo!.image!,
                  child: CachedNetworkImage(
                    imageUrl: widget.productInfo!.image!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height / 3,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.productInfo!.title!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // Price + Icon Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Tk. " + widget.productInfo!.price!.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Times New Roman',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    widget.productInfo!.description!,
                    textAlign: TextAlign.justify,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
