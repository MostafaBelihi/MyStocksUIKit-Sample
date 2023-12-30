//
//  AddStockPresenter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 20/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PAddStockPresenter: PBasePresenter {
	var allItems: [CompanyStock] { get }
	var filteredItems: [CompanyStock] { get }

	var count: Int { get }

	func fetchData();
	func filter(with keyword: String);
}

class AddStockPresenter: BasePresenter, PAddStockPresenter {
	
	// MARK: - Dependencies
	private var interactor: PMainBusiness

	// MARK: - Data
	private(set) var allItems: [CompanyStock]
	private(set) var filteredItems: [CompanyStock]

	// MARK: - Data Presentation
	var count: Int {
		return filteredItems.count;
	}
	
	// MARK: - Init
	init(interactor: PMainBusiness) {
		self.interactor = interactor;

		allItems = [];
		filteredItems = [];
	}
	
	// MARK: - Functions
	func fetchData() {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return;
		}
		
		// Fetch data
		startFetching();
		interactor.getExchangeStocksList { [weak self] (result: PMainBusiness.ExchangeStocksListResult) in
			guard let self = self else { return }
			switch result {
				case .success(let data):
					self.allItems = data;
					self.filteredItems = self.allItems.map { $0 };
					
					self.endFetching();
					self.delegate?.didCompleteFetching(completionReturn: nil);
					
				case .failure(let error):
					self.endFetching();
					self.delegate?.didFailDataFetch(withType: error.type);
			}
		}
	}
	
	func filter(with keyword: String) {
		if (keyword.isEmpty) {
			filteredItems = allItems.map { $0 };
		}
		else {
			filteredItems = allItems.filter {
				$0.name?.lowercased().contains(keyword) ?? false || $0.symbol.lowercased().contains(keyword);
			}
		}
	}

}

