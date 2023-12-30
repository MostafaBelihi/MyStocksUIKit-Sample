//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	// MARK: - Shadows
	func setupShadows(color: CGColor) {
		layer.shadowColor = color;
		layer.shadowOffset = CGSize.zero;
		layer.shadowOpacity = 1;
		layer.shadowRadius = 1;
		layer.shouldRasterize = true;
		layer.rasterizationScale = UIScreen.main.scale;
	}
	
	// MARK: - Rounded corners
	// layerMaxXMaxYCorner – lower right corner
	// layerMaxXMinYCorner – top right corner
	// layerMinXMaxYCorner – lower left corner
	// layerMinXMinYCorner – top left corner
	
	func roundedAll(radius: CGFloat) {
		layer.cornerRadius = radius;
	}
	
	func roundedTop(radius: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
		self.layer.maskedCorners =  [.layerMaxXMinYCorner, .layerMinXMinYCorner];
	}
	
	func roundedBottom(radius: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
		self.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMinXMaxYCorner];
	}
	
	func roundedLeft(radius: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
		self.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMinXMaxYCorner];
	}
	
	func roundedRight(radius: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
		self.layer.maskedCorners =  [.layerMaxXMinYCorner, .layerMaxXMaxYCorner];
	}
	
	// MARK: - Custom Borders
	func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
		func createBorder() -> UIView {
			let borderView = UIView(frame: CGRect.zero)
			borderView.translatesAutoresizingMaskIntoConstraints = false
			borderView.backgroundColor = color
			return borderView
		}
		
		if (edges.contains(.all) || edges.contains(.top)) {
			let topBorder = createBorder()
			self.addSubview(topBorder)
			NSLayoutConstraint.activate([
				topBorder.topAnchor.constraint(equalTo: self.topAnchor),
				topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
				topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
				topBorder.heightAnchor.constraint(equalToConstant: width)
			])
		}
		
		if (edges.contains(.all) || edges.contains(.left)) {
			let leftBorder = createBorder()
			self.addSubview(leftBorder)
			NSLayoutConstraint.activate([
				leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
				leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
				leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
				leftBorder.widthAnchor.constraint(equalToConstant: width)
			])
		}
		
		if (edges.contains(.all) || edges.contains(.right)) {
			let rightBorder = createBorder()
			self.addSubview(rightBorder)
			NSLayoutConstraint.activate([
				rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
				rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
				rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
				rightBorder.widthAnchor.constraint(equalToConstant: width)
			])
		}
		
		if (edges.contains(.all) || edges.contains(.bottom)) {
			let bottomBorder = createBorder()
			self.addSubview(bottomBorder)
			NSLayoutConstraint.activate([
				bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
				bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
				bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
				bottomBorder.heightAnchor.constraint(equalToConstant: width)
			])
		}
	}
	
	func addBordersWithMargin(edges: UIRectEdge = .all, color: UIColor = .black, thickness: CGFloat = 1.0, margin: CGFloat = 0.0) {
		func createBorder() -> UIView {
			let borderView = UIView(frame: CGRect.zero)
			borderView.translatesAutoresizingMaskIntoConstraints = false
			borderView.backgroundColor = color
			return borderView
		}
		
		// Top border
		if (edges.contains(.all) || edges.contains(.top)) {
			// Create and constrain the border
			let border = createBorder()
			self.addSubview(border)
			
			NSLayoutConstraint.activate([
				border.topAnchor.constraint(equalTo: self.topAnchor),
				border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
				border.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margin * -1),
				border.heightAnchor.constraint(equalToConstant: thickness)
			])
		}
		
		// Left border
		if (edges.contains(.all) || edges.contains(.left)) {
			// Create and constrain the border
			let border = createBorder()
			self.addSubview(border)

			NSLayoutConstraint.activate([
				border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
				border.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
				border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: margin * -1),
				border.widthAnchor.constraint(equalToConstant: thickness)
			])
		}
		
		// Right border
		if (edges.contains(.all) || edges.contains(.right)) {
			// Create and constrain the border
			let border = createBorder()
			self.addSubview(border)

			NSLayoutConstraint.activate([
				border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
				border.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
				border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: margin * -1),
				border.widthAnchor.constraint(equalToConstant: thickness)
			])
		}
		
		// Bottom border
		if (edges.contains(.all) || edges.contains(.bottom)) {
			// Create and constrain the border
			let border = createBorder()
			self.addSubview(border)

			NSLayoutConstraint.activate([
				border.bottomAnchor.constraint(equalTo: self.bottomAnchor),
				border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
				border.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margin * -1),
				border.heightAnchor.constraint(equalToConstant: thickness)
			])
		}
	}
	
}

// MARK: - Positioning
extension UIView
{
	func fixInView(_ container: UIView!) -> Void{
		self.translatesAutoresizingMaskIntoConstraints = false;
		self.frame = container.frame;
		container.addSubview(self);
		NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
		NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
		NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
		NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
	}
}
