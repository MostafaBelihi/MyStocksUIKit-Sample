//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PError: Error {
	var type: ErrorType { get set }
}

struct DataError<TError> : PError {
	init(ofType type: ErrorType, error: TError? = nil) {
		self.type = type;
		
		if let error = error {
			self.error = error;
		}
	}
	
	var type: ErrorType;
	var error: TError?;
}

enum ErrorType : String {
	case unknownError
	case serviceError
	case unauthorizedUser
	case unauthorizedApp
	case decodingError
	case invalidEndpoint
	case invalidResponse
	case noData
	case dataError
	case apiLimitReached
	case noConnection
	case internalError
	case moyaFailure
	
	var localizedMessage: String {
		return self.rawValue.localized;
	}
	
	func getLocalizedMessage(withKeySuffix suffix: String) -> String {
		return "\(self.rawValue)\(suffix)".localized;
	}
}
