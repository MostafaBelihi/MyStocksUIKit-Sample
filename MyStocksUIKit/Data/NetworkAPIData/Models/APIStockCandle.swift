//
//  APIStockCandle.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 30/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class APIStockCandle: Codable {
	/// Open prices
	var o: [Float]?
	
	/// High prices
	var h: [Float]?
	
	/// Low prices
	var l: [Float]?
	
	/// Close prices
	var c: [Float]?
	
	/// Volume data
	var v: [Int]?
	
	// UNIX timestamps
	var t: [Int]?
	
	// Response status ("ok" | "no_data")
	var s: String
}
