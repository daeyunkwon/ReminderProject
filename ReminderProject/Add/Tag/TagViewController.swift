//
//  TagViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import SnapKit

final class TagViewController: BaseViewController {
    
    //MARK: - Properties
    
    var closureForDataSend: ((String?) -> Void) = { sender in }
    var settingTag: String?
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Constant.Color.grayForBackView
        return view
    }()
    
    private lazy var tagTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.placeholder = "태그 입력하기"
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(tagTextFieldReturnKeyTapped), for: .primaryActionTriggered)
        return tf
    }()
    
    //MARK: - Life Cycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tagTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tagTextField.resignFirstResponder()
        self.closureForDataSend(tagTextField.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavi() {
        navigationItem.title = "태그"
    }
    
    override func configureLayout() {
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        
        backView.addSubview(tagTextField)
        tagTextField.snp.makeConstraints { make in
            make.centerY.equalTo(backView.snp.centerY)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(10)
            make.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        self.tagTextField.text = settingTag
    }
    
    //MARK: - Functions
    
    @objc func tagTextFieldReturnKeyTapped() {
        tagTextField.resignFirstResponder()
    }
}
