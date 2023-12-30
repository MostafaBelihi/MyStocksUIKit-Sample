//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

protocol Scrollable {
	// The ScrollView
	var scrollView: UIScrollView? { get set }
	
	// The view that will be between the ScrollView and the content view
	var viewScrolledContent: UIView? { get set }
	
	// Configures and adds views to the view controller to be scrollable
	func setupScrollView(contentView: UIView);
}
