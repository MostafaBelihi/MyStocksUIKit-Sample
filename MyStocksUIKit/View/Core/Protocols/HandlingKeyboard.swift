//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

protocol HandlingKeyboard {
	/// Setup keyboatd positioning over scoll view.
	func setupKeyboardPositioning();

	/// Setup keyboard dismissal gesture.
	func setupTapGesture();

	/// Handle global tap gesture.
	func viewTapHandler(recognizer: UISwipeGestureRecognizer);

	/// Dismiss keyboard.
	func dismissKeyboard();

	/// Handle keyboard when shown.
	func keyboardWillShow(notification: NSNotification);

	/// Handle keyboard when hidden.
	func keyboardWillHide(notification: Notification);
}
