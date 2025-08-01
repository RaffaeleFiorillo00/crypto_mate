import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user transactions
  Stream<List<TransactionModel>> getUserTransactions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    });
  }

  // Add transaction
  Future<void> addTransaction(String userId, TransactionModel transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .add(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Update transaction
  Future<void> updateTransaction(String userId, TransactionModel transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String userId, String transactionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Get transactions by symbol
  Stream<List<TransactionModel>> getTransactionsBySymbol(String userId, String symbol) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('symbol', isEqualTo: symbol)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    });
  }

  // Update user portfolio value
  Future<void> updateUserPortfolioValue(String userId, double portfolioValue) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'portfolioValue': portfolioValue});
    } catch (e) {
      print('Error updating portfolio value: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Get portfolio summary
  Future<Map<String, double>> getPortfolioSummary(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();

      Map<String, double> portfolio = {};
      
      for (var doc in snapshot.docs) {
        TransactionModel transaction = TransactionModel.fromFirestore(doc);
        String symbol = transaction.symbol;
        
        if (portfolio.containsKey(symbol)) {
          if (transaction.type == TransactionType.buy) {
            portfolio[symbol] = portfolio[symbol]! + transaction.amount;
          } else {
            portfolio[symbol] = portfolio[symbol]! - transaction.amount;
          }
        } else {
          if (transaction.type == TransactionType.buy) {
            portfolio[symbol] = transaction.amount;
          } else {
            portfolio[symbol] = -transaction.amount;
          }
        }
      }

      // Remove symbols with zero or negative amounts
      portfolio.removeWhere((key, value) => value <= 0);
      
      return portfolio;
    } catch (e) {
      print('Error getting portfolio summary: $e');
      return {};
    }
  }
} 