//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	/// Get the ViewController hosting this UIView.
	func findViewController() -> UIViewController? {
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		}
		else if let nextResponder = self.next as? UIView {
			return nextResponder.findViewController()
		}
		else {
			return nil
		}
	}
	
	class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
		return parentView.subviews.flatMap { subView -> [T] in
			var result = getAllSubviews(from: subView) as [T]
			if let view = subView as? T { result.append(view) }
			return result
		}
	}

	class func getAllSubviews(from parentView: UIView, types: [UIView.Type]) -> [UIView] {
		return parentView.subviews.flatMap { subView -> [UIView] in
			var result = getAllSubviews(from: subView) as [UIView]
			for type in types {
				if subView.classForCoder == type {
					result.append(subView)
					return result
				}
			}
			return result
		}
	}

	func getAllSubviews<T: UIView>() -> [T] {
		return UIView.getAllSubviews(from: self) as [T]
	}
	
	func get<T: UIView>(all type: T.Type) -> [T] {
		return UIView.getAllSubviews(from: self) as [T]
	}
	
	func get(all type: UIView.Type) -> [UIView] {
		return UIView.getAllSubviews(from: self)
	}
}
