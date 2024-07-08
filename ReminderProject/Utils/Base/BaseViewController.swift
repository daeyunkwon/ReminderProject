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
    
    func showFailAlert(type: ReminderRealmError) {
        var message: String
        
        switch type {
        case .failedToWrite:
            message = "추가가 실패되었습니다. 잠시 후 다시 시도해주세요."
        case .failedToDelete:
            message = "삭제가 실패되었습니다. 잠시 후 다시 시도해주세요."
        case .failedToUpdate:
            message = "수정이 실패되었습니다. 잠시 후 다시 시도해주세요."
        default:
            message = "None"
        }
        
        let alert = UIAlertController(title: "시스템 알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, cancelTitle: String, buttonTitle: String, buttonStyle: UIAlertAction.Style, buttonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler: buttonAction))
        present(alert, animated: true)
    }
    
    func showActionSheetThreeActionType(title: String?, message: String?, cancelTitle: String, firstButtonTitle: String, firstBbuttonStyle: UIAlertAction.Style, firstButtonAction: @escaping (UIAlertAction) -> Void, secondButtonTitle: String, secondButtonStyle: UIAlertAction.Style, secondButtonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: firstBbuttonStyle, handler: firstButtonAction))
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: secondButtonStyle, handler: secondButtonAction))
        present(alert, animated: true)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
