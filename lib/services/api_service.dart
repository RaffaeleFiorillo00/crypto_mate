import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  // Get current prices for multiple cryptocurrencies
  Future<Map<String, double>> fetchCryptoPrices(List<String> ids) async {
    try {
      String idsParam = ids.join(',');
      String url = '$_baseUrl/simple/price?ids=$idsParam&vs_currencies=usd';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, double> prices = {};
        
        data.forEach((key, value) {
          if (value is Map<String, dynamic> && value.containsKey('usd')) {
            prices[key] = (value['usd'] as num).toDouble();
          }
        });
        
        return prices;
      } else {
        print('Error fetching crypto prices: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching crypto prices: $e');
      return {};
    }
  }

  // Get detailed information about a cryptocurrency
  Future<Map<String, dynamic>?> fetchCryptoDetails(String id) async {
    try {
      String url = '$_baseUrl/coins/$id';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error fetching crypto details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching crypto details: $e');
      return null;
    }
  }

  // Get historical data for a cryptocurrency
  Future<List<Map<String, dynamic>>> fetchHistoricalData(
    String id, 
    int days, 
    String currency
  ) async {
    try {
      String url = '$_baseUrl/coins/$id/market_chart?vs_currency=$currency&days=$days';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> prices = data['prices'] ?? [];
        
        return prices.map((price) {
          return {
            'timestamp': price[0],
            'price': price[1],
          };
        }).toList();
      } else {
        print('Error fetching historical data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching historical data: $e');
      return [];
    }
  }

  // Get list of supported cryptocurrencies
  Future<List<Map<String, dynamic>>> fetchSupportedCoins() async {
    try {
      String url = '$_baseUrl/coins/list';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((coin) => Map<String, dynamic>.from(coin)).toList();
      } else {
        print('Error fetching supported coins: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching supported coins: $e');
      return [];
    }
  }

  // Convert symbol to CoinGecko ID
  String symbolToId(String symbol) {
    Map<String, String> symbolToIdMap = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'USDT': 'tether',
      'BNB': 'binancecoin',
      'SOL': 'solana',
      'ADA': 'cardano',
      'XRP': 'ripple',
      'DOT': 'polkadot',
      'DOGE': 'dogecoin',
      'AVAX': 'avalanche-2',
      'MATIC': 'matic-network',
      'LINK': 'chainlink',
      'UNI': 'uniswap',
      'LTC': 'litecoin',
      'BCH': 'bitcoin-cash',
      'XLM': 'stellar',
      'ATOM': 'cosmos',
      'FTM': 'fantom',
      'ALGO': 'algorand',
      'VET': 'vechain',
    };
    
    return symbolToIdMap[symbol.toUpperCase()] ?? symbol.toLowerCase();
  }

  // Convert CoinGecko ID to symbol
  String idToSymbol(String id) {
    Map<String, String> idToSymbolMap = {
      'bitcoin': 'BTC',
      'ethereum': 'ETH',
      'tether': 'USDT',
      'binancecoin': 'BNB',
      'solana': 'SOL',
      'cardano': 'ADA',
      'ripple': 'XRP',
      'polkadot': 'DOT',
      'dogecoin': 'DOGE',
      'avalanche-2': 'AVAX',
      'matic-network': 'MATIC',
      'chainlink': 'LINK',
      'uniswap': 'UNI',
      'litecoin': 'LTC',
      'bitcoin-cash': 'BCH',
      'stellar': 'XLM',
      'cosmos': 'ATOM',
      'fantom': 'FTM',
      'algorand': 'ALGO',
      'vechain': 'VET',
    };
    
    return idToSymbolMap[id] ?? id.toUpperCase();
  }
} 