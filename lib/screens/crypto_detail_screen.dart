import 'package:flutter/material.dart';
import '../models/market_data_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CryptoDetailScreen extends StatefulWidget {
  final MarketDataModel marketData;

  const CryptoDetailScreen({
    Key? key,
    required this.marketData,
  }) : super(key: key);

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  final ApiService _apiService = ApiService();
  MarketDataModel? _detailedData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetailedData();
  }

  Future<void> _loadDetailedData() async {
    try {
      final data = await _apiService.fetchCryptoMarketData(widget.marketData.id);
      setState(() {
        _detailedData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.marketData.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSizes.spacingLarge),
                  _buildPriceSection(),
                  const SizedBox(height: AppSizes.spacingLarge),
                  _buildMarketStats(),
                  const SizedBox(height: AppSizes.spacingLarge),
                  _buildSupplyInfo(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Row(
          children: [
            // Crypto icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.background,
              ),
              child: widget.marketData.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.marketData.image,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              widget.marketData.symbol,
                              style: AppTextStyles.headline2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.marketData.symbol,
                        style: AppTextStyles.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: AppSizes.spacing),
            
            // Crypto info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.marketData.name,
                    style: AppTextStyles.headline2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.marketData.symbol,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Rank #${widget.marketData.marketCapRank.toInt()}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    final isPositive = widget.marketData.priceChangePercentage24h >= 0;
    final changeColor = isPositive ? AppColors.profit : AppColors.loss;
    final changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prezzo Attuale',
              style: AppTextStyles.body1.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              Helpers.formatCurrency(widget.marketData.currentPrice),
              style: AppTextStyles.headline1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacing),
            Row(
              children: [
                Icon(
                  changeIcon,
                  color: changeColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.marketData.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: AppTextStyles.body1.copyWith(
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${Helpers.formatCurrency(widget.marketData.priceChange24h)})',
                  style: AppTextStyles.body1.copyWith(
                    color: changeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24h High',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        Helpers.formatCurrency(widget.marketData.high24h),
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24h Low',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        Helpers.formatCurrency(widget.marketData.low24h),
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiche di Mercato',
              style: AppTextStyles.headline2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacing),
            _buildStatRow('Market Cap', Helpers.formatCurrency(widget.marketData.marketCap)),
            _buildStatRow('Volume 24h', Helpers.formatCurrency(widget.marketData.totalVolume)),
            if (_detailedData != null) ...[
              _buildStatRow('ATH', Helpers.formatCurrency(_detailedData!.ath)),
              _buildStatRow('ATH Change', '${_detailedData!.athChangePercentage.toStringAsFixed(2)}%'),
              _buildStatRow('ATL', Helpers.formatCurrency(_detailedData!.atl)),
              _buildStatRow('ATL Change', '${_detailedData!.atlChangePercentage.toStringAsFixed(2)}%'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSupplyInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informazioni Supply',
              style: AppTextStyles.headline2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacing),
            _buildStatRow('Circulating Supply', '${widget.marketData.circulatingSupply.toStringAsFixed(0)} ${widget.marketData.symbol}'),
            if (widget.marketData.totalSupply > 0) {
              _buildStatRow('Total Supply', '${widget.marketData.totalSupply.toStringAsFixed(0)} ${widget.marketData.symbol}'),
            },
            if (widget.marketData.maxSupply > 0) {
              _buildStatRow('Max Supply', '${widget.marketData.maxSupply.toStringAsFixed(0)} ${widget.marketData.symbol}'),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 