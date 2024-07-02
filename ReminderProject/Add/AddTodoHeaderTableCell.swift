//
//  AddTodoHeaderTableCell.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import SnapKit

final class AddTodoHeaderTableCell: UITableViewHeaderFooterView {
    
    
    //MARK: - Properties
    
    var closureForDateSend: ((String?, String?) -> Void) = { title, content in }
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Constant.Color.tertiaryGray
        return view
    }()
    
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "제목"
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var contentTextField: UITextView = {
        let tf = UITextView()
        tf.delegate = self
        tf.backgroundColor = .clear
        tf.font = .systemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        return tf
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "메모"
        label.textColor = .systemGray2
        return label
    }()
    
    
    //MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(10)
        }
        
        backView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        backView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        backView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(10)
        }
        
        backView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(22)
        }
    }
}

//MARK: - UITextViewDelegate

extension AddTodoHeaderTableCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count != 0 {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddTodoHeaderTableCell: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.closureForDateSend(titleTextField.text, contentTextField.text)
    }
}
