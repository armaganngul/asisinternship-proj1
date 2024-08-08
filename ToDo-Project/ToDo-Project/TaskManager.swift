//
//  TaskManager.swift
//  ToDo-Project
//
//  Created by Armağan Gül on 8.08.2024.
//

import Foundation
import UIKit

class TaskManager: UITableViewCell {
    
    var taskId: String?
    var taskImportance: Int16?
    weak var viewController: ViewController?
    var indexPathexchange: IndexPath?

    
    var isDeletingOpen: Bool = false {
        didSet {
            if isDeletingOpen {
                checkboxButton.setImage(.remove, for: .normal)
            } else {
                if checkboxButton.isSelected{
                    checkboxButton.setImage(UIImage(named: "cb1"), for: .selected)
                }
                else{
                    checkboxButton.setImage(UIImage(named: "cb0"), for: .normal)
                }
            }
        }
    }

    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkboxButton: UIButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "cb0"), for: .normal)
            button.setImage(UIImage(named: "cb1"), for: .selected)
            button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
            return button
        }()
    
    @objc private func toggleCheckbox() {
        
    
            guard let id = taskId else { return }
            checkboxButton.isSelected.toggle()
            onClickClosure(id, checkboxButton.isSelected)
            updateCellAppearance()
        
    }
    
    var onClickClosure: (String, Bool) -> Void = { _,_ in }
    
    private func updateCellAppearance() {
            if checkboxButton.isSelected {
                backgroundColor = UIColor(red: 153/255, green: 255/255, blue: 153/255, alpha: 0.7)
            } else if let taskImportance = taskImportance, taskImportance == 1 {
                backgroundColor = UIColor(red: 255/255, green: 115/255, blue: 115/255, alpha: 0.7)
            } else if let taskImportance = taskImportance, taskImportance == 2 {
                backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 0.7)
            } else {
                backgroundColor = .clear
            }
        }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
  //  private func getIndexPathForCurrentCell() -> IndexPath? {
    //       guard let tableView = superview?.superview as? UITableView else { return nil }
      //     return tableView.indexPath(for: self)
      // }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(taskLabel)
        contentView.addSubview(checkboxButton)
        
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 15),
            checkboxButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func configure(taskData: ToDoItem, cell: TaskManager){
        
        let isSelected = taskData.isCompleted
        
        cell.checkboxButton.isSelected = isSelected
        cell.taskLabel.text = taskData.title
        cell.taskId = taskData.id
        cell.taskImportance = taskData.importance
        cell.checkboxButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([cell.heightAnchor.constraint(equalToConstant: 40)])
        
        
        if isSelected {
            cell.backgroundColor = UIColor(red: 153/255, green: 255/255, blue: 153/255, alpha: 0.7)
        }
        else if taskData.importance == 1{
            cell.backgroundColor = UIColor(red: 255/255, green: 115/255, blue: 115/255, alpha: 0.7)
        }
        else if taskData.importance == 2{
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 0.7)
        } else {
            cell.backgroundColor = .clear
        }
    }
}

