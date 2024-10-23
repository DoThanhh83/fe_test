import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../api/obj.dart';

class ProductList extends StatefulWidget {
  ProductListComponent? productList;

  ProductList({super.key, this.productList});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  String? ConvertMon(int? price ){
    final moneyController = MoneyMaskedTextController(
      initialValue: price?.toDouble() ?? 0,
      decimalSeparator: '',
      thousandSeparator: '.',
      leftSymbol: '',
      precision: 0
    );
    return moneyController.text;
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: widget.productList?.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) {
          final product = widget.productList?.items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: product?.imageSrc != null
                        ? Image.network(product!.imageSrc, fit: BoxFit.fitWidth,errorBuilder: (context, error, stackTrace) {
                          return Image.file(File(product.imageSrc));
                        },)
                        : Icon(Icons.no_accounts)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(product?.name ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('${ ConvertMon(product?.price)?? ""} đ'),
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
  }
}
