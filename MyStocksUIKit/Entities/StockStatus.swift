//
//  StockStatus.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 25/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct StockStatus {
	/// Open price of the day
	var openPrice: Float
	
	/// High price of the day
	var highPrice: Float
	
	/// Low price of the day
	var lowPrice: Float
	
	/// Current price (used if represents today)
	var currentPrice: Float?
	
	/// Close price (previous close if today)
	var closePrice: Float
	
	/// Volume data
	var volume: Int?
	
	// Timestamp
	var time: Date
	
	// Percentage of change in stock price (used if represents today)
	var percentage: Float? {
		guard let currentPrice = currentPrice, closePrice != 0 else { return nil }
		return ((currentPrice - closePrice) / closePrice) * 100;
	}
}
