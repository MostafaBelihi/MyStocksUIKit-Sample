//
//  MainInteractor.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class MainInteractor: PMainBusiness {
	
	// MARK: - Dependencies
	private var data: PDataRequests;
	
	// MARK: - Data
	
	
	// MARK: - Init
	init(data: PDataRequests) {
		self.data = data;
	}
	
	// MARK: - Functions
	func getStocksList(completion: @escaping StocksListResultClosure) {
		data.getStocksList { (result: PDataRequests.StocksListResult) in
			switch result {
				case .success(let items):
					completion(.success(items));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getStockStatus(symbol: String, completion: @escaping StockStatusResultClosure) {
		data.getStockStatus(symbol: symbol) { (result: PDataRequests.StockStatusResult) in
			switch result {
				case .success(let item):
					completion(.success(item));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getCompany(symbol: String, completion: @escaping CompanyResultClosure) {
		data.getCompany(symbol: symbol) { (result: PDataRequests.CompanyResult) in
			switch result {
				case .success(let item):
					completion(.success(item));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getStockYearStats(symbol: String, completion: @escaping StockYearStatsResultClosure) {
		// Get list of stock status logs for a year
		data.getRecentStockStatusList(symbol: symbol, for: .year) { (result: PDataRequests.StockStatusListResult) in
			switch result {
				case .success(let items):
					guard items.count > 0 else {
						completion(.success(nil))
						return;
					}
					
					// Build year stats
					let history = StockYearStatsDTO(volume: items[items.count - 1].volume ?? 0,
													highOf52Weeks: items.max(by: { $0.highPrice < $1.highPrice })?.highPrice ?? 0,
													lowOf52Weeks: items.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? 0,
													averageVolume: Math.average(of: items.map({ $0.volume ?? 0 })));
					completion(.success(history));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getCompanyNews(symbol: String, completion: @escaping CompanyNewsResultClosure) {
		data.getCompanyNews(symbol: symbol, from: Date(), to: Date()) { (result: PDataRequests.CompanyNewsListResult) in
			switch result {
				case .success(let items):
					completion(.success(items));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getRecentStockStatusHistory(symbol: String, for period: ChartPeriod, completion: @escaping StockStatusListResultClosure) {
		data.getRecentStockStatusList(symbol: symbol, for: period) { (result: PDataRequests.StockStatusListResult) in
			switch result {
				case .success(let items):
					completion(.success(items));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func getExchangeStocksList(completion: @escaping ExchangeStocksListResultClosure) {
		data.getExchangeStocksList(exchangeSymbol: "US") { (result: PDataRequests.ExchangeStocksListResult) in
			switch result {
				case .success(let items):
					completion(.success(items));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func addStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		data.addStock(item: item) { (result: PDataRequests.GeneralResult) in
			switch result {
				case .success(let done):
					completion(.success(done));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func updateStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		data.updateStock(item: item) { (result: PDataRequests.GeneralResult) in
			switch result {
				case .success(let done):
					completion(.success(done));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func deleteStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		data.deleteStock(item: item) { (result: PDataRequests.GeneralResult) in
			switch result {
				case .success(let done):
					completion(.success(done));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}
	
	func seedInitStocks(completion: @escaping GeneralResultClosure) {
		guard !data.getFlagDidAppFirstLaunch() else {
			completion(.success(true));
			return;
		}
		
		data.seedInitStocks { [weak self] (result: PDataRequests.GeneralResult) in
			guard let self = self else { return }
			switch result {
				case .success(let done):
					self.data.setFlagDidAppFirstLaunch();
					completion(.success(done));
					
				case .failure(let error):
					completion(.failure(error));
			}
		}
	}

}
