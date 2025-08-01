import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            children: [
              // Crypto icon and symbol
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                ),
                child: Center(
                  child: Text(
                    transaction.symbol,
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.padding),
              
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction.symbol,
                          style: AppTextStyles.headline2,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: transaction.type == TransactionType.buy
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radius),
                          ),
                          child: Text(
                            transaction.type == TransactionType.buy
                                ? AppStrings.buy
                                : AppStrings.sell,
                            style: AppTextStyles.caption.copyWith(
                              color: transaction.type == TransactionType.buy
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction.amount.toStringAsFixed(4)} ${transaction.symbol}',
                      style: AppTextStyles.body1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppStrings.price}: ${Helpers.formatCurrency(transaction.price)}',
                      style: AppTextStyles.body2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM dd, yyyy').format(transaction.date),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              
              // Total value and delete button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Helpers.formatCurrency(transaction.totalValue),
                    style: AppTextStyles.headline2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 