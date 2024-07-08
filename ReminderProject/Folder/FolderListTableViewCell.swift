//
//  FolderListTableViewCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/8/24.
//

import UIKit

final class FolderListTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Constant.Color.grayForBackView
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Functions
    
    func cellConfig(title: String) {
        self.titleLabel.text = title
    }
}
