//
//  ViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import RealmSwift
import SnapKit
import Toast

final class ListViewController: BaseViewController {

    //MARK: - Properties
    
    var list: Results<Reminder>!
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tv
    }()
    
    private var itemsForMenu: [UIAction] {
        let filteredAll = UIAction(title: "전체 보기") { [weak self] _ in
            guard let self else { return }
            list = REALM_DATABASE.objects(Reminder.self)
            self.tableView.reloadData()
        }
        
        let filteredDeadline = UIAction(title: "마감일 순으로 보기") { [weak self] _ in
            guard let self else { return }
            list = REALM_DATABASE.objects(Reminder.self).sorted(byKeyPath: Reminder.Key.deadline.rawValue, ascending: true)
            self.tableView.reloadData()
        }
        
        let filteredTitle = UIAction(title: "제목 순으로 보기") { [weak self] _ in
            guard let self else { return }
            list = REALM_DATABASE.objects(Reminder.self).sorted(byKeyPath: Reminder.Key.todoTitle.rawValue, ascending: true)
            self.tableView.reloadData()
        }
        
        let filteredPriority = UIAction(title: "우선순위 낮음만 보기") { [weak self] _ in
            guard let self else { return }
            list = REALM_DATABASE.objects(Reminder.self).where {
                $0.priority == 3
            }.sorted(byKeyPath: Reminder.Key.deadline.rawValue, ascending: true)
            self.tableView.reloadData()
        }
        
        return [filteredAll, filteredDeadline, filteredTitle, filteredPriority]
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let menu = UIMenu(title: "정렬", children: self.itemsForMenu)
        let rightBarButton = UIBarButtonItem(title: nil, image: Constant.SymbolImage.ellipsisCircle, primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = rightBarButton
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
        let vc = AddTodoViewController()
        vc.closureForListVC = {[weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            print("Failed to dequeue a ListTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.delegate = self
        cell.reminder = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, delete: @escaping (Bool) -> Void) in
            
            self.showAlert(title: "삭제", message: "삭제하시겠습니까?", cancelTitle: "취소", buttonTitle: "삭제하기", buttonStyle: .destructive) { okAction in
                do {
                    try REALM_DATABASE.write {
                        REALM_DATABASE.delete(self.list[indexPath.row])
                        self.tableView.deleteRows(at: [indexPath], with: .right)
                    }
                } catch {
                    print(ReminderRealmError.failedToDelete.errorDescription)
                    print(error)
                }
            }
            
            delete(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

//MARK: - ListTableViewCellDelegate

extension ListViewController: ListTableViewCellDelegate {
    
    func checkButtonTapped(cell: ListTableViewCell) {
        do {
            try REALM_DATABASE.write {
                if let id = cell.reminder?.id {
                    if let data = REALM_DATABASE.object(ofType: Reminder.self, forPrimaryKey: id) {
                        var newValue = cell.reminder?.isDone ?? false
                        newValue.toggle()
                        
                        data.isDone = newValue
                        cell.updateDisplayCheckButton(isDone: data.isDone)
                    }
                }
            }
        } catch {
            print(ReminderRealmError.failedToWrite.errorDescription)
            print(error)
            view.makeToast("할 일 상태 변경에 대한 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
        }
    }
}

