//
//  Reuseable.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

protocol Reuseable: AnyObject {
    static var identifier: String { get }
}

extension UIView: Reuseable {
    static var identifier: String {
        return String(describing: self)
    }
}
