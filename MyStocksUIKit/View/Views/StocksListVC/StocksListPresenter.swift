//
//  StocksListPresenter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 11/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PStocksListPresenter: PBasePresenter {
	var items: [CompanyStock] { get }
	var count: Int { get }
	
	func fetchData();
	func addStock(item: CompanyStock, completion: @escaping FetchResultClosure);
	func updateOrder(from indexFrom: Int, to indexTo: Int, completion: @escaping FetchResultClosure);
	func deleteStock(atIndex index: Int, completion: @escaping FetchResultClosure);
}

class StocksListPresenter: BasePresenter, PStocksListPresenter {
	
	// MARK: - Dependencies
	private var interactor: PMainBusiness
	
	// MARK: - Data
	private(set) var items: [CompanyStock]
	
	// MARK: - Data Presentation
	var count: Int {
		return items.count;
	}
	
	// MARK: - Init
	init(interactor: PMainBusiness) {
		self.interactor = interactor;

		items = [];
	}
	
	// MARK: - Functions
	func fetchData() {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return;
		}
		
		// Fetch data
		startFetching();
		interactor.getStocksList { [weak self] (result: PMainBusiness.StocksListResult) in
			switch result {
				case .success(let data):
					self?.items.append(contentsOf: data);
					self?.endFetching();
					self?.delegate?.didCompleteFetching(completionReturn: nil);
					
				case .failure(let error):
					self?.endFetching();
					self?.delegate?.didFailDataFetch(withType: error.type);
			}
		}
	}

	func addStock(item: CompanyStock, completion: @escaping FetchResultClosure) {
		interactor.addStock(item: item) { [weak self] (result: PMainBusiness.GeneralResult) in
			switch result {
				case .success:
					self?.items.append(item);
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}
	
	// TODO: Needs some sort of transaction to roll back in case of data failure.
	func updateOrder(from indexFrom: Int, to indexTo: Int, completion: @escaping FetchResultClosure) {
		// Move in collection
		let movedItem = items.remove(at: indexFrom);
		items.insert(movedItem, at: indexTo);

		// Update data
		let loopFrom = indexFrom < indexTo ? indexFrom : indexTo;
		let loopTo = indexFrom < indexTo ? indexTo : indexFrom;
		
		var isSucess: Bool = true;
		var errorType: ErrorType?

		for i in loopFrom...loopTo {
			items[i].displayOrder = i;

			interactor.updateStock(item: items[i]) { (result: PMainBusiness.GeneralResult) in
				switch result {
					case .success:
						isSucess = isSucess && true;
						
					case .failure(let error):
						completion(false, nil, error.type);
						isSucess = isSucess && false;
						errorType = error.type;
						break;
				}
			}
		}
		
		completion(isSucess, nil, errorType);
	}

	func deleteStock(atIndex index: Int, completion: @escaping FetchResultClosure) {
		interactor.deleteStock(item: items[index]) { [weak self] (result: PMainBusiness.GeneralResult) in
			switch result {
				case .success:
					self?.items.remove(at: index);
					completion(true, nil, nil);
					
				case .failure(let error):
					completion(false, nil, error.type);
			}
		}
	}

}

