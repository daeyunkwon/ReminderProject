//
//  FolderListViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/8/24.
//

import UIKit

import SnapKit

final class FolderListViewController: BaseViewController {
    
    //MARK: - Properties
    
    var folders: [Folder] = []
    
    let repository = ReminderRepository()
    
    var closureForDataSend: (Folder) -> Void = { sender in }
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FolderListTableViewCell.self, forCellReuseIdentifier: FolderListTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.folders = repository.fetchAllFolder()
    }
    
    override func setupNavi() {
        navigationItem.title = "선택 가능한 폴더 목록"
    }
    
    override func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension FolderListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return max(UITableView.automaticDimension, 80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderListTableViewCell.identifier, for: indexPath) as? FolderListTableViewCell else {
            print("Failed to dequeue a FolderListTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.cellConfig(title: self.folders[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.closureForDataSend(self.folders[indexPath.row])
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        popViewController()
    }
}
