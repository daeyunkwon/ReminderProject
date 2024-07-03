//
//  AddTodoTableCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import SnapKit

final class AddTodoTableCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    
    
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
        return label
    }()
    
    private let settingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var chevronRightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(nil, for: .normal)
        btn.setImage(Constant.SymbolImage.chevronRight?.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 15), scale: .medium)), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        backView.addSubview(chevronRightButton)
        chevronRightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        backView.addSubview(settingValueLabel)
        settingValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(chevronRightButton.snp.leading).offset(-10)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
    }
    
    //MARK: - Functions
    
    func cellConfig(title: String?, settingValue: String?) {
        self.titleLabel.text = title
        self.settingValueLabel.text = settingValue
    }
}
