//
//  DBConstants.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct DBConstants {
	static let initStocks = [
		DBStock(symbol: "AAPL", description: "APPLE INC", displayOrder: 0),
		DBStock(symbol: "GOOGL", description: "ALPHABET INC-CL C", displayOrder: 1),
		DBStock(symbol: "MSFT", description: "MICROSOFT CORP", displayOrder: 2),
		DBStock(symbol: "NKE", description: "NIKE INC -CL B", displayOrder: 3),
		DBStock(symbol: "SBUX", description: "STARBUCKS CORP", displayOrder: 4),
		DBStock(symbol: "META", description: "META PLATFORMS INC", displayOrder: 5),
		DBStock(symbol: "ADBE", description: "ADOBE INC", displayOrder: 6),
		DBStock(symbol: "UBER", description: "UBER TECHNOLOGIES INC", displayOrder: 7),
		DBStock(symbol: "SNAP", description: "SNAP INC - A", displayOrder: 8),
		DBStock(symbol: "ORCL", description: "ORACLE CORP", displayOrder: 9)
	];
	
	static let stockModelSpecialAttributeNames = [
		"description": "itemDescription"
	];
	
	static let keyDidAppFirstLaunch = "didAppFirstLaunch";
}
