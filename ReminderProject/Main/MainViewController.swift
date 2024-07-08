//
//  MainViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import RealmSwift
import SnapKit

final class MainViewController: BaseViewController {
    
    //MARK: - Properties
    
    let repository = ReminderRepository()
    var folders: [Folder] = []
    
    private enum CellType: Int, CaseIterable {
        case today
        case scheduled
        case all
        case flag
        case done
    }
    private var list: Results<Reminder>!
    private var todayList: [Reminder] = []
    private var scheduledList: [Reminder] = []
    private var allList: [Reminder] = []
    private var flagList: [Reminder] = []
    private var doneList: [Reminder] = []
    
    //MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: MainCollectionCell.identifier)
        
        return collectionView
    }()
    
    private lazy var newAddButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("   새로운 할 일", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setImage(Constant.SymbolImage.plusCircleFill?.applyingSymbolConfiguration(.init(font: UIFont.systemFont(ofSize: 20), scale: .large)), for: .normal)
        btn.addTarget(self, action: #selector(newAddButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var listAddButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("목록 추가", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(listAddButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "전체"
        setupData()
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    private func setupData() {
        self.list = REALM_DATABASE.objects(Reminder.self)
        let list = Array(self.list)
        
        //전체
        self.allList = list
        
        //오늘
        self.todayList = list.filter({ reminder in
            if reminder.deadline != nil {
                let calendar = Calendar.current
                let today = calendar.dateComponents([.year, .month, .day], from: Date())
                let compare = calendar.dateComponents([.year, .month, .day], from: reminder.deadline ?? Date())
                
                if today.year == compare.year && today.month == compare.month && today.day == compare.day {
                    return true
                }
                return false
            }
            return false
        })
        
        //예정
        self.scheduledList = list.filter({ reminder in
            if reminder.deadline != nil {
                let calendar = Calendar.current
                let today = calendar.dateComponents([.year, .month, .day], from: Date())
                let compare = calendar.dateComponents([.year, .month, .day], from: reminder.deadline ?? Date())
                
                if today.year ?? 0 <= compare.year ?? 0 && today.month ?? 0 <= compare.month ?? 0 && today.day ?? 0 < compare.day ?? 0 {
                    return true
                }
                return false
            }
            return false
        })
        
        //깃발
        self.flagList = list.filter {
            $0.flag == true
        }
        
        //완료됨
        self.doneList = list.filter {
            $0.isDone == true
        }
    }
    
    override func setupNavi() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Constant.Color.gray]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constant.SymbolImage.ellipsisCircle, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(newAddButton)
        newAddButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(listAddButton)
        listAddButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Functions
    
    @objc private func leftBarButtonTapped() {
        let vc = CalendarViewController()
        pushViewController(vc)
    }
    
    @objc private func rightBarButtonTapped() {
        print(#function)
    }
    
    @objc private func newAddButtonTapped() {
        let vc = AddTodoViewController()
        vc.closureForListVC = {[weak self] in
            guard let self else { return }
            self.setupData()
            self.collectionView.reloadData()
        }
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }
    
    @objc private func listAddButtonTapped() {
        let alert = UIAlertController(title: "새로운 폴더 추가", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { okAction in
            
            guard let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) else { return }
            if !text.isEmpty {
                self.repository.createFolder(folderName: text) { result in
                    switch result {
                    case .success(_):
                        self.folders = self.repository.fetchAllFolder()
                        self.collectionView.reloadData()
                    case .failure(let error):
                        print(error.errorDescription)
                        self.showFailAlert(type: .failedToWrite)
                    }
                }
            } else {
                self.showFailAlert(type: .failedToWrite)
            }
        }))
        alert.addTextField()
        present(alert, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width / 2 - 3 - 20
        return CGSize(width: width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionCell.identifier, for: indexPath) as? MainCollectionCell else {
            print("Failed to dequeue a MainCollectionCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        switch indexPath.row {
        case CellType.today.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: self.todayList.count)
        case CellType.scheduled.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: self.scheduledList.count)
        case CellType.all.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: self.allList.count)
        case CellType.flag.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: self.flagList.count)
        case CellType.done.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: self.doneList.count)
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case CellType.today.rawValue:
            let vc = ListViewController()
            vc.viewType = .today
            vc.reminders = todayList
            pushViewController(vc)
            
        case CellType.scheduled.rawValue:
            let vc = ListViewController()
            vc.viewType = .scheduled
            vc.reminders = scheduledList
            pushViewController(vc)
        
        case CellType.all.rawValue:
            let vc = ListViewController()
            vc.viewType = .all
            vc.reminders = allList
            pushViewController(vc)
            
        case CellType.flag.rawValue:
            let vc = ListViewController()
            vc.viewType = .flag
            vc.reminders = flagList
            pushViewController(vc)
            
        case CellType.done.rawValue:
            let vc = ListViewController()
            vc.viewType = .done
            vc.reminders = doneList
            pushViewController(vc)
        default:
            break
        }
    }
}
