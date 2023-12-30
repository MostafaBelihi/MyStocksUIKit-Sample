//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PBasePresenter {
	var isFetching: Bool { get }
	var isSubmitting: Bool { get }
	
	var delegate: DataFetchCompletionDelegate? { get set }

	func startFetching();
	func endFetching();
	func startSubmitting();
	func endSubmitting();
}

class BasePresenter: PBasePresenter {

	weak var delegate: DataFetchCompletionDelegate?;
	
	var isFetching = false;
	var isSubmitting = false;

	var fetchCount: Int = 1;
	var fetchedCount: Int = 0;
	
	var didFinishFetching: Bool {
		return fetchedCount >= fetchCount;
	}

	// MARK: - Init
	init(fetchCount: Int = 1) {
		self.fetchCount = fetchCount;
	}

	// MARK: - Functions
	func startFetching() {
		isFetching = true;
	}

	func endFetching() {
		isFetching = false;
	}
	
	func startSubmitting() {
		isSubmitting = true;
	}
	
	func endSubmitting() {
		isSubmitting = false;
	}
	
	// MARK: - Network Callbacks
	func succeedFetching(newIndexes: [Int]? = nil, alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		succeedNetworkCall(newIndexes: newIndexes, alwaysCallback: alwaysCallback) {
			completionCallback();
			delegate?.didCompleteFetching(completionReturn: newIndexes);
		}
	}
	
	func succeedSubmitting(alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		succeedNetworkCall(alwaysCallback: alwaysCallback) {
			completionCallback();
			delegate?.didCompleteSubmitting(completionReturn: .none);
		}
	}
	
	private func succeedNetworkCall(newIndexes: [Int]? = nil, alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		guard fetchedCount >= 0 else {
			return;
		}
		
		fetchedCount += 1;
		
		alwaysCallback();
		
		if (fetchedCount >= fetchCount) {
			endFetching();
			completionCallback();
		}
	}

	func failNetworkCall(error: AppError, callback: VoidClosure = {}) {
		fetchedCount = 0;
		endFetching();
		callback();
		delegate?.didFailDataFetch(reason: error.message ?? error.type.localizedMessage);
		delegate?.didFailDataFetch(withType: error.type);
	}

}
