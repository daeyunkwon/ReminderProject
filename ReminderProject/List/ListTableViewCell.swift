//
//  ListTableViewCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import SnapKit

final class ListTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    weak var delegate: ListTableViewCellDelegate?
    
    var reminder: Reminder? {
        didSet {
            guard let data = reminder else { return }
            titleLabel.text = data.todoTitle
            contentLabel.text = data.todoContent
            deadlineLabel.text = data.deadline
        }
    }
    
    
    //MARK: - UI Components
    
    private lazy var checkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(nil, for: .normal)
        btn.setImage(Constant.SymbolImage.circle, for: .normal)
        btn.tintColor = Constant.Color.darkGary
        btn.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let importanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.blue
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = Constant.Color.gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = Constant.Color.gray
        label.textAlignment = .left
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = Constant.Color.customSkyBlue
        label.textAlignment = .left
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        importanceLabel.text = nil
        titleLabel.text = nil
        contentLabel.text = nil
        deadlineLabel.text = nil
        tagLabel.text = nil
    }
    
    //MARK: - Init
    
    override final func configureLayout() {
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }
        
        contentView.addSubview(importanceLabel)
        importanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton.snp.centerY)
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            importanceLabel.setContentHuggingPriority(.init(999), for: .horizontal)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton.snp.centerY)
            make.leading.equalTo(importanceLabel.snp.trailing).offset(3)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(deadlineLabel)
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentLabel.snp.leading)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(deadlineLabel.snp.trailing).offset(3)
        }
        
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(10)
            make.height.equalTo(0.2)
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
        }
    }
    
    override final func configureUI() {
//        importanceLabel.text = "!!!"
//        titleLabel.text = "키보드 구매"
//        contentLabel.text = "예븐 키캡 알아보기"
//        deadlineLabel.text = "8888.8.88"
        tagLabel.text = "#공부"
    }
    
    //MARK: - Functions
    
    @objc private func checkButtonTapped() {
        delegate?.checkButtonTapped(cell: self)
    }
    
    func updateDisplayCheckButton(isDone: Bool) {
        
        if isDone {
            self.checkButton.setImage(Constant.SymbolImage.checkmarkCircleFill, for: .normal)
        } else {
            self.checkButton.setImage(Constant.SymbolImage.circle, for: .normal)
        }
    }

}
