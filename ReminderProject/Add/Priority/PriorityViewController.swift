//
//  PriorityViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import SnapKit

final class PriorityViewController: BaseViewController {
    
    //MARK: - Properties
    
    var closureForDataSend: ((Int) -> Void) = { sender in }
    var settingPriority: Int = 0
    
    //MARK: - UI Components
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "높음", at: 0, animated: true)
        segment.insertSegment(withTitle: "보통", at: 1, animated: true)
        segment.insertSegment(withTitle: "낮음", at: 2, animated: true)
        segment.selectedSegmentIndex = 2
        return segment
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch segmentControl.selectedSegmentIndex {
        case 0: closureForDataSend(1)
        case 1: closureForDataSend(2)
        case 2: closureForDataSend(3)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavi() {
        navigationItem.title = "우선 순위"
    }
    
    override func configureLayout() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        switch settingPriority {
        case 1: segmentControl.selectedSegmentIndex = 0
        case 2: segmentControl.selectedSegmentIndex = 1
        case 3: segmentControl.selectedSegmentIndex = 2
        default:
            break
        }
    }
}
