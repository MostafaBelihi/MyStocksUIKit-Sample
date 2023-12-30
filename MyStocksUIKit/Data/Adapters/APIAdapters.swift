//
//  APIAdapters.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 25/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class APIErrorToAppErrorAdapter: TypeAdapter {
	// APIError -> AppError
	func convert(from model: DataError<APIError>) -> AppError {
		return AppError(message: model.error?.error,
						type: model.type);
	}
}

class APIQuoteToStockStatusAdapter: TypeAdapter {
	// APIQuote -> StockStatus
	func convert(from model: APIQuote) -> StockStatus {
		return StockStatus(openPrice: model.o,
						   highPrice: model.h,
						   lowPrice: model.l,
						   currentPrice: model.c,
						   closePrice: model.pc,
						   time: Date(timeIntervalSince1970: Double(model.t)))
	}
}

class APICompanyProfileToCompanyAdapter: TypeAdapter {
	// APICompanyProfile -> Company
	func convert(from model: APICompanyProfile) -> Company {
		return Company(name: model.name, marketCap: model.marketCapitalization);
	}
}

class APIStockCandleToStockStatusAdapter: TypeAdapter {
	// APIStockCandle -> StockStatus
	func convert(from model: APIStockCandle) -> [StockStatus]? {
		// Count of all arrays must be equal
		guard let o = model.o,
			  let h = model.h,
			  let l = model.l,
			  let c = model.c,
			  let v = model.v,
			  let t = model.t
		else {
			return nil;
		}
		
		let values = [o.count, h.count, l.count, c.count, v.count, t.count];
		let valueSet = Set(values);
		
		guard valueSet.count == 1 else { return nil }
		
		guard o.count > 0 else { return nil }
		
		// Convert
		var items: [StockStatus] = [];
		
		for i in 0..<o.count {
			items.append(StockStatus(openPrice: o[i],
									 highPrice: h[i],
									 lowPrice: l[i],
									 closePrice: c[i],
									 volume: v[i],
									 time: Date(timeIntervalSince1970: Double(t[i]))));
		}

		return items;
	}
}

class APICompanyNewsToCompanyNewsAdapter: TypeAdapter {
	// APICompanyNews -> CompanyNews
	func convert(from model: APICompanyNews) -> CompanyNews {
		return CompanyNews(id: model.id, title: model.headline, image: model.image, url: model.url);
	}
}

class APIStockToCompanyStockAdapter: TypeAdapter {
	// APIStock -> CompanyStock
	func convert(from model: APIStock) -> CompanyStock {
		return CompanyStock(symbol: model.symbol, name: model.description, displayOrder: 0);
	}
}
