//
//  AddTodoViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit
import PhotosUI

import SnapKit

final class AddTodoViewController: BaseViewController {
    
    //MARK: - Properties
    
    var closureForListVC: (() -> Void) = { }
    
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
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(AddTodoTableCell.self, forCellReuseIdentifier: AddTodoTableCell.identifier)
        tv.register(AddTodoHeaderTableCell.self, forHeaderFooterViewReuseIdentifier: AddTodoHeaderTableCell.identifier)
        return tv
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "새로운 할 일"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
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
            
            let data = Reminder(todoTitle: title, todoContent: self.contentText, deadline: self.deadline, tag: self.tag, priority: self.priority)
            
            if let image = self.image {
                ImageFileManager.shared.saveImageToDocument(image: image, filename: "\(data.id)") { //Document에 이미지 저장
                    data.imageID = "\(data.id)"
                }
            }
            
            do {
                try REALM_DATABASE.write {
                    REALM_DATABASE.add(data)
                    self.closureForListVC()
                    dismiss(animated: true)
                }
            } catch {
                ImageFileManager.shared.removeImageFromDocument(filename: "\(data.id)") //Document에 저장된 이미지 제거
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
