//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol ShowingLoadingIndicator {
	func setIndicator(asShown: Bool);

	// Shows the spinner
	func showIndicator();
	
	// Hides the spinner
	func hideIndicator();
}

extension ShowingLoadingIndicator {
	func showIndicator() {
		fatalError("Protocol default implementation");
	}

	func hideIndicator() {
		fatalError("Protocol default implementation");
	}
}
