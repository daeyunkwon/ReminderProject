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
    
    private enum CellType: Int, CaseIterable {
        case today
        case scheduled
        case all
        case flag
        case done
    }
    
    private var todayList: Results<Reminder>!
    private var scheduledList: Results<Reminder>!
    private var allList: Results<Reminder>!
    private var flagList: Results<Reminder>!
    private var doneList: Results<Reminder>!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    private func setupData() {
        let list = REALM_DATABASE.objects(Reminder.self)
        self.allList = list
        
//        var date = Date()
//        let today = Date.makeDateString(date: date)
//        self.todayList = list.where({ reminder in
//            
//            let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//            let compare = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: reminder.deadline))
//        })
        
        
        
        
//        self.scheduledList = list.filter { r in
//            let deadline = Date.makeStringToDate(str: r.deadline ?? "")
//            if deadline.timeIntervalSince1970 < date.timeIntervalSince1970 {
//                return true
//            }
//        }
//        
//        self.scheduledList = list.where({ reminder in
//            let date = Date.makeStringToDate(str: reminder.deadline)
//        })
        
    }
    
    override func setupNavi() {
        self.navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Constant.Color.gray]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constant.SymbolImage.ellipsisCircle, style: .plain, target: self, action: #selector(rightBarButtonTapped))
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
    
    @objc func rightBarButtonTapped() {
        print(#function)
    }
    
    @objc func newAddButtonTapped() {
        print(#function)
    }
    
    @objc func listAddButtonTapped() {
        print(#function)
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
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: 0)
        case CellType.scheduled.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: 0)
        case CellType.all.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: allList.count)
        case CellType.flag.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: 0)
        case CellType.done.rawValue:
            cell.cellConfig(cellType: MainCollectionCell.CellType.allCases[indexPath.row], count: 0)
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case CellType.today.rawValue:
            print("오늘 셀 선택됨")
        case CellType.scheduled.rawValue:
            print("예정 셀 선택됨")
        case CellType.all.rawValue:
            let vc = ListViewController()
            vc.list = allList
            pushViewController(vc)
        case CellType.flag.rawValue:
            print("깃발 표시 셀 선택됨")
        case CellType.done.rawValue:
            print("완료됨 셀 선택됨")
        default:
            break
        }
    }
}
