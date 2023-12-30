//
//  StockNewsPresenter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 14/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PStockNewsPresenter {
	var companyName: String? { get }
	var price: String? { get }
	var percentage: String? { get }
	var stockProgressStatus: StockProgressStatus { get }
	var news: [CompanyNews]? { get }
}

class StockNewsPresenter: BasePresenter, PStockNewsPresenter {
	
	// MARK: - Dependencies

	
	// MARK: - Data
	internal var stock: CompanyStock
	internal var stockStatus: StockStatus?
	private(set) var news: [CompanyNews]?

	// MARK: - Data Presentation
	var companyName: String? {
		return stock.company?.name ?? stock.name;
	}

	var price: String? {
		guard let currentPrice = stockStatus?.currentPrice else { return nil }
		return Math.formatMoneyNumber(number: Double(currentPrice), currency: .usd, shouldGetCurrencySymbol: true);
	}

	var percentage: String? {
		guard let percentage = stockStatus?.percentage else { return nil }

		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 2
		formatter.minimumFractionDigits = 2

		return "\(formatter.string(for: percentage)!)%";
	}
	
	var stockProgressStatus: StockProgressStatus {
		guard let percentage = stockStatus?.percentage else { return .neutral }
		if (percentage > 0) { return .positive }
		if (percentage < 0) { return .negative }
		return .neutral;
	}

	// MARK: - Init
	init(stock: CompanyStock,
		 stockStatus: StockStatus?,
		 news: [CompanyNews]?
	) {
		self.stock = stock;
		self.stockStatus = stockStatus;
		self.news = news;
	}
	
	// MARK: - Functions
	

}
