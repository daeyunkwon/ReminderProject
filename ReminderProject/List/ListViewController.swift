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
    
    var reminders: [Reminder] = []
    var filterdReminders: [Reminder] = []
    
    var folder: Folder?
    
    let repository = ReminderRepository()
    
    enum ViewType {
        case today
        case scheduled
        case all
        case flag
        case done
        case userFolder(name: String)
        
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
            case .userFolder(let name):
                return name
            }
        }
    }
    var viewType: ViewType = .all
    
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
            filterdReminders = reminders
            self.tableView.reloadData()
        }
        
        let filteredDeadline = UIAction(title: "마감일 순으로 보기") { [weak self] _ in
            guard let self else { return }
            filterdReminders = reminders.filter({ reminder in
                if reminder.deadline != nil {
                    return true
                }
                return false
            }).sorted(by: {
                $0.deadline ?? Date() < $1.deadline ?? Date()
            })
            self.tableView.reloadData()
        }
        
        let filteredTitle = UIAction(title: "제목 순으로 보기") { [weak self] _ in
            guard let self else { return }
            filterdReminders = reminders.sorted(by: {
                $0.todoTitle < $1.todoTitle
            })
            self.tableView.reloadData()
        }
        
        let filteredPriority = UIAction(title: "우선순위 낮음만 보기") { [weak self] _ in
            guard let self else { return }
            filterdReminders = reminders.filter {
                $0.priority == 3 ? true : false
            }
            self.tableView.reloadData()
        }
        
        return [filteredAll, filteredDeadline, filteredTitle, filteredPriority]
    }
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewType.title
        if let folder = self.folder {
            self.reminders = Array(folder.reminderList)
            self.filterdReminders = self.reminders
            self.tableView.reloadData()
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterdReminders = reminders
    }
    
    override final func setupNavi() {
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
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterdReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            print("Failed to dequeue a ListTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.delegate = self
        cell.cellType = .usingListView
        cell.reminder = filterdReminders[indexPath.row]
        if let folderName = filterdReminders[indexPath.row].main.first?.name {
            cell.overViewLabel.text = folderName
        } else {
            cell.overViewLabel.text = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.reminder = self.filterdReminders[indexPath.row]
        vc.closureForDelete = {[weak self] sender in
            guard let self = self else { return }
            for i in 0...reminders.count - 1 {
                if reminders[i].id == sender.id {
                    reminders.remove(at: i)
                    
                    self.filterdReminders = self.reminders
                    
                    self.repository.deleteReminder(reminder: sender) { result in
                        switch result {
                        case .success(_):
                            self.tableView.reloadData()
                            return
                        
                        case .failure(let error):
                            print(error.errorDescription)
                            self.showFailAlert(type: .failedToDelete)
                            return
                        }
                    }
                }
            }
        }
        pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let flag = UIContextualAction(style: .normal, title: "깃발") { (UIContextualAction, UIView, flag: @escaping (Bool) -> Void) in
            
            do {
                try REALM_DATABASE.write {
                    var newValue: Bool
                    if self.filterdReminders[indexPath.row].flag {
                        newValue = false
                    } else {
                        newValue = true
                    }
                    REALM_DATABASE.create(Reminder.self, value: ["id": self.filterdReminders[indexPath.row].id, "flag": newValue], update: .modified)
                }
            } catch {
                print(ReminderRealmError.failedToWrite.errorDescription)
                print(error)
            }
            
            flag(true)
        }
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, delete: @escaping (Bool) -> Void) in
            
            self.showAlert(title: "삭제", message: "삭제하시겠습니까?", cancelTitle: "취소", buttonTitle: "삭제하기", buttonStyle: .destructive) { okAction in
                do {
                    try REALM_DATABASE.write {
                        REALM_DATABASE.delete(self.filterdReminders[indexPath.row])
                        self.filterdReminders.remove(at: indexPath.row)
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
        
        flag.backgroundColor = .systemOrange
        if filterdReminders[indexPath.row].flag {
            flag.image = UIImage(systemName: "flag.fill")
        } else {
            flag.image = UIImage(systemName: "flag")
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete, flag])
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

