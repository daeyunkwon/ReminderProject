//
//  DetailViewController.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/7/24.
//

import UIKit

import SnapKit

final class DetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    var reminder: Reminder?
    
    var closureForDelete: (Reminder) -> Void = { sender in }
    
    //MARK: - UI Components
    
    private var itemsForMenu: [UIAction] {
        let update = UIAction(title: "수정") { _ in
            let vc = AddTodoViewController()
            vc.viewType = .edit
            vc.reminder = self.reminder
            vc.closureForDetailVC = {[weak self] sender in
                guard let self = self else { return }
                self.reminder = sender
                self.configureUI()
            }
            self.pushViewController(vc)
        }
        
        let delete = UIAction(title: "삭제") { _ in
            try! REALM_DATABASE.write({
                self.closureForDelete(self.reminder!)
                REALM_DATABASE.delete(self.reminder ?? Reminder())
                self.popViewController()
            })
        }
        return [update, delete]
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.grayForBackView
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.tintColor = .lightGray
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavi() {
        let menu = UIMenu(title: "메뉴", children: self.itemsForMenu)
        let rightBarButton = UIBarButtonItem(title: nil, image: Constant.SymbolImage.ellipsisCircle, primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func configureLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(scrollView.snp.bottom).offset(100)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(250)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20)
        }
        
        contentView.addSubview(priorityLabel)
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20)
        }
        
        contentView.addSubview(deadlineLabel)
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(deadlineLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-150)
        }
        contentLabel.backgroundColor = .blue
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        guard let data = self.reminder else { return }
        
        if data.imageID != nil {
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.contentMode = .scaleAspectFit
        }
        
        imageView.image = ImageFileManager.shared.loadImageToDocument(filename: data.imageID ?? "")
        titleLabel.text = data.todoTitle
        contentLabel.text = data.todoContent
        tagLabel.text = "태그: \(data.tag ?? "없음")"
        
        if data.deadline != nil {
            deadlineLabel.text = "마감일: \(Date.makeDateString(date: data.deadline ?? Date()))"
        } else {
            deadlineLabel.text = "마감일: 미설정"
        }
        
        let priorityText = data.priority == 1 ? "높음" : data.priority == 2 ? "보통" : data.priority == 3 ? "낮음" : ""
        priorityLabel.text = "우선순위: \(priorityText)"
    }
    
    
    //MARK: - Functions
    

}
