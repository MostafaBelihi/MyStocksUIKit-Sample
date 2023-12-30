//
//  APIStock.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 19/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct APIStock: Codable {
	var symbol: String
	var displaySymbol: String
	var description: String
	var currency: String
	var type: String
}
