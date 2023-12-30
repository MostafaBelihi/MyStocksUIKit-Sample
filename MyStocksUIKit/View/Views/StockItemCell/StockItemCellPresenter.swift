//
//  StockItemCellPresenter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 13/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PStockItemCellPresenter: PBasePresenter {
	var symbol: String { get }
	var companyName: String? { get }
	var marketCap: String? { get }
	var price: String? { get }
	var percentage: String? { get }
	var stockProgressStatus: StockProgressStatus { get }

	func fetchStockStatus(completion: @escaping FetchResultClosure);
	func fetchCompany(completion: @escaping FetchResultClosure);
}

class StockItemCellPresenter: BasePresenter, PStockItemCellPresenter {

	// MARK: - Dependencies
	internal var interactor: PMainBusiness;

	// MARK: - Data
	private(set) var stock: CompanyStock
	private(set) var stockStatus: StockStatus!
	
	// MARK: - Data presentation
	var symbol: String {
		return stock.symbol;
	}
	
	var companyName: String? {
		return stock.company?.name ?? stock.name;
	}
	
	var marketCap: String? {
		guard let marketCap = stock.company?.marketCap else { return nil }
		
		return Math.formatMoneyNumber(number: Double(marketCap),
									  withThousandSeparators: true,
									  originalNumberFactor: .million,
									  newNumberFactor: .auto,
									  currency: .none);
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
	init(with item: CompanyStock, interactor: PMainBusiness) {
		self.stock = item;
		self.interactor = interactor;
	}

	// MARK: - Functions
	func fetchStockStatus(completion: @escaping FetchResultClosure) {
		// Fetch data
		interactor.getStockStatus(symbol: stock.symbol) { [weak self] (result: PMainBusiness.StockStatusResult) in
			switch result {
				case .success(let data):
					self?.stockStatus = data;
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}

	func fetchCompany(completion: @escaping FetchResultClosure) {
		// Fetch data
		interactor.getCompany(symbol: stock.symbol) { [weak self] (result: PMainBusiness.CompanyResult) in
			switch result {
				case .success(let data):
					self?.stock.company = data;
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}

}

enum StockProgressStatus {
	case neutral
	case positive
	case negative
}
