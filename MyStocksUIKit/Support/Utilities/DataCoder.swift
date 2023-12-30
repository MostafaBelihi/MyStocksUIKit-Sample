//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PDataCoder {
	func decodeModel<TModel: Decodable>(ofType modelTypp: TModel.Type, from data: Data) -> TModel?;
	func encodeData<TModel: Encodable>(from model: TModel) -> Data?;
	
	func extractJSONData(jsonResource: String) -> Data?;
	func extractJSONData(from url: URL) -> Data?;
	func getData(from string: String) -> Data?;
	func getHTMLAttributedString(from htmlString: String) -> NSAttributedString?;
}

class DataCoder: PDataCoder {
	
	// MARK: - Dependencies
	private var jsonDecoder: JSONDecoder
	private var jsonEncoder: JSONEncoder
	private var logger: Logging

	// MARK: - Init
	init(jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder, logger: Logging) {
		self.jsonDecoder = jsonDecoder;
		self.jsonEncoder = jsonEncoder;
		self.logger = logger;
	}
	
	// MARK: - Functions
	func decodeModel<TModel: Decodable>(ofType modelType: TModel.Type, from data: Data) -> TModel? {
		do {
			let model = try self.jsonDecoder.decode(modelType.self, from: data);
			return model;
		}
		catch let ex {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Exception", ex);
			return nil;
		}
	}
	
	func encodeData<TModel: Encodable>(from model: TModel) -> Data? {
		do {
			let data = try self.jsonEncoder.encode(model);
			return data;
		}
		catch let ex {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Exception", ex);
			return nil;
		}
	}
	
	func extractJSONData(jsonResource: String) -> Data? {
		let url = Bundle.main.url(forResource: jsonResource, withExtension: "json");
		
		if let url = url {
			do {
				let data = try Data(contentsOf: url);
				return data;
			}
			catch let ex {
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Exception", ex);
				return nil;
			}
		}
		else {
			return nil;
		}
	}
	
	func extractJSONData(from url: URL) -> Data? {
		do {
			let data = try Data(contentsOf: url);
			return data;
		}
		catch let ex {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Exception", ex);
			return nil;
		}
	}
	
	func getData(from string: String) -> Data? {
		return string.data(using: .utf8);
	}
	
	func getHTMLAttributedString(from htmlString: String) -> NSAttributedString? {
		guard let data = getData(from: htmlString) else {
			return nil;
		}
		
		return try? NSAttributedString(data: data,
									   options: [.documentType: NSAttributedString.DocumentType.html],
									   documentAttributes: nil);
	}

}
