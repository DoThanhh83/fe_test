class LabelComponent {
  final String text;

  LabelComponent({required this.text});

  // Method to parse from JSON
  factory LabelComponent.fromJson(Map<String, dynamic> json) {
    return LabelComponent(
      text: json['customAttributes']['label']['text'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': 'Label',
      'customAttributes': {
        'label': {
          'text': text,
        }
      }
    };
  }
}

class FormFieldComponent {
  final String label;
  final bool required;
  final String name;
  final String type;
  final int? maxLength;
  final int? minValue;
  final int? maxValue;

  FormFieldComponent({
    required this.label,
    required this.required,
    required this.name,
    required this.type,
    this.maxLength,
    this.minValue,
    this.maxValue,
  });

  // Method to parse from JSON
  factory FormFieldComponent.fromJson(Map<String, dynamic> json) {
    return FormFieldComponent(
      label: json['label'],
      required: json['required'] ?? false,
      name: json['name'],
      type: json['type'],
      maxLength: json['maxLength'],
      minValue: json['minValue'],
      maxValue: json['maxValue'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'required': required,
      'name': name,
      'type': type,
      if (maxLength != null) 'maxLength': maxLength,
      if (minValue != null) 'minValue': minValue,
      if (maxValue != null) 'maxValue': maxValue,
    };
  }
}

class ProductSubmitForm {
  final List<FormFieldComponent> fields;

  ProductSubmitForm({required this.fields});

  // Method to parse from JSON
  factory ProductSubmitForm.fromJson(Map<String, dynamic> json) {
    var fieldsJson = json['customAttributes']['form'] as List;
    List<FormFieldComponent> fields = fieldsJson.map((fieldJson) => FormFieldComponent.fromJson(fieldJson)).toList();

    return ProductSubmitForm(fields: fields);
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': 'ProductSubmitForm',
      'customAttributes': {
        'form': fields.map((field) => field.toJson()).toList(),
      }
    };
  }
}


class ButtonComponent {
  final String text;

  ButtonComponent({required this.text});

  // Method to parse from JSON
  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      text: json['customAttributes']['button']['text'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': 'Button',
      'customAttributes': {
        'button': {
          'text': text,
        }
      }
    };
  }
}


class ProductItem {
  final String name;
  final int price;
  final String imageSrc;

  ProductItem({required this.name, required this.price, required this.imageSrc});

  // Method to parse from JSON
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      name: json['name'],
      price: json['price'],
      imageSrc: json['imageSrc'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageSrc': imageSrc,
    };
  }
}

class ProductListComponent {
  final List<ProductItem> items;

  ProductListComponent({required this.items});

  // Method to parse from JSON
  factory ProductListComponent.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['customAttributes']['productlist']['items'] as List;
    List<ProductItem> items = itemsJson.map((itemJson) => ProductItem.fromJson(itemJson)).toList();

    return ProductListComponent(items: items);
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': 'ProductList',
      'customAttributes': {
        'productlist': {
          'items': items.map((item) => item.toJson()).toList(),
        }
      }
    };
  }
}
