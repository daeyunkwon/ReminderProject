//
//  AddTodoViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit
import PhotosUI

import RealmSwift
import SnapKit


final class AddTodoViewController: BaseViewController {
    
    //MARK: - Properties
    
    enum ViewType {
        case new
        case edit
    }
    var viewType: ViewType = .new
    
    var reminder: Reminder?
    
    var closureForListVC: (() -> Void) = { }
    var closureForDetailVC: ((Reminder) -> Void) = { sender in }
    
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
    private var contentText: String?
    private var deadline: Date?
    private var tag: String?
    private var priority: Int = 3
    private var image: UIImage?
    
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
    
    var contentTextView: UITextView?
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(AddTodoTableCell.self, forCellReuseIdentifier: AddTodoTableCell.identifier)
        tv.register(AddTodoHeaderTableCell.self, forHeaderFooterViewReuseIdentifier: AddTodoHeaderTableCell.identifier)
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch viewType {
        case .new:
            navigationItem.title = "새로운 할 일"
        case .edit:
            navigationItem.title = "수정"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        
        var rightTitle: String
        switch viewType {
        case .new:
            rightTitle = "추가"
        case .edit:
            rightTitle = "완료"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: #selector(rightBarButtonTapped))
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
        
        if viewType == .edit {
            guard let data = self.reminder else { return }
            titleText = data.todoTitle
            contentText = data.todoContent
            deadline = data.deadline
            tag = data.tag
            priority = data.priority
            image = ImageFileManager.shared.loadImageToDocument(filename: data.imageID ?? "")
        }
    }
    
    //MARK: - Functions
    
    @objc private func leftBarButtonTapped() {
        switch viewType {
        case .new:
            self.dismiss(animated: true)
        case .edit:
            popViewController()
        }
    }
    
    @objc private func rightBarButtonTapped() {
        guard let title = self.titleText else { return }
        
        switch viewType {
        case .new:
            let data = Reminder(todoTitle: title, todoContent: self.contentText, deadline: self.deadline, tag: self.tag, priority: self.priority)
            
            if let image = self.image {
                ImageFileManager.shared.saveImageToDocument(image: image, filename: "\(data.id)") { //Document에 이미지 저장
                    data.imageID = "\(data.id)"
                }
            }
            
            do {
                try REALM_DATABASE.write {
                    REALM_DATABASE.add(data)
                }
                self.closureForListVC()
                dismiss(animated: true)
            } catch {
                ImageFileManager.shared.removeImageFromDocument(filename: "\(data.id)") //Document에 저장된 이미지 제거
                print(ReminderRealmError.failedToWrite.errorDescription)
                print(error)
            }
            
        case .edit:
            guard let reminder = self.reminder else { return }
            
            do {
                try REALM_DATABASE.write {
                    reminder.todoTitle = title
                    reminder.todoContent = self.contentText
                    reminder.deadline = self.deadline
                    reminder.tag = self.tag
                    reminder.priority = self.priority
                    
                    if let image = self.image {
                        ImageFileManager.shared.saveImageToDocument(image: image, filename: "\(reminder.id)") {
                            reminder.imageID = "\(reminder.id)"
                        }
                    } else {
                        ImageFileManager.shared.removeImageFromDocument(filename: "\(reminder.id)")
                    }
                }
                self.closureForDetailVC(reminder)
                popViewController()
            } catch {
                ImageFileManager.shared.removeImageFromDocument(filename: "\(reminder.id)") //Document에 저장된 이미지 제거
                print(ReminderRealmError.failedToWrite.errorDescription)
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
        
        if viewType == .edit {
            header.cellConfig(data: self.reminder)
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
        
        switch indexPath.row {
        case CellType.deadline.rawValue:
            if self.deadline != nil {
                let deadlineString = Date.makeDateString(date: self.deadline ?? Date())
                cell.cellConfig(cellType: .notImage, title: CellType.allCases[indexPath.row].titleText, settingValue: deadlineString, image: nil)
            } else {
                cell.cellConfig(cellType: .notImage, title: CellType.allCases[indexPath.row].titleText, settingValue: nil, image: nil)
            }
            
        case CellType.tag.rawValue:
            cell.cellConfig(cellType: .notImage, title: CellType.allCases[indexPath.row].titleText, settingValue: self.tag, image: nil)
        
        case CellType.priority.rawValue:
            cell.cellConfig(cellType: .notImage, title: CellType.allCases[indexPath.row].titleText, settingValue: self.priority == 1 ? "높음" : priority == 2 ? "보통" : priority == 3 ? "낮음" : nil, image: nil)
        
        case CellType.addImage.rawValue:
            cell.cellConfig(cellType: .Image, title: CellType.allCases[indexPath.row].titleText, settingValue: nil, image: self.image)
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //마감일
        case CellType.deadline.rawValue:
            let vc = DateViewController()
            
            if let safeDeadline = self.deadline {
                vc.selectedDate = safeDeadline
            }
            
            vc.closureForDateSend = {[weak self] sender in
                self?.deadline = sender
                self?.tableView.reloadData()
            }
            pushViewController(vc)
        
        //태그
        case CellType.tag.rawValue:
            let vc = TagViewController()
            vc.settingTag = self.tag
            
            vc.closureForDataSend = {[weak self] sender in
                if let tagString = sender {
                    if !tagString.trimmingCharacters(in: .whitespaces).isEmpty {
                        self?.tag = tagString.trimmingCharacters(in: .punctuationCharacters)
                    } else {
                        self?.tag = nil
                    }
                }
                self?.tableView.reloadData()
            }
            pushViewController(vc)
        
        //우선 순위
        case CellType.priority.rawValue:
            let vc = PriorityViewController()
            
            vc.settingPriority = self.priority
            
            vc.closureForDataSend = {[weak self] sender in
                self?.priority = sender
                self?.tableView.reloadData()
            }
            
            pushViewController(vc)
        
        //이미지 추가
        case CellType.addImage.rawValue:
            
            showActionSheetThreeActionType(title: "이미지 추가하기", message: nil, cancelTitle: "취소", firstButtonTitle: "이미지 사용안함", firstBbuttonStyle: .default, firstButtonAction: { action in
                self.image = nil
                self.tableView.reloadRows(at: [IndexPath(row: CellType.addImage.rawValue, section: 0)], with: .automatic)
                
            }, secondButtonTitle: "앨범에서 이미지 선택하기", secondButtonStyle: .default) { action in
                var config = PHPickerConfiguration()
                config.selectionLimit = 1
                config.filter = .any(of: [.images, .livePhotos, .screenshots])
                
                let phpicker = PHPickerViewController(configuration: config)
                phpicker.delegate = self
                self.present(phpicker, animated: true)
            }
        default:
            break
        }
    }
}

//MARK: - PHPickerViewControllerDelegate

extension AddTodoViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if error != nil {
                    print(error ?? "")
                    return
                }
                DispatchQueue.main.async {
                    self.image = image as? UIImage
                    self.dismiss(animated: true)
                    self.tableView.reloadRows(at: [IndexPath(row: CellType.addImage.rawValue, section: 0)], with: .automatic)
                }
            }
        } else { //취소 버튼 선택한 경우
            self.dismiss(animated: true)
        }
    }
}
