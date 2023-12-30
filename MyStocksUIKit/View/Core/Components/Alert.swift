//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

protocol PAlert {
	typealias AlertHandlerClosure = (UIAlertAction)->();
	
	func setParentView(as parentView: UIViewController);
	
	func info(message: String);
	func info(title: String, message: String);
	func info(message: String, handler: @escaping AlertHandlerClosure);
	func info(title: String, message: String, handler: @escaping AlertHandlerClosure);
	func info(title: String?, message: String, handler: AlertHandlerClosure?);

	func confirm(message: String, handler: @escaping AlertHandlerClosure);
	func confirm(title: String, message: String, handler: @escaping AlertHandlerClosure);
	func confirm(title: String?, message: String, handler: AlertHandlerClosure?);

	func error(message: String, actionButtonText: String, handler: @escaping AlertHandlerClosure);
	func error(title: String, message: String, actionButtonText: String, handler: @escaping AlertHandlerClosure);
	func error(title: String?, message: String, actionButtonText: String?, handler: AlertHandlerClosure?);
}

class Alert: PAlert {

	// MARK: - Dependencies
	private var parentView: UIViewController?
	private var logger: Logging
	
	// MARK: - More Variables
	private let logTitle = "Alert";
	
	// MARK: - Init
	init (parentView: UIViewController? = nil, logger: Logging) {
		self.parentView = parentView;
		self.logger = logger;
	}
	
	func setParentView(as parentView: UIViewController) {
		self.parentView = parentView;
	}
	
	// MARK: - Info
	func info(message: String) {
		showInfo(message: message);
	}

	func info(title: String, message: String) {
		showInfo(title: title, message: message);
	}

	func info(message: String, handler: @escaping AlertHandlerClosure) {
		showInfo(message: message, handler: handler);
	}
	
	func info(title: String, message: String, handler: @escaping AlertHandlerClosure) {
		showInfo(title: title, message: message, handler: handler);
	}

	func info(title: String?, message: String, handler: AlertHandlerClosure?) {
		showInfo(title: title, message: message, handler: handler);
	}
	
	// MARK: - Confirm
	func confirm(message: String, handler: @escaping AlertHandlerClosure) {
		showConfirm(message: message, handler: handler);
	}
	
	func confirm(title: String, message: String, handler: @escaping AlertHandlerClosure) {
		showConfirm(title: title, message: message, handler: handler);
	}
	
	func confirm(title: String?, message: String, handler: AlertHandlerClosure?) {
		showConfirm(title: title, message: message, handler: handler);
	}
	
	// MARK: - Error
	func error(message: String, actionButtonText: String, handler: @escaping AlertHandlerClosure) {
		showError(message: message, actionButtonText: actionButtonText, handler: handler);
	}
	
	func error(title: String, message: String, actionButtonText: String, handler: @escaping AlertHandlerClosure) {
		showError(title: title, message: message, actionButtonText: actionButtonText, handler: handler);
	}
	
	func error(title: String?, message: String, actionButtonText: String?, handler: AlertHandlerClosure?) {
		showError(title: title, message: message, actionButtonText: actionButtonText, handler: handler);
	}
	
	// MARK: - Privates
	private func showInfo(title: String? = nil, message: String, handler: AlertHandlerClosure? = nil) {
		guard let parentView = self.parentView else {
			logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: logTitle, "Parent view not set!");
			return;
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: handler));
		parentView.present(alert, animated: true);
	}

	private func showConfirm(title: String? = nil, message: String, handler: AlertHandlerClosure? = nil) {
		guard let parentView = self.parentView else {
			logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: logTitle, "Parent view not set!");
			return;
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
		
		alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: handler));
		alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil));
		
		parentView.present(alert, animated: true);
	}
	
	private func showError(title: String? = nil, message: String, actionButtonText: String? = nil, handler: AlertHandlerClosure? = nil) {
		guard let parentView = self.parentView else {
			logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: logTitle, "Parent view not set!");
			return;
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
		
		alert.addAction(UIAlertAction(title: actionButtonText, style: .default, handler: handler));
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil));
		
		parentView.present(alert, animated: true);
	}
	
}
