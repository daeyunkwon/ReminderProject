//
//  MainTableCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import SnapKit

final class MainCollectionCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    enum CellType: Int, CaseIterable {
        case today
        case scheduled
        case all
        case flag
        case done
        
        var title: String {
            switch self {
            case .today:
                return "오늘"
            case .scheduled:
                return "예정"
            case .all:
                return "전체"
            case .flag:
                return "깃발 표시"
            case .done:
                return "완료됨"
            }
        }
    }
    
    //MARK: - UI Components
    
     let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.grayForBackView
        view.layer.cornerRadius = 10
        return view
    }()
    
     let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Constant.SymbolImage.leafCircleFill
        iv.layer.cornerRadius = 20
        return iv
    }()
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constant.Color.gray
        label.text = "\(0)"
        return label
    }()
    
     let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        return label
    }()
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(10)
            make.leading.equalTo(backView.snp.leading).offset(10)
            make.size.equalTo(40)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.leading).offset(5)
            make.bottom.equalTo(backView.snp.bottom).offset(-10)
        }
        
        backView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.trailing.equalTo(backView.snp.trailing).inset(20)
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
    }
    
    //MARK: - Functions
    
    func cellConfig(cellType: CellType, count: Int) {
        switch cellType {
        case .today:
            iconImageView.image = Constant.SymbolImage.leafCircleFill
            titleLabel.text = cellType.title
            countLabel.text = "\(count)"
        case .scheduled:
            iconImageView.image = Constant.SymbolImage.calendarCircleFill
            titleLabel.text = cellType.title
            countLabel.text = "\(count)"
        case .all:
            iconImageView.image = Constant.SymbolImage.trayCircleFill
            titleLabel.text = cellType.title
            countLabel.text = "\(count)"
        case .flag:
            iconImageView.image = Constant.SymbolImage.flagCircleFill
            titleLabel.text = cellType.title
            countLabel.text = "\(count)"
        case .done:
            iconImageView.image = Constant.SymbolImage.checkmarkCircleFill
            titleLabel.text = cellType.title
            countLabel.text = "\(count)"
        }
    }

    
}
