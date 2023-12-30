//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

enum Localizables: String {
	/*** Main */
	case home

	/* Buttons */
	case ok
	case yes
	case no
	case retry

	case add
	case edit
	case delete
	case done
	
	case empty
}

extension Localizables {
	var text: String { rawValue.localized }
}
