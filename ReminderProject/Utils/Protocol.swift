//
//  Protocol.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import Foundation

protocol ListTableViewCellDelegate: AnyObject {
    func checkButtonTapped(cell: ListTableViewCell)
}
