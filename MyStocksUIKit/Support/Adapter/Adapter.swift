//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PAdapter {
	associatedtype TAdapter: TypeAdapter;
	func convert(from item: TAdapter.TASource) -> TAdapter.TADestination;
	func convert(from items: [TAdapter.TASource]) -> [TAdapter.TADestination];
}

class Adapter<TAdapter: TypeAdapter>: PAdapter {
	// MARK: - Dependencies
	private var typeAdapter: TAdapter;
	
	// MARK: - Init
	init(typeAdapter: TAdapter) {
		self.typeAdapter = typeAdapter;
	}
	
	// MARK: - Functions
	func convert(from item: TAdapter.TASource) -> TAdapter.TADestination {
		return typeAdapter.convert(from: item);
	}

	func convert(from items: [TAdapter.TASource]) -> [TAdapter.TADestination] {
		return items.compactMap({ typeAdapter.convert(from: $0) });
	}
}
