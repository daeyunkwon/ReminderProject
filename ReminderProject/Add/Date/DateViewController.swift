//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

import SnapKit

final class DateViewController: BaseViewController {
    
    //MARK: - Properties
    
    var closureForDateSend: ((String?) -> Void) = { sender in }
    
    var selectedDateString: String?
    
    var selectedDate: Date?
    
    //MARK: - UI Components
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ko-KR")
        picker.date = Date()
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closureForDateSend(selectedDateString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.datePicker.date = self.selectedDate ?? Date()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavi() {
        navigationItem.title = "마감일"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    override func configureLayout() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    
    //MARK: - Functions
    
    @objc private func rightBarButtonTapped() {
        self.popViewController()
    }
    
    @objc private func datePickerValueChanged() {
        let date = datePicker.date
        let dateString = Date.makeDateString(date: date)
        self.selectedDateString = dateString
    }
}
