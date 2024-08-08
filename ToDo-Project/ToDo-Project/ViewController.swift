//
//  ViewController.swift
//  ToDo-Project
//
//  Created by Armağan Gül on 8.08.2024.
//

import UIKit
import Foundation

struct Todo {
    let id: String
    let name: String
    let importance: Int16
    var isChecked: Bool
}

class ViewController: UIViewController {
    @Published var listItems: [ToDoItem] = []
    private var dataController = DataController.shared
   
    private lazy var tableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(TaskManager.self, forCellReuseIdentifier: "taskSelection") // Pink
        return table
    }()
    
    private var newImportance: Int = 0
    private var isDeletingOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To-Do List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        setupTableView()
        fetchItemsAndUpdateTable()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc private func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        // Add the text field
        ac.addTextField()
        
        // Create a custom view with radio buttons
        let radioButtonsView = UIView()
        radioButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the radio buttons
        let casualButton = createRadioButton(withTitle: "Casual")
        let importantButton = createRadioButton(withTitle: "Important")
        let urgentButton = createRadioButton(withTitle: "Urgent")
        
        // Add buttons to the custom view
        radioButtonsView.addSubview(casualButton)
        radioButtonsView.addSubview(importantButton)
        radioButtonsView.addSubview(urgentButton)
        ac.view.addSubview(radioButtonsView)
        
        // Layout constraints for buttons
        NSLayoutConstraint.activate([
            ac.view.heightAnchor.constraint(equalToConstant: 280),
            
            radioButtonsView.centerYAnchor.constraint(equalTo: ac.view.centerYAnchor, constant: 12),
            radioButtonsView.centerXAnchor.constraint(equalTo: ac.view.centerXAnchor),
            
            casualButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            casualButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            casualButton.bottomAnchor.constraint(equalTo: importantButton.topAnchor, constant: -20),
            casualButton.heightAnchor.constraint(equalTo: importantButton.heightAnchor),
            
            importantButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            importantButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            
            urgentButton.topAnchor.constraint(equalTo: importantButton.bottomAnchor, constant: 20),
            urgentButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            urgentButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            urgentButton.bottomAnchor.constraint(equalTo: radioButtonsView.bottomAnchor),
            urgentButton.heightAnchor.constraint(equalTo: importantButton.heightAnchor),
            
        ])
        
        // Add the custom view to the alert controller
        
        // Layout constraints for the custom view
        NSLayoutConstraint.activate([
            radioButtonsView.topAnchor.constraint(equalTo: ac.view.bottomAnchor, constant: 8),
            radioButtonsView.leadingAnchor.constraint(equalTo: ac.view.leadingAnchor, constant: 16),
            radioButtonsView.trailingAnchor.constraint(equalTo: ac.view.trailingAnchor, constant: -16),
            radioButtonsView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        let emptyText = UIAlertController(title: "Task name can't be empty", message: "Please try again", preferredStyle: .alert)
        let emptyAction = UIAlertAction(title: "Retry", style: .default)
        emptyText.addAction(emptyAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {
                return }
            if answer == "" {
                self!.present(emptyText, animated: true)
            }
            else{
                self?.addItem(title: answer, importance: Int16(self?.newImportance ?? 1))
            }}
            
            
            ac.addAction(submitAction)
            present(ac, animated: true)
        }
    
    @objc func promptForUpdate(indexPath: IndexPath){
        let ac = UIAlertController(title: "Update your task:", message: nil, preferredStyle: .alert)
        
        // Add the text field
        ac.addTextField()
        
        // Create a custom view with radio buttons
        let radioButtonsView = UIView()
        radioButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the radio buttons
        let casualButton = createRadioButton(withTitle: "Casual")
        let importantButton = createRadioButton(withTitle: "Important")
        let urgentButton = createRadioButton(withTitle: "Urgent")
        
        // Add buttons to the custom view
        radioButtonsView.addSubview(casualButton)
        radioButtonsView.addSubview(importantButton)
        radioButtonsView.addSubview(urgentButton)
        ac.view.addSubview(radioButtonsView)
        
        // Layout constraints for buttons
        NSLayoutConstraint.activate([
            ac.view.heightAnchor.constraint(equalToConstant: 280),
            
            radioButtonsView.centerYAnchor.constraint(equalTo: ac.view.centerYAnchor, constant: 12),
            radioButtonsView.centerXAnchor.constraint(equalTo: ac.view.centerXAnchor),
            
            casualButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            casualButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            casualButton.bottomAnchor.constraint(equalTo: importantButton.topAnchor, constant: -20),
            casualButton.heightAnchor.constraint(equalTo: importantButton.heightAnchor),
            
            importantButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            importantButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            
            urgentButton.topAnchor.constraint(equalTo: importantButton.bottomAnchor, constant: 20),
            urgentButton.leadingAnchor.constraint(equalTo: radioButtonsView.leadingAnchor),
            urgentButton.trailingAnchor.constraint(equalTo: radioButtonsView.trailingAnchor),
            urgentButton.bottomAnchor.constraint(equalTo: radioButtonsView.bottomAnchor),
            urgentButton.heightAnchor.constraint(equalTo: importantButton.heightAnchor),
            
        ])
        
        // Add the custom view to the alert controller
        
        // Layout constraints for the custom view
        NSLayoutConstraint.activate([
            radioButtonsView.topAnchor.constraint(equalTo: ac.view.bottomAnchor, constant: 8),
            radioButtonsView.leadingAnchor.constraint(equalTo: ac.view.leadingAnchor, constant: 16),
            radioButtonsView.trailingAnchor.constraint(equalTo: ac.view.trailingAnchor, constant: -16),
            radioButtonsView.heightAnchor.constraint(equalToConstant: 120)
        ])

        
        let emptyText = UIAlertController(title: "Task name can't be empty", message: "Please try again", preferredStyle: .alert)
        let emptyAction = UIAlertAction(title: "Retry", style: .default)
        emptyText.addAction(emptyAction)
        
        // Add the submit action
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            
            guard let answer = ac?.textFields?[0].text else {return }
            
            if answer == "" {
                self!.present(emptyText, animated: true)
            }
            else{
                
                let currItem = self?.listItems[indexPath.row]
                self!.updateItem(item: currItem!, title: answer, importance: Int16(self!.newImportance))
            }}
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func createRadioButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func radioButtonTapped(_ sender: UIButton) {
        for button in sender.superview?.subviews.compactMap({ $0 as? UIButton }) ?? [] {
            button.isSelected = false
        }
        sender.isSelected = true
        
        if sender.titleLabel?.text == "Casual"{
            newImportance = 3
        }
        else if sender.titleLabel?.text == "Important"{
            newImportance = 2
        }
        else{
            newImportance = 1
        }
    }
    
}

extension ViewController {
    
    func fetchItemsAndUpdateTable(){
        listItems = dataController.fetchItems()
        tableView.reloadData()
    }
    
    func deleteItem(index: Int){
        let item = listItems[index]
        dataController.deleteItems(item: item)
        fetchItemsAndUpdateTable()
    }
    
    func addItem(title: String, importance: Int16){
        _ = dataController.saveToDoItem(title: title, importance: importance)
        fetchItemsAndUpdateTable()
    }
    
    func updateItem(item: ToDoItem, title: String, importance: Int16){
        dataController.updateItems(item: item, title: title, isCompleted: item.isCompleted, importance: importance)
        fetchItemsAndUpdateTable()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        promptForUpdate(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskSelection", for: indexPath) as! TaskManager
        let taskData =  listItems[indexPath.row]
        
        cell.configure(taskData: taskData, cell: cell)
        cell.isDeletingOpen = isDeletingOpen
        cell.viewController = self
        cell.indexPathexchange = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(index: indexPath.row)
            fetchItemsAndUpdateTable()
        }
    }
    
}
