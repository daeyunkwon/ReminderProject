//
//  CalendarViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/4/24.
//

import UIKit

import FSCalendar
import RealmSwift
import SnapKit

final class CalendarViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var eventList: [Reminder] = []
    private var filterdRemiders: [Reminder] = []
    
    //MARK: - UI Components
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.titleDefaultColor = .label //평일
        calendar.appearance.titleWeekendColor = .gray //주말
        calendar.appearance.selectionColor = Constant.Color.customSkyBlue
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
        return calendar
    }()
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSwipeGesture()
        setupTableView()
    }
    
    private func setupData() {
        self.eventList = REALM_DATABASE.objects(Reminder.self).where({
            $0.deadline != nil
        }).map{ $0 }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    private func setupSwipeGesture() {
        let up = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        up.direction = .up
        self.view.addGestureRecognizer(up)

        let down = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        down.direction = .down
        self.view.addGestureRecognizer(down)
    }
    
    override func configureLayout() {
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.width * 1.5)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        tableView.backgroundColor = .systemGray6
        view.backgroundColor = .systemGray6
        calendar.backgroundColor = .systemBackground
    }
    
    //MARK: - Functions
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            self.calendar.setScope(.week, animated: true)
        }
        else if swipe.direction == .down {
            calendar.setScope(.month, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdRemiders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            print("Failed to dequeue a ListTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.cellType = .usingCalendarView
        cell.reminder = filterdRemiders[indexPath.row]
        
        return cell
    }
}

//MARK: - FSCalendarDelegate, FSCalendarDataSource

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if Calendar.current.isDateInToday(date) {
            return "오늘"
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for event in eventList {
            let calendar = Calendar.current
            let current = calendar.dateComponents([.year, .month, .day], from: date)
            let compare = calendar.dateComponents([.year, .month, .day], from: event.deadline ?? Date())
            
            if current.year == compare.year && current.month == compare.month && current.day == compare.day {
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let start = Calendar.current.startOfDay(for: date)
        
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = NSPredicate(format: "deadline >= %@ && deadline < %@", start as NSDate, end as NSDate)
        
        filterdRemiders = Array(REALM_DATABASE.objects(Reminder.self).filter(predicate))
        
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendar.scope == .week {
            self.calendar.snp.updateConstraints { make in
                make.height.equalTo(200)
            }
        } else {
            self.calendar.snp.updateConstraints { make in
                make.height.equalTo(self.view.bounds.width * 1.5)
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
