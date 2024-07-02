//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import SnapKit

final class DateViewController: BaseViewController {
    
    //MARK: - Properties
    
    var closureForDateSend: ((String?) -> Void) = { sender in }
    
    //MARK: - UI Components
    
    private lazy var deadlineInputTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = Constant.Color.tertiaryGray
        tf.placeholder = "2024.07.03"
        tf.delegate = self
        return tf
    }()
    
    
    //MARK: - Life Cycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.deadlineInputTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavi() {
        navigationItem.title = "마감일"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    override func configureLayout() {
        view.addSubview(deadlineInputTextField)
        deadlineInputTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(100)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    
    //MARK: - Functions
    
    @objc private func rightBarButtonTapped() {
        self.closureForDateSend(self.deadlineInputTextField.text)
        self.popViewController()
    }

}

extension DateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.deadlineInputTextField.resignFirstResponder()
        return true
    }
}
