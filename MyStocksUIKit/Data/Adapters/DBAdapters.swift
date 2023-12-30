//
//  DBAdapters.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class DBErrorToAppErrorAdapter: TypeAdapter {
	// DBError -> AppError
	func convert(from model: DataError<DBError>) -> AppError {
		return AppError(message: model.error?.error.message,
						type: model.type);
	}
}

class DBStockToCompanyStockAdapter: TypeAdapter {
	// DBStock -> CompanyStock
	func convert(from model: DBStock) -> CompanyStock {
		return CompanyStock(symbol: model.symbol,
							name: model.description,
							displayOrder: model.displayOrder);
	}
}

class CompanyStockToDBStockAdapter: TypeAdapter {
	// CompanyStock -> CompanyStock
	func convert(from model: CompanyStock) -> DBStock {
		return DBStock(symbol: model.symbol,
					   description: model.name ?? "",
					   displayOrder: model.displayOrder);
	}
}
