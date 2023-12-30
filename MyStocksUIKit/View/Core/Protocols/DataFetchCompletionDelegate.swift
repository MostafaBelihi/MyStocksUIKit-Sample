//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol DataFetchCompletionDelegate: AnyObject {
	// TODO: Make arguments of these methods more generic, impact all dependenet methods
	func didCompleteFetching(completionReturn: [Int]?);
	func didCompleteSubmitting(completionReturn: [Int]?);
	func didFailDataFetch(reason: String);
	func didFailDataFetch(withType errorType: ErrorType);
	func didFailDataFetch(withType errorType: ErrorType, errorCode: String?);
	func didFailDataFetch(withType errorType: ErrorType, errorCode: String?, errorMessage: String?);
	func resetDataFetchState();
}

extension DataFetchCompletionDelegate {
	func didCompleteFetching(completionReturn: [Int]?) {}
	func didCompleteSubmitting(completionReturn: [Int]?) {}
	func didFailDataFetch(reason: String) {}
	func didFailDataFetch(withType errorType: ErrorType) {}
	func didFailDataFetch(withType errorType: ErrorType, errorCode: String?) {}
	func didFailDataFetch(withType errorType: ErrorType, errorCode: String?, errorMessage: String?) {}
	func resetDataFetchState() {}
}
