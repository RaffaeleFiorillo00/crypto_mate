import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { buy, sell }

class TransactionModel {
  final String id;
  final String symbol;
  final double amount;
  final double price;
  final TransactionType type;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.symbol,
    required this.amount,
    required this.price,
    required this.type,
    required this.date,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      symbol: data['symbol'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      price: (data['price'] ?? 0.0).toDouble(),
      type: data['type'] == 'sell' ? TransactionType.sell : TransactionType.buy,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'amount': amount,
      'price': price,
      'type': type == TransactionType.sell ? 'sell' : 'buy',
      'date': Timestamp.fromDate(date),
    };
  }

  double get totalValue => amount * price;

  TransactionModel copyWith({
    String? id,
    String? symbol,
    double? amount,
    double? price,
    TransactionType? type,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
} 