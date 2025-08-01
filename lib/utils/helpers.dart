import 'package:intl/intl.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }

  // Format percentage
  static String formatPercentage(double percentage) {
    return NumberFormat.decimalPercentPattern(
      decimalDigits: 2,
    ).format(percentage / 100);
  }

  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  // Calculate percentage change
  static double calculatePercentageChange(double oldValue, double newValue) {
    if (oldValue == 0) return 0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  // Calculate profit/loss
  static double calculateProfitLoss(double currentValue, double totalCost) {
    return currentValue - totalCost;
  }

  // Calculate profit/loss percentage
  static double calculateProfitLossPercentage(double currentValue, double totalCost) {
    if (totalCost == 0) return 0;
    return ((currentValue - totalCost) / totalCost) * 100;
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Get color based on profit/loss
  static String getProfitLossColor(double value) {
    if (value > 0) return '#4CAF50'; // Green
    if (value < 0) return '#F44336'; // Red
    return '#9E9E9E'; // Grey
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Format large numbers
  static String formatLargeNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  // Get crypto icon URL
  static String getCryptoIconUrl(String symbol) {
    return 'https://assets.coingecko.com/coins/images/1/large/${symbol.toLowerCase()}.png';
  }

  // Calculate average price
  static double calculateAveragePrice(List<double> prices, List<double> amounts) {
    if (prices.isEmpty || amounts.isEmpty) return 0;
    
    double totalValue = 0;
    double totalAmount = 0;
    
    for (int i = 0; i < prices.length; i++) {
      totalValue += prices[i] * amounts[i];
      totalAmount += amounts[i];
    }
    
    return totalAmount > 0 ? totalValue / totalAmount : 0;
  }

  // Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 