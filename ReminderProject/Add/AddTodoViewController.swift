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
    
    private var titleText: String? {
        didSet {
            if let titleText = titleText {
                if !(titleText.trimmingCharacters(in: .whitespaces).isEmpty) {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    private var deadline: String?
    private var contentText: String?
    
    private enum CellType: Int, CaseIterable {
        case deadline
        case tag
        case priority
        case addImage
        
        var titleText: String {
            switch self {
            case .deadline:
                return "마감일"
            case .tag:
                return "태그"
            case .priority:
                return "우선 순위"
            case .addImage:
                return "이미지 추가"
            }
        }
    }
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(AddTodoTableCell.self, forCellReuseIdentifier: AddTodoTableCell.identifier)
        tv.register(AddTodoHeaderTableCell.self, forHeaderFooterViewReuseIdentifier: AddTodoHeaderTableCell.identifier)
        return tv
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
        navigationItem.title = "새로운 할 일"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override final func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override final func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Functions
    
    @objc private func leftBarButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func rightBarButtonTapped() {
        
        if let title = self.titleText {
            let data = Reminder(todoTitle: title, todoContent: self.contentText, deadline: deadline)
            
            do {
                try REALM_DATABASE.write {
                    REALM_DATABASE.add(data)
                    dismiss(animated: true)
                }
            } catch {
                print(ReminderRealmError.failedToAdd.errorDescription)
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension AddTodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddTodoHeaderTableCell.identifier) as? AddTodoHeaderTableCell else {
            print("Failed to dequeue a AddTodoHeaderTableCell. Using default UIView.")
            return UIView()
        }
        
        header.closureForDateSend = {[weak self] titleText, contentText in
            guard let self = self else { return }
            
            self.titleText = titleText
            self.contentText = contentText
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTodoTableCell.identifier, for: indexPath) as? AddTodoTableCell else {
            print("Failed to dequeue a AddTodoTableCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        
        cell.cellConfig(text: CellType.allCases[indexPath.row].titleText)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case CellType.deadline.rawValue:
            let vc = DateViewController()
            vc.closureForDateSend = {[weak self] sender in
                self?.deadline = sender
            }
            pushViewController(vc)
        default:
            break
        }
    }
}
