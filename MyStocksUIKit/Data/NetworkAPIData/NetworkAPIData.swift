//
//  NetworkAPIData.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 23/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PNetworkAPIData {
	typealias QuoteResult = Result<APIQuote, DataError<APIError>>;
	typealias QuoteResultClosure = (QuoteResult) -> Void;

	typealias CompanyProfileResult = Result<APICompanyProfile, DataError<APIError>>;
	typealias CompanyProfileResultClosure = (CompanyProfileResult) -> Void;

	typealias StockCandleResult = Result<APIStockCandle, DataError<APIError>>;
	typealias StockCandleResultClosure = (StockCandleResult) -> Void;

	typealias CompanyNewsResult = Result<[APICompanyNews], DataError<APIError>>;
	typealias CompanyNewsResultClosure = (CompanyNewsResult) -> Void;

	typealias ExchangeStocksListResult = Result<[APIStock], DataError<APIError>>;
	typealias ExchangeStocksListResultClosure = (ExchangeStocksListResult) -> Void;

	func getQuote(symbol: String, completion: @escaping QuoteResultClosure);
	func getCompanyProfile(symbol: String, completion: @escaping CompanyProfileResultClosure);
	func getStockCandle(symbol: String, resolution: String, dateFrom: Date, dateTo: Date,
						completion: @escaping StockCandleResultClosure);
	func getCompanyNews(symbol: String, dateFrom: Date, dateTo: Date,
						completion: @escaping CompanyNewsResultClosure);
	func getExchangeStocksList(exchange: String, completion: @escaping ExchangeStocksListResultClosure);
}

class NetworkAPIData: PNetworkAPIData {
	
	// MARK: - Dependencies
	private var networkService: RESTNetworkService<APIEndpoints>;
	
	// MARK: - Init
	init(logger: Logging, dataCoder: PDataCoder?  = nil, connection: Connectivity) {
		var coder: PDataCoder;
		
		if let dataCoder = dataCoder {
			coder = dataCoder;
		}
		else {
			coder = DataCoder(jsonDecoder: APIConstants.jsonDecoder, jsonEncoder: APIConstants.jsonEncoder, logger: logger);
		}
		
		self.networkService = RESTNetworkService<APIEndpoints>(logger: logger,
															   dataCoder: coder,
															   connection: connection);
	}

	// MARK: - Functions
	func getQuote(symbol: String, completion: @escaping QuoteResultClosure) {
		networkService.request(.quote(symbol: symbol)) { (response: HTTPResponse<APIQuote, APIError>) in
			completion(response.result);
		}
	}

	func getCompanyProfile(symbol: String, completion: @escaping CompanyProfileResultClosure) {
		networkService.request(.companyProfile(symbol: symbol)) { (response: HTTPResponse<APICompanyProfile, APIError>) in
			completion(response.result);
		}
	}

	func getStockCandle(symbol: String, resolution: String, dateFrom: Date, dateTo: Date,
						completion: @escaping StockCandleResultClosure) {
		
		networkService.request(.candle(symbol: symbol, resolution: resolution, dateFrom: dateFrom, dateTo: dateTo)) {
			(response: HTTPResponse<APIStockCandle, APIError>) in
			
			completion(response.result);
		}
	}

	func getCompanyNews(symbol: String, dateFrom: Date, dateTo: Date,
						completion: @escaping CompanyNewsResultClosure) {
		
		networkService.request(.companyNews(symbol: symbol, dateFrom: dateFrom, dateTo: dateTo)) {
			(response: HTTPResponse<[APICompanyNews], APIError>) in
			
			completion(response.result);
		}
	}

	func getExchangeStocksList(exchange: String, completion: @escaping ExchangeStocksListResultClosure) {
		networkService.request(.symbols(exchange: exchange)) { (response: HTTPResponse<[APIStock], APIError>) in
			completion(response.result);
		}
	}

}

