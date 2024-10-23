import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';

import '../api/obj.dart';

class ProductForm extends StatefulWidget {
  LabelComponent? label;
  ProductSubmitForm? form;
  ButtonComponent? button;
  ProductListComponent? productList;
  Function(ProductItem?)? onBack ;
  ProductForm(
      {super.key, this.label, this.form, this.productList, this.button,this.onBack});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _price = '0';
  String _imageUrl = '';
  File? imageFile;
  ProductItem? item ;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('File lớn hơn 5MB')));
      } else {
        setState(() {
          imageFile = file;
          _imageUrl = file.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên sản phẩm
            ...?widget.form?.fields.map((e) {
              if(widget.form?.fields.indexOf(e) == widget.form!.fields.length - 1 )
                {
                  return Container();
                }
              else{
                return formInput(e.label, required: e.required,
                    valid: (value) => validateField(e, value),
                    onSaved: (value) => onSaved(e, value),
                    keyboardType: e.type == "number"
                        ? TextInputType.number
                        : null);
              }
            },),
            // URL Ảnh
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ảnh sản phẩm',style: TextStyle(fontSize: 17)),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.black, width: 1), // Viền đen với độ rộng 1
                    ),
                  ),
                  child: Row(
                   mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_upload ),
                      const Text('Chọn tệp tin (tối đa 5MB)'),
                      imageFile != null ? SizedBox(width: 5,) :Container(),
                      imageFile != null ? Container(height:50,width:50,child: Image.file(imageFile!)) : Container()
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // if (mounted) {
                  if (_formKey.currentState != null && _formKey.currentState!.validate())  {
                    _formKey.currentState!.save();
                    item = ProductItem(name: _productName, price:int.tryParse(_price)! , imageSrc: _imageUrl);
                    widget.onBack?.call(item);
                    // widget.productList!.items.insert(0, item!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sản phẩm đã được thêm')),
                    );
                  }
                  // else {
                  //   print('có lõi ');
                  // }}
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black, width: 1), // Viền đen với độ rộng 1
                  ),
                ),
                child: const Text('Tạo sản phẩm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formInput(String label,
      {bool required = true,
        String? Function(String?)? valid,
        TextInputType? keyboardType,
        Function(String?)? onSaved}) {

    MoneyMaskedTextController? moneyController;

    if (keyboardType == TextInputType.number) {
      moneyController = MoneyMaskedTextController(
          initialValue: 0,
          decimalSeparator: '',
          thousandSeparator: '.',
          rightSymbol: 'đ',
          precision: 0
      );
    }
    return Column(
      children: [
        Row(children: [
          Text(label,style: const TextStyle(fontSize: 17),),
          required
              ? const Row(children: [
            SizedBox(width: 5),
            Text('*',style: TextStyle(color: Colors.red,fontSize: 16),),
          ])
              : Container()
        ]),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(   border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          keyboardType: keyboardType ?? TextInputType.name,
          validator: valid ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return '$label không được để trống';
                }
                return null;
              },
          onSaved: onSaved ,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  String? validateField(FormFieldComponent field, String? value) {
    // Kiểm tra yêu cầu
    if (field.required && (value == null || value.isEmpty)) {
      return 'Trường này là bắt buộc';
    }

    // Kiểm tra độ dài tối đa
    if (field.maxLength != null && value != null && value.length > field.maxLength!) {
      return 'Độ dài tối đa là ${field.maxLength} ký tự';
    }

    // Kiểm tra giá trị tối thiểu và tối đa cho trường số
    if (field.type == "number") {
      final intValue = int.tryParse(value ?? '');
      if (field.minValue != null && intValue != null && intValue < field.minValue!) {
        return 'Giá trị tối thiểu là ${field.minValue}';
      }
      if (field.maxValue != null && intValue != null && intValue > field.maxValue!) {
        return 'Giá trị tối đa là ${field.maxValue}';
      }
    }
    return null;
  }

  String? onSaved(FormFieldComponent field, String? value) {
    if (field.type == "number") {
      setState(() {
        _price = value ?? "0";
      });

    }
    else {
      setState(() {
        _productName = value ?? "";
        print(value);

      });

    }
    return null;
  }
}

