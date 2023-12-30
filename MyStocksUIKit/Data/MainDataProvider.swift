//
//  MainDataProvider.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

class MainDataProvider: PDataRequests {
	
	// MARK: - Dependencies
	private var dbData: PDBData;
	private var networkAPIData: PNetworkAPIData;

	// MARK: - Data
	
	
	// MARK: - Init
	init(dbData: PDBData, networkAPIData: PNetworkAPIData) {
		self.dbData = dbData;
		self.networkAPIData = networkAPIData;
	}
	
	// MARK: - Functions
	func getCompany(symbol: String, completion: @escaping CompanyResultClosure) {
		networkAPIData.getCompanyProfile(symbol: symbol) { [weak self] (result: PNetworkAPIData.CompanyProfileResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: APICompanyProfileToCompanyAdapter());
					let item = adapter.convert(from: data);
					completion(.success(item));
					
				case .failure(let data):
					let error = self.convertAPIError(data: data);
					completion(.failure(error));
			}
		}
	}

	func getStocksList(completion: @escaping StocksListResultClosure) {
		dbData.loadStocks { [weak self] (result: PDBData.StocksListResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: DBStockToCompanyStockAdapter());
					let items = adapter.convert(from: data);
					completion(.success(items));
					
				case .failure(let data):
					let error = self.convertDBError(data: data);
					completion(.failure(error));
			}
		}
	}

	func getStockStatus(symbol: String, completion: @escaping StockStatusResultClosure) {
		networkAPIData.getQuote(symbol: symbol) { [weak self] (result: PNetworkAPIData.QuoteResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: APIQuoteToStockStatusAdapter());
					let item = adapter.convert(from: data);
					completion(.success(item));
					
				case .failure(let data):
					let error = self.convertAPIError(data: data);
					completion(.failure(error));
			}
		}
	}
	
	func getRecentStockStatusList(symbol: String, for period: ChartPeriod, completion: @escaping StockStatusListResultClosure) {
		// Dates
		let dateTo = Date();
		let dateFrom = dateTo.alter(days: period.rawValue * -1);
		
		// CandleResolution
		var candleResolution = APIConstants.CandleResolution.day;
		switch period {
			case .week: 	candleResolution = .min60;
			case .month: 	candleResolution = .min60;
			case .year: 	candleResolution = .day;
		}

		networkAPIData.getStockCandle(symbol: symbol,
									  resolution: candleResolution.rawValue,
									  dateFrom: dateFrom,
									  dateTo: dateTo) { [weak self] (result: PNetworkAPIData.StockCandleResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: APIStockCandleToStockStatusAdapter());
					let items = adapter.convert(from: data) ?? [];
					completion(.success(items));
					
				case .failure(let data):
					let error = self.convertAPIError(data: data);
					completion(.failure(error));
			}
		}
	}

	func getCompanyNews(symbol: String, from: Date, to: Date, completion: @escaping CompanyNewsListResultClosure) {
		networkAPIData.getCompanyNews(symbol: symbol,
									  dateFrom: from,
									  dateTo: to) { [weak self] (result: PNetworkAPIData.CompanyNewsResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: APICompanyNewsToCompanyNewsAdapter());
					let items = adapter.convert(from: data);
					completion(.success(items));
					
				case .failure(let data):
					let error = self.convertAPIError(data: data);
					completion(.failure(error));
			}
		}
	}

	func getExchangeStocksList(exchangeSymbol: String, completion: @escaping ExchangeStocksListResultClosure) {
		networkAPIData.getExchangeStocksList(exchange: exchangeSymbol) { [weak self] (result: PNetworkAPIData.ExchangeStocksListResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					let adapter = Adapter(typeAdapter: APIStockToCompanyStockAdapter());
					let items = adapter.convert(from: data);
					completion(.success(items));
					
				case .failure(let data):
					let error = self.convertAPIError(data: data);
					completion(.failure(error));
			}
		}
	}

	func addStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		let model = convertCompanyStockToDBStock(data: item);

		dbData.addStock(item: model) { [weak self] (result: PDBData.GeneralResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					completion(.success(data));
					
				case .failure(let data):
					let error = self.convertDBError(data: data)
					completion(.failure(error));
			}
		}
	}

	func updateStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		let model = convertCompanyStockToDBStock(data: item);

		dbData.updateStock(item: model) { [weak self] (result: PDBData.GeneralResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					completion(.success(data));
					
				case .failure(let data):
					let error = self.convertDBError(data: data)
					completion(.failure(error));
			}
		}
	}

	func deleteStock(item: CompanyStock, completion: @escaping GeneralResultClosure) {
		let model = convertCompanyStockToDBStock(data: item);

		dbData.deleteStock(item: model) { [weak self] (result: PDBData.GeneralResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					completion(.success(data));
					
				case .failure(let data):
					let error = self.convertDBError(data: data)
					completion(.failure(error));
			}
		}
	}

	func seedInitStocks(completion: @escaping GeneralResultClosure) {
		dbData.seedInitStockData { [weak self] (result: PDBData.GeneralResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					completion(.success(data));
					
				case .failure(let data):
					let error = self.convertDBError(data: data)
					completion(.failure(error));
			}
		}
	}
	
	func setFlagDidAppFirstLaunch() {
		dbData.setFlagDidAppFirstLaunch();
	}
	
	func getFlagDidAppFirstLaunch() -> Bool {
		dbData.getFlagDidAppFirstLaunch();
	}


	// MARK: - Private
	private func convertDBError(data: DataError<DBError>) -> AppError {
		let adapter = Adapter(typeAdapter: DBErrorToAppErrorAdapter());
		return adapter.convert(from: data);
	}

	private func convertAPIError(data: DataError<APIError>) -> AppError {
		let adapter = Adapter(typeAdapter: APIErrorToAppErrorAdapter());
		return adapter.convert(from: data);
	}
	
	private func convertCompanyStockToDBStock(data: CompanyStock) -> DBStock {
		let adapter = Adapter(typeAdapter: CompanyStockToDBStockAdapter());
		return adapter.convert(from: data);
	}

}
