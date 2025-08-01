import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import '../services/api_service.dart';
import '../widgets/crypto_value_tile.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ApiService _apiService = ApiService();
  
  List<TransactionModel> _transactions = [];
  Map<String, double> _currentPrices = {};
  double _totalPortfolioValue = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
  }

  Future<void> _loadPortfolioData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user transactions (you'll need to get the user ID from auth)
      // For now, we'll use a mock user ID
      const String userId = 'mock_user_id';
      _transactions = await _firestoreService.getUserTransactions(userId).first;
      
      // Get unique crypto symbols
      final Set<String> symbols = _transactions
          .map((transaction) => transaction.symbol)
          .toSet();
      
      // Get current prices for all cryptos in portfolio
      final List<String> coinIds = symbols
          .map((symbol) => _apiService.symbolToId(symbol))
          .toList();
      
      _currentPrices = await _apiService.fetchCryptoPrices(coinIds);
      
      // Calculate portfolio value
      _calculatePortfolioValue();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel caricamento del portfolio: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _calculatePortfolioValue() {
    _totalPortfolioValue = 0.0;
    
    // Group transactions by symbol
    final Map<String, List<TransactionModel>> groupedTransactions = {};
    for (final transaction in _transactions) {
      groupedTransactions.putIfAbsent(transaction.symbol, () => []);
      groupedTransactions[transaction.symbol]!.add(transaction);
    }
    
    // Calculate total value for each crypto
    for (final entry in groupedTransactions.entries) {
      final String symbol = entry.key;
      final List<TransactionModel> transactions = entry.value;
      
      double totalAmount = 0.0;
      double totalCost = 0.0;
      
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.buy) {
          totalAmount += transaction.amount;
          totalCost += transaction.amount * transaction.price;
        } else {
          totalAmount -= transaction.amount;
          totalCost -= transaction.amount * transaction.price;
        }
      }
      
      if (totalAmount > 0) {
        final String coinId = _apiService.symbolToId(symbol);
        final double currentPrice = _currentPrices[coinId] ?? 0.0;
        final double currentValue = totalAmount * currentPrice;
        _totalPortfolioValue += currentValue;
      }
    }
  }

  Map<String, dynamic> _getCryptoSummary(String symbol) {
    final List<TransactionModel> cryptoTransactions = _transactions
        .where((transaction) => transaction.symbol == symbol)
        .toList();
    
    double totalAmount = 0.0;
    double totalCost = 0.0;
    
    for (final transaction in cryptoTransactions) {
      if (transaction.type == TransactionType.buy) {
        totalAmount += transaction.amount;
        totalCost += transaction.amount * transaction.price;
      } else {
        totalAmount -= transaction.amount;
        totalCost -= transaction.amount * transaction.price;
      }
    }
    
    final String coinId = _apiService.symbolToId(symbol);
    final double currentPrice = _currentPrices[coinId] ?? 0.0;
    final double averagePrice = totalAmount > 0 ? totalCost / totalAmount : 0.0;
    
    return {
      'amount': totalAmount,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'totalCost': totalCost,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoMate'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPortfolioData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_transactions.isEmpty) {
      return _buildEmptyState();
    }

    // Get unique crypto symbols
    final Set<String> symbols = _transactions
        .map((transaction) => transaction.symbol)
        .toSet();

    return RefreshIndicator(
      onRefresh: _loadPortfolioData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioSummary(),
            const SizedBox(height: AppSizes.spacingLarge),
            _buildCryptoList(symbols.toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valore Portfolio',
              style: AppTextStyles.body1.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              Helpers.formatCurrency(_totalPortfolioValue),
              style: AppTextStyles.headline1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.spacing),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_transactions.length} transazioni',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoList(List<String> symbols) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Le tue Crypto',
          style: AppTextStyles.headline2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.spacing),
        ...symbols.map((symbol) {
          final summary = _getCryptoSummary(symbol);
          if (summary['amount'] <= 0) return const SizedBox.shrink();
          
          return CryptoValueTile(
            symbol: symbol,
            name: symbol, // You might want to get the full name from an API
            amount: summary['amount'],
            currentPrice: summary['currentPrice'],
            averagePrice: summary['averagePrice'],
            onTap: () {
              // Navigate to crypto detail
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Text(
            'Il tuo portfolio è vuoto',
            style: AppTextStyles.headline2.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.spacing),
          Text(
            'Aggiungi la tua prima transazione per iniziare',
            style: AppTextStyles.body1.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-transaction');
            },
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi Transazione'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingLarge,
                vertical: AppSizes.spacing,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 