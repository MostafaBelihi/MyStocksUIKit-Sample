//
//  DBStock.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import CoreData

struct DBStock {
	var symbol: String
	var description: String
	var displayOrder: Int = 0
}

// MARK: - CoreData keys
extension DBStock {
	static var entityName = "Stock";
	static var uniqueKey = "symbol";
	static var defaultSortKey = "displayOrder";
}

// MARK: - CoreData adaprer
class NSManagedObjectToDBStockAdapter: TypeAdapter {
	// NSManagedObject -> DBStock
	func convert(from model: NSManagedObject) -> DBStock {
		return DBStock(symbol: model.value(forKey: "symbol") as! String,
					   description: model.value(forKey: "itemDescription") as! String,
					   displayOrder: model.value(forKey: "displayOrder") as! Int);
	}
}
