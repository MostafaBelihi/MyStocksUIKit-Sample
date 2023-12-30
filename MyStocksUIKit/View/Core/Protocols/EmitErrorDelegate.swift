//
//  EmitErrorDelegate.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 27/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol EmitErrorDelegate: AnyObject {
	var didShowErrors: Bool { get set };
	func emitError(message: String);
	func emitDisconnectedError();
	func resetErrors();
}

extension EmitErrorDelegate {
	func emitError(message: String) { return }
	func emitDisconnectedError() { return }
}
