//
//  BaseViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    func setupNavi() { }
    
    func configureLayout() { }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func showAlert(title: String, message: String, cancelTitle: String, buttonTitle: String, buttonStyle: UIAlertAction.Style, buttonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler: buttonAction))
        present(alert, animated: true)
    }
}
