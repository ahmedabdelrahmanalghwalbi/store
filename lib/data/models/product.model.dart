import 'package:equatable/equatable.dart';
import 'package:store/data/models/base.model.dart';

class ProductModel extends Equatable {
  final int? id;
  final String? title;
  final double? price;
  final String? image;
  final String? category;
  final String? description;
  final RatingModel? rating;

  const ProductModel({
    this.id,
    this.title,
    this.price,
    this.image,
    this.category,
    this.description,
    this.rating,
  });

  @override
  List<Object?> get props => [id, title, price, image, category, description];

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    String? category,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: BaseModel.parseInt(json['id']),
      title: BaseModel.parseString(json['title']),
      price: BaseModel.parseDouble(json['price']),
      image: BaseModel.parseString(json['image']),
      category: BaseModel.parseString(json['category']),
      description: BaseModel.parseString(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'description': description,
    };
  }
}

class RatingModel extends Equatable {
  final double rate;
  final int count;

  const RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: BaseModel.parseDouble(json['rate']) ?? 0.0,
      count: BaseModel.parseInt(json['count']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};

  @override
  List<Object> get props => [rate, count];
}
