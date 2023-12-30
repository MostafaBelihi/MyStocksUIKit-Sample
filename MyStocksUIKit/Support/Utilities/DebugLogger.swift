//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

protocol Logging {
	func log(ofType type: LogType, _ items: Any...);
	func log(ofType type: LogType, title: String, _ items: Any...);
	func log(ofType type: LogType, file: String, function: String, line: String, title: String, _ items: Any...);
}

enum LogType: String {
	case info = "Info"
	case error = "Error"
	case debug = "Debug"
}

class DebugLogger: Logging {
	
	private let globalTitlePrefix = "App Log";
	private var dateFormat = "yyyy-MM-dd HH:mm:ss";
	
	init(dateFormat: String? = nil) {
		if let dateFormat = dateFormat {
			self.dateFormat = dateFormat;
		}
	}
	
	func log(ofType type: LogType, _ items: Any...) {
		writeLog(title: type.rawValue, items);
	}
	
	func log(ofType type: LogType, title: String, _ items: Any...) {
		writeLog(title: title, items);
	}
	
	func log(ofType type: LogType, file: String, function: String, line: String, title: String, _ items: Any...) {
		writeLog(file: file, function: function, line: line, title: title, items);
	}

	private func writeLog(file: String? = nil, function: String? = nil, line: String? = nil, title: String, _ items: Any...) {
		let separator1 = "========================================================================================";
		let separator2 = "----------------------------------------------------------------------------------------";
		let separator3 = "........................................................................................";

		var fileInfo: String?;
		if let file = file, let function = function, let line = line {
			fileInfo = "\(file): \(line)\n\(function)";
		}

		let date = Date().toString(format: dateFormat);
		var logTitle = "\(globalTitlePrefix) - \(date)";
		let log = "\(title):: \(items)";
		
		if let fileInfo = fileInfo {
			logTitle = "\(logTitle)\n\(fileInfo)";
		}

		print(separator1);
		print("\(logTitle)");
		print(separator3);
		print("\(log)");
		print(separator2);
	}
}
