class MarketDataModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double marketCapRank;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final double ath;
  final double athChangePercentage;
  final DateTime athDate;
  final double atl;
  final double atlChangePercentage;
  final DateTime atlDate;
  final DateTime lastUpdated;

  MarketDataModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.lastUpdated,
  });

  factory MarketDataModel.fromJson(Map<String, dynamic> json) {
    return MarketDataModel(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      marketCapRank: (json['market_cap_rank'] ?? 0.0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0.0).toDouble(),
      high24h: (json['high_24h'] ?? 0.0).toDouble(),
      low24h: (json['low_24h'] ?? 0.0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0.0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      marketCapChange24h: (json['market_cap_change_24h'] ?? 0.0).toDouble(),
      marketCapChangePercentage24h: (json['market_cap_change_percentage_24h'] ?? 0.0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0.0).toDouble(),
      totalSupply: (json['total_supply'] ?? 0.0).toDouble(),
      maxSupply: (json['max_supply'] ?? 0.0).toDouble(),
      ath: (json['ath'] ?? 0.0).toDouble(),
      athChangePercentage: (json['ath_change_percentage'] ?? 0.0).toDouble(),
      athDate: DateTime.parse(json['ath_date'] ?? DateTime.now().toIso8601String()),
      atl: (json['atl'] ?? 0.0).toDouble(),
      atlChangePercentage: (json['atl_change_percentage'] ?? 0.0).toDouble(),
      atlDate: DateTime.parse(json['atl_date'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_change_24h': marketCapChange24h,
      'market_cap_change_percentage_24h': marketCapChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate.toIso8601String(),
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate.toIso8601String(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
} 