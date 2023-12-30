//
//  APIQuote.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 23/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct APIQuote: Codable {
	/// Open price of the day
	var o: Float
	
	/// High price of the day
	var h: Float
	
	/// Low price of the day
	var l: Float
	
	/// Current price
	var c: Float
	
	/// Previous close price
	var pc: Float
	
	// UNIX timestamp
	var t: Int
}
