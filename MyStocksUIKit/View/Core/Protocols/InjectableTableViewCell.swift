//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

protocol InjectableTableViewCell {
	static var cellId: String { get }
	static var bundle: Bundle { get }
	static var nib: UINib { get }
	
	static func register(with tableView: UITableView);
	static func loadFromNib(owner: Any?) -> Self;
	static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self;
}
