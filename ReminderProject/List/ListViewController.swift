//
//  ViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import SnapKit

final class ListViewController: BaseViewController {

    //MARK: - Properties
    
    
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override final func setupNavi() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constant.SymbolImage.plusCircle, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constant.SymbolImage.ellipsisCircle, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
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
        print(#function)
    }
    
    @objc private func rightBarButtonTapped() {
        print(#function)
    }


}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            print("Failed to dequeue a ListTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.delegate = self
        
        return cell
    }
}

//MARK: - ListTableViewCellDelegate

extension ListViewController: ListTableViewCellDelegate {
    
    func checkButtonTapped(cell: ListTableViewCell) {
        print(#function)
    }
}

