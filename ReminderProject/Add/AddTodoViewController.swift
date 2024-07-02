//
//  AddTodoViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import SnapKit

final class AddTodoViewController: BaseViewController {
    
    //MARK: - Properties
    
    
    
    //MARK: - UI Components
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
        navigationItem.title = "새로운 할 일"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    override final func configureLayout() {
        
    }
    
    override final func configureUI() {
        super.configureUI()
    }
    
    
    //MARK: - Functions
    
    @objc private func leftBarButtonTapped() {
        
    }
    
    @objc private func rightBarButtonTapped() {
        
    }

    
    
}
