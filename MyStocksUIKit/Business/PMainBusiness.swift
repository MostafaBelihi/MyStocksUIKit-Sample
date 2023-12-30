//
//  PMainBusiness.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PMainBusiness {
	typealias CompanyResult = Result<Company, AppError>;
	typealias CompanyResultClosure = (CompanyResult) -> Void;

	typealias StocksListResult = Result<[CompanyStock], AppError>;
	typealias StocksListResultClosure = (StocksListResult) -> Void;

	typealias StockStatusResult = Result<StockStatus, AppError>;
	typealias StockStatusResultClosure = (StockStatusResult) -> Void;

	typealias StockYearStatsResult = Result<StockYearStatsDTO?, AppError>;
	typealias StockYearStatsResultClosure = (StockYearStatsResult) -> Void;

	typealias CompanyNewsResult = Result<[CompanyNews], AppError>;
	typealias CompanyNewsResultClosure = (CompanyNewsResult) -> Void;

	typealias StockStatusListResult = Result<[StockStatus], AppError>;
	typealias StockStatusListResultClosure = (StockStatusListResult) -> Void;

	typealias ExchangeStocksListResult = Result<[CompanyStock], AppError>;
	typealias ExchangeStocksListResultClosure = (ExchangeStocksListResult) -> Void;

	typealias GeneralResult = Result<Bool, AppError>;
	typealias GeneralResultClosure = (GeneralResult) -> Void;

	func seedInitStocks(completion: @escaping GeneralResultClosure);
	
	func getStocksList(completion: @escaping StocksListResultClosure);
	func getExchangeStocksList(completion: @escaping ExchangeStocksListResultClosure);

	func getCompany(symbol: String, completion: @escaping CompanyResultClosure);
	func getCompanyNews(symbol: String, completion: @escaping CompanyNewsResultClosure);

	func getStockStatus(symbol: String, completion: @escaping StockStatusResultClosure);
	func getStockYearStats(symbol: String, completion: @escaping StockYearStatsResultClosure);
	func getRecentStockStatusHistory(symbol: String, for period: ChartPeriod, completion: @escaping StockStatusListResultClosure);

	func addStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
	func updateStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
	func deleteStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
}
