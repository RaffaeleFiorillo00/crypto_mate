import 'package:flutter/material.dart';
import '../models/market_data_model.dart';
import '../services/api_service.dart';
import '../widgets/market_data_card.dart';
import '../utils/constants.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final ApiService _apiService = ApiService();
  List<MarketDataModel> _marketData = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMarketData();
  }

  Future<void> _loadMarketData() async {
    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final data = await _apiService.fetchTopMarketData(perPage: 100);
      setState(() {
        _marketData = data;
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = 'Errore nel caricamento dei dati di mercato: $e';
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadMarketData();
  }

  void _onCryptoTap(MarketDataModel marketData) {
    // Navigate to crypto detail screen
    Navigator.pushNamed(
      context,
      '/crypto-detail',
      arguments: marketData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercato Crypto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSizes.spacing),
            Text(
              _errorMessage,
              style: AppTextStyles.body1.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing),
            ElevatedButton(
              onPressed: _loadMarketData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (_marketData.isEmpty) {
      return const Center(
        child: Text(
          'Nessun dato disponibile',
          style: AppTextStyles.body1,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppSizes.padding),
        itemCount: _marketData.length,
        itemBuilder: (context, index) {
          final marketData = _marketData[index];
          return MarketDataCard(
            marketData: marketData,
            onTap: () => _onCryptoTap(marketData),
          );
        },
      ),
    );
  }
} 