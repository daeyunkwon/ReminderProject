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
    
    enum CellType {
        case notImage
        case Image
    }
    
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
    
    private let settingValueImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.tintColor = .lightGray
        return iv
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
        
        backView.addSubview(settingValueImage)
        settingValueImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(chevronRightButton.snp.leading).offset(-10)
            make.size.equalTo(60)
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
    
    func cellConfig(cellType: CellType, title: String?, settingValue: String?, image: UIImage?) {
        self.titleLabel.text = title
        
        switch cellType {
        case .notImage:
            self.settingValueLabel.text = settingValue
            self.settingValueLabel.isHidden = false
            self.settingValueImage.isHidden = true
            
        case .Image:
            self.settingValueImage.image = image != nil ? image : UIImage(systemName: "photo")
            self.settingValueImage.isHidden = false
            self.settingValueLabel.isHidden = true
        }
    }
}
