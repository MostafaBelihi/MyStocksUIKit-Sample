//
//  PDataRequests.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PDataRequests {
	typealias CompanyResult = Result<Company, AppError>;
	typealias CompanyResultClosure = (CompanyResult) -> Void;

	typealias StocksListResult = Result<[CompanyStock], AppError>;
	typealias StocksListResultClosure = (StocksListResult) -> Void;

	typealias StockStatusResult = Result<StockStatus, AppError>;
	typealias StockStatusResultClosure = (StockStatusResult) -> Void;

	typealias StockStatusListResult = Result<[StockStatus], AppError>;
	typealias StockStatusListResultClosure = (StockStatusListResult) -> Void;

	typealias CompanyNewsListResult = Result<[CompanyNews], AppError>;
	typealias CompanyNewsListResultClosure = (CompanyNewsListResult) -> Void;

	typealias ExchangeStocksListResult = Result<[CompanyStock], AppError>;
	typealias ExchangeStocksListResultClosure = (ExchangeStocksListResult) -> Void;

	typealias GeneralResult = Result<Bool, AppError>;
	typealias GeneralResultClosure = (GeneralResult) -> Void;
	
	func seedInitStocks(completion: @escaping GeneralResultClosure);
	
	func setFlagDidAppFirstLaunch();
	func getFlagDidAppFirstLaunch() -> Bool;


	func getStocksList(completion: @escaping StocksListResultClosure);
	func getExchangeStocksList(exchangeSymbol: String, completion: @escaping ExchangeStocksListResultClosure);
	
	func getCompany(symbol: String, completion: @escaping CompanyResultClosure);
	func getCompanyNews(symbol: String, from: Date, to: Date,
						completion: @escaping CompanyNewsListResultClosure);
	
	func getStockStatus(symbol: String, completion: @escaping StockStatusResultClosure);
	func getRecentStockStatusList(symbol: String, for period: ChartPeriod,
								  completion: @escaping StockStatusListResultClosure)
	
	func addStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
	func updateStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
	func deleteStock(item: CompanyStock, completion: @escaping GeneralResultClosure);
}
