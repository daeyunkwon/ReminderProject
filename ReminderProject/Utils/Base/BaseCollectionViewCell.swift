//
//  BaseCollectionViewCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() { }
    
    func configureUI() { }
}
