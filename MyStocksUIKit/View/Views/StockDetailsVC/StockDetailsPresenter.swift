//
//  StockDetailsPresenter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 05/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Charts

protocol PStockDetailsPresenter: PStockItemCellPresenter {
	var open: String { get }
	var high: String { get }
	var low: String { get }

	var volume: String? { get }
	var highOf52Weeks: String? { get }
	var lowOf52Weeks: String? { get }
	var averageVolume: String? { get }
	
	var stock: CompanyStock { get }
	var stockStatus: StockStatus! { get }
	var news: [CompanyNews]? { get }
	
	var chartDataEntries: [ChartDataEntry] { get }

	func fetchStockStats(completion: @escaping FetchResultClosure);
	func fetchNews(completion: @escaping FetchResultClosure);
	func fetchChartData(for period: ChartPeriod, completion: @escaping FetchResultClosure);
}

class StockDetailsPresenter: StockItemCellPresenter, PStockDetailsPresenter {

	// MARK: - Dependencies

	
	// MARK: - Data
	private var stockStats: StockYearStatsDTO?
	private(set) var news: [CompanyNews]?
	
	private var chartWeekData: [StockStatus]?
	private var chartMonthData: [StockStatus]?
	private var chartYearData: [StockStatus]?
	private var activePeriod: ChartPeriod = .week;

	// MARK: - Data Presentation
	var open: String {
		return Math.formatMoneyNumber(number: Double(stockStatus.openPrice));
	}
	
	var high: String {
		return Math.formatMoneyNumber(number: Double(stockStatus.highPrice));
	}
	
	var low: String {
		return Math.formatMoneyNumber(number: Double(stockStatus.lowPrice));
	}
	
	var volume: String? {
		guard let volume = stockStats?.volume else { return nil }
		return Math.formatMoneyNumber(number: Double(volume), newNumberFactor: .auto);
	}
	
	var highOf52Weeks: String? {
		guard let highOf52Weeks = stockStats?.highOf52Weeks else { return nil }
		return Math.formatMoneyNumber(number: Double(highOf52Weeks));
	}
	
	var lowOf52Weeks: String? {
		guard let lowOf52Weeks = stockStats?.lowOf52Weeks else { return nil }
		return Math.formatMoneyNumber(number: Double(lowOf52Weeks));
	}
	
	var averageVolume: String? {
		guard let averageVolume = stockStats?.averageVolume else { return nil }
		return Math.formatMoneyNumber(number: Double(averageVolume), newNumberFactor: .auto);
	}

	var chartDataEntries: [ChartDataEntry] {
		// ChartDataEntry
		var dataEntries: [ChartDataEntry] = [];
		var chartData: [StockStatus]?;
		
		// Get suitable data per period
		switch activePeriod {
			case .week:
				chartData = chartWeekData;
			
			case .month:
				chartData = chartMonthData;
			
			case .year:
				chartData = chartYearData;
		}

		if let chartData = chartData {
			for i in 0..<chartData.count {
				let value = ChartDataEntry(x: Double(chartData[i].time.timeIntervalSince1970), y: Double(chartData[i].closePrice));
				dataEntries.append(value);
			}
		}
		
		return dataEntries;
	}
	
	// MARK: - Init
	override init(with item: CompanyStock, interactor: PMainBusiness) {
		super.init(with: item, interactor: interactor);
	}

	// MARK: - Functions
	func fetchStockStats(completion: @escaping FetchResultClosure) {
		// Fetch data
		interactor.getStockYearStats(symbol: stock.symbol) { [weak self] (result: PMainBusiness.StockYearStatsResult) in
			switch result {
				case .success(let data):
					self?.stockStats = data;
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}

	func fetchNews(completion: @escaping FetchResultClosure) {
		// Fetch data
		interactor.getCompanyNews(symbol: stock.symbol) { [weak self] (result: PMainBusiness.CompanyNewsResult) in
			switch result {
				case .success(let data):
					self?.news = data;
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}

	func fetchChartData(for period: ChartPeriod, completion: @escaping FetchResultClosure) {
		var isFetched = false;
		activePeriod = period;

		switch period {
			case .week:
				isFetched = chartWeekData != nil;
			
			case .month:
				isFetched = chartMonthData != nil;
			
			case .year:
				isFetched = chartYearData != nil;
		}

		// Fetch data only if was not fetched before
		if (!isFetched) {
			interactor.getRecentStockStatusHistory(symbol: stock.symbol, for: period) { [weak self] (result: PMainBusiness.StockStatusListResult) in
				switch result {
					case .success(let data):
						switch period {
							case .week:
								self?.chartWeekData = data;
								
							case .month:
								self?.chartMonthData = data;
								
							case .year:
								self?.chartYearData = data;
						}
						
						completion(true, nil, nil);
						
					case .failure(let error):
						completion(false, nil, error.type);
				}
			}
		}
		else {
			completion(true, nil, nil);
		}
	}

}
