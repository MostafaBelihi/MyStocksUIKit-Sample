//
//  DBData.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 04/08/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import CoreData

protocol PDBData {
	typealias StocksListResult = Result<[DBStock], DataError<DBError>>;
	typealias StocksListResultClosure = (StocksListResult) -> Void;

	typealias GeneralResult = Result<Bool, DataError<DBError>>;
	typealias GeneralResultClosure = (GeneralResult) -> Void;

	func loadStocks(completion: @escaping StocksListResultClosure);
	func addStock(item: DBStock, completion: @escaping GeneralResultClosure);
	func updateStock(item: DBStock, completion: @escaping GeneralResultClosure);
	func deleteStock(item: DBStock, completion: @escaping GeneralResultClosure);
	
	func seedInitStockData(completion: @escaping GeneralResultClosure);

	func setFlagDidAppFirstLaunch();
	func getFlagDidAppFirstLaunch() -> Bool;
}

class DBData: PDBData {
	
	// MARK: - Dependencies
	private var logger: Logging
	private var persistentContainer: NSPersistentContainer?
	
	var stockDataManager: CoreDataManager<DBStock>? {
		let dataManager: CoreDataManager<DBStock>? = try? CoreDataManager(logger: logger, persistentContainer: persistentContainer)
		let baseModel = DBStock(symbol: "", description: "");
		dataManager?.config(baseModel: baseModel, entityName: DBStock.entityName, specialAttributeNames: DBConstants.stockModelSpecialAttributeNames);
		
		return dataManager;
	}
	
	// MARK: - Data
	

	// MARK: - Init
	init(logger: Logging, persistentContainer: NSPersistentContainer?) {
		self.logger = logger;
		self.persistentContainer = persistentContainer;
	}
	
	// MARK: - Functions
	func loadStocks(completion: @escaping StocksListResultClosure) {
		guard let dataManager = stockDataManager else {
			completion(.failure(DataError(ofType: .dataError)));
			return;
		}
		
		do {
			let data = try dataManager.fetch(sortDescriptors: [NSSortDescriptor(key: DBStock.defaultSortKey, ascending: true)]);
			let adapter = Adapter(typeAdapter: NSManagedObjectToDBStockAdapter());
			let items = adapter.convert(from: data);
			completion(.success(items));
		}
		catch let error {
			completion(.failure(handleError(error: error)));
		}
	}
	
	func addStock(item: DBStock, completion: @escaping GeneralResultClosure) {
		guard let dataManager = stockDataManager else {
			completion(.failure(DataError(ofType: .dataError)));
			return;
		}
		
		do {
			try dataManager.add(item: item);
			completion(.success(true));
		}
		catch let error {
			completion(.failure(handleError(error: error)));
		}
	}
	
	func updateStock(item: DBStock, completion: @escaping GeneralResultClosure) {
		guard let dataManager = stockDataManager else {
			completion(.failure(DataError(ofType: .dataError)));
			return;
		}
		
		do {
			try dataManager.update(item: item, uniqueKeyName: DBStock.uniqueKey);
			completion(.success(true));
		}
		catch let error {
			completion(.failure(handleError(error: error)));
		}
	}
	
	func deleteStock(item: DBStock, completion: @escaping GeneralResultClosure) {
		guard let dataManager = stockDataManager else {
			completion(.failure(DataError(ofType: .dataError)));
			return;
		}
		
		do {
			try dataManager.delete(item: item, uniqueKeyName: DBStock.uniqueKey);
			completion(.success(true));
		}
		catch let error {
			completion(.failure(handleError(error: error)));
		}
	}
	
	func seedInitStockData(completion: @escaping GeneralResultClosure) {
		guard let dataManager = stockDataManager else {
			completion(.failure(DataError(ofType: .dataError)));
			return;
		}
		
		do {
			for item in DBConstants.initStocks {
				try dataManager.add(item: item);
			}
			
			completion(.success(true));
		}
		catch let error {
			completion(.failure(handleError(error: error)));
		}
	}
	
	func setFlagDidAppFirstLaunch() {
		UserDefaults.standard.set(true, forKey: DBConstants.keyDidAppFirstLaunch);
	}
	
	func getFlagDidAppFirstLaunch() -> Bool {
		UserDefaults.standard.object(forKey: DBConstants.keyDidAppFirstLaunch) as? Bool ?? false;
	}

	// MARK: - Private Functions
	private func handleError(error: Error) -> DataError<DBError> {
		logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "DBData", "Error loading stocks.", error.localizedDescription);

		if let dataManagerError = error as? DataManagerError {
			return DataError(ofType: .dataError, error: DBError(error: dataManagerError));
		}
		else {
			return DataError(ofType: .dataError);
		}
	}

}
