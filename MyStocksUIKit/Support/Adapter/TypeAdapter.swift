//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

// Workaround to inject protocols with associatedtype: https://github.com/Swinject/Swinject/issues/223#issuecomment-399476115

import Foundation

protocol TypeAdapter {
	associatedtype TSource;
	associatedtype TDestination;
	
	typealias TASource = TSource;
	typealias TADestination = TDestination;

	func convert(from model: TSource) -> TDestination;
}
