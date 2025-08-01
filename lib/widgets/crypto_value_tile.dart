import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CryptoValueTile extends StatelessWidget {
  final String symbol;
  final String name;
  final double amount;
  final double currentPrice;
  final double averagePrice;
  final VoidCallback? onTap;

  const CryptoValueTile({
    Key? key,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.currentPrice,
    required this.averagePrice,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentValue = amount * currentPrice;
    final totalCost = amount * averagePrice;
    final profitLoss = currentValue - totalCost;
    final profitLossPercentage = averagePrice > 0 
        ? ((currentPrice - averagePrice) / averagePrice) * 100 
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.paddingSmall,
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with symbol and profit/loss
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radius),
                        ),
                        child: Center(
                          child: Text(
                            symbol,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingSmall),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symbol,
                            style: AppTextStyles.headline2,
                          ),
                          Text(
                            name,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Helpers.formatCurrency(profitLoss),
                        style: AppTextStyles.body1.copyWith(
                          color: profitLoss >= 0 ? AppColors.profit : AppColors.loss,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${profitLossPercentage >= 0 ? '+' : ''}${profitLossPercentage.toStringAsFixed(2)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: profitLossPercentage >= 0 ? AppColors.profit : AppColors.loss,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.padding),
              
              // Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.amount,
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${amount.toStringAsFixed(4)} $symbol',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppStrings.currentValue,
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        Helpers.formatCurrency(currentValue),
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingSmall),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avg Price',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        Helpers.formatCurrency(averagePrice),
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Current Price',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        Helpers.formatCurrency(currentPrice),
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 