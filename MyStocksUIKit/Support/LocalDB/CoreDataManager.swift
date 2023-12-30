//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import CoreData

// TODO: This class needs further improvements.
class CoreDataManager<T> {
	// MARK: - Dependencies
	private var logger: Logging

	// MARK: - Variables
	private var dbContext: NSManagedObjectContext
	
	// MARK: - More Variables
	private var baseModel: T!
	private var entityName: String!
	private var specialAttributeNames: [String: String]?
	
	private let logTitle = "CoreDataManager";
	
	// MARK: - Init
	init(logger: Logging, persistentContainer: NSPersistentContainer?) throws {
		guard let persistentContainer = persistentContainer else {
			throw DataManagerError.initializationFailure;
		}
		
		self.logger = logger;
		
		// Get NSManagedObjectContext
		dbContext = persistentContainer.viewContext;
	}
	
	func config(baseModel: T, entityName: String? = nil, specialAttributeNames: [String: String]? = nil) {
		self.baseModel = baseModel;
		self.entityName = entityName ?? "\(T.self)";
		self.specialAttributeNames = specialAttributeNames;
	}
	
	// MARK: - Functions
	// TODO: Improvment: Add exception list if there are properties that are not added to Core Data model
	func add(item: T) throws {
		// Create new ManagedObject to add data to
		let entity = NSEntityDescription.entity(forEntityName: entityName, in: dbContext)!
		let dbObject = NSManagedObject(entity: entity, insertInto: dbContext)
		
		// Set data: Loop though item properties
		let objectMirror = Mirror(reflecting: item);
		for child in objectMirror.children  {
			if let propKey = child.label {
				var keyPath = propKey;
				
				// Check specialAttributeNames first: used in case some properties were added with unmatched attribute names in the data model
				if let specialAttributeNames = specialAttributeNames {
					keyPath = specialAttributeNames[propKey] ?? propKey;
				}

				// Add data to ManagedObject
				dbObject.setValue(child.value, forKeyPath: keyPath);
			}
		}
		
		// Save ManagedObject
		do {
			try dbContext.save();
		}
		catch let error as NSError {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Error while adding data", error, error.userInfo);
			throw DataManagerError.dataSaveError;
		}
	}

	// TODO: Improve
	// TODO: 'uniqueKeyName' is not checked against 'specialAttributeNames', assuming it will have the same name as its respective proprty name in the model struct/class.
	func update(item: T, uniqueKeyName: String) throws {
		let objectMirror = Mirror(reflecting: item);
		
		// Get matching 'uniqueProperty'
		guard let uniqueProperty = objectMirror.children.first(where: { $0.label == uniqueKeyName }) else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Cannot find a matching uniqueProperty.");
			throw DataManagerError.otherError;
		}
		
		// Prepare fetch request
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName);
		fetchRequest.predicate = NSPredicate(format: "\(uniqueKeyName) == '\(uniqueProperty.value)'");
		
		do {
			// Fetch items
			let dbObjects = try dbContext.fetch(fetchRequest);
			
			if (dbObjects.count == 0) {
				throw DataManagerError.itemNotExists;
			}
			
			let dbObject = dbObjects.first!;
			
			// Update
			for child in objectMirror.children  {
				if let propKey = child.label {
					var keyPath = propKey;
					
					// Check specialAttributeNames first: used in case some properties were added with unmatched attribute names in the data model
					if let specialAttributeNames = specialAttributeNames {
						keyPath = specialAttributeNames[propKey] ?? propKey;
					}
					
					// Add data to ManagedObject
					dbObject.setValue(child.value, forKeyPath: keyPath);
				}
			}
			
			try dbContext.save();
		}
		catch let error as NSError {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Error while updating data", error, error.userInfo);
			throw DataManagerError.dataSaveError;
		}
	}

	// TODO: 'uniqueKeyName' is not checked against 'specialAttributeNames', assuming it will have the same name as its respective proprty name in the model struct/class.
	func delete(item: T, uniqueKeyName: String) throws {
		let objectMirror = Mirror(reflecting: item);
		
		// Get matching 'uniqueProperty'
		guard let uniqueProperty = objectMirror.children.first(where: { $0.label == uniqueKeyName }) else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Cannot find a matching uniqueProperty.");
			throw DataManagerError.otherError;
		}
		
		// Prepare fetch request
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName);
		fetchRequest.predicate = NSPredicate(format: "\(uniqueKeyName) == '\(uniqueProperty.value)'");
		
		// Delete data
		do {
			// Fetch items
			let dbObjects = try dbContext.fetch(fetchRequest);
			
			if (dbObjects.count == 0) {
				throw DataManagerError.itemNotExists;
			}
			
			// Delete
			dbContext.delete(dbObjects[0]);
			try dbContext.save();
		}
		catch let error as NSError {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Error while deleting data", error, error.userInfo);
			throw DataManagerError.dataSaveError;
		}
	}
	
	/// Fetch data as NSManagedObjects.
	func fetch(sortDescriptors: [NSSortDescriptor]? = nil) throws -> [NSManagedObject] {
		var dbObjects: [NSManagedObject] = [];
		
		// Create a fetch request
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName);
		fetchRequest.sortDescriptors = sortDescriptors;
		
		// Execute the request and fetch data
		do {
			dbObjects = try dbContext.fetch(fetchRequest);
		} catch let error as NSError {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Could not load data", error, error.userInfo);
			throw DataManagerError.dataLoadError;
		}
		
		return dbObjects;
	}
	
	/// Fetch data and map to model.
	func fetchModel(sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T]? {
		var dbObjects: [NSManagedObject] = [];
		
		// Prepare fetch request
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName);
		fetchRequest.sortDescriptors = sortDescriptors;
		
		// Fetch data
		do {
			dbObjects = try dbContext.fetch(fetchRequest);
		} catch let error as NSError {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Could not load data", error, error.userInfo);
			throw DataManagerError.dataLoadError;
		}
		
		// Map data to model
		let mappedModels: [T]? = try? dbObjects.map({ item in
			var mappedModel: T;
			
			do {
				mappedModel = try mapToModel(from: item);
			} catch let error as NSError {
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logTitle, "Could not load data", error, error.userInfo);
				throw DataManagerError.dataLoadError;
			}
			
			return mappedModel;
		})
		
		return mappedModels;
	}

	// MARK: - Private Functions
	// TODO: This method does not work perfectly, so I use non-generic, non-mapped `fetch() -> [NSManagedObject]` method above. Refer to my notes on this in Appled Notes.
	private func mapToModel(from managedObject: NSManagedObject) throws -> T {
		// Set data: Loop though item properties
		let objectMirror = Mirror(reflecting: baseModel!);
		for var child in objectMirror.children  {
			if let propKey = child.label {
				var keyPath = propKey;

				// Check specialAttributeNames first: used in case some properties were added with unmatched attribute names in the data model
				if let specialAttributeNames = specialAttributeNames {
					keyPath = specialAttributeNames[propKey] ?? propKey;
				}

				child.value = managedObject.value(forKey: keyPath);
			}
		}

		return baseModel;
	}
	
}

enum DataManagerError : String, Error {
	case initializationFailure
	case dataSaveError
	case dataLoadError
	case dataDeleteError
	case itemNotExists
	case noItems
	case configError
	case otherError
	
	var message: String {
		return NSLocalizedString(self.rawValue, comment: "");
	}
}
