import 'dart:convert';

import 'package:fe_test/api/obj.dart';
import 'package:fe_test/widget/product_form.dart';
import 'package:fe_test/widget/product_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api/api_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quản lý sản phẩm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LabelComponent? label;
  ProductSubmitForm? form;
  ButtonComponent? button;
  ProductListComponent? productList;

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse(
            'https://hiring-test.stag.tekoapis.net/api/products/management'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      setState(() {
        parseData(data['data']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void parseData(List<dynamic> components) {
    for (var component in components) {
      switch (component['type']) {
        case 'Label':
          label = LabelComponent.fromJson(component);
          // Add label to UI
          break;
        case 'ProductSubmitForm':
          form = ProductSubmitForm.fromJson(component);
          // Add form to UI
          break;
        case 'Button':
          button = ButtonComponent.fromJson(component);
          // Add button to UI
          break;
        case 'ProductList':
          productList = ProductListComponent.fromJson(component);
          // Add product list to UI
          break;
        default:
          print('Unknown component type');
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Quản lý sản phẩm',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ProductForm(
                  button: button,
                  form: form,
                  label: label,
                  productList: productList,
                  onBack: (p0) {
                    setState(() {
                      productList!.items.insert(0, p0!);
                    });
                  },
                ),
                const SizedBox(height: 20),
                ProductList(productList: productList,),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
