//
//  DataController.swift
//  ToDo-Project
//
//  Created by Armağan Gül on 8.08.2024.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    
    static let shared = DataController()
    
    private var persistentContainer : NSPersistentContainer
    
    var ViewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoItem")
        
        persistentContainer.loadPersistentStores{_, error in
            
            if let error = error{
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        
        ViewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func saveToDoItem(title: String, importance: Int16) -> Bool{
        let todoItem = ToDoItem(context: ViewContext)
        todoItem.id = UUID().uuidString
        todoItem.title = title
        todoItem.isCompleted = false
        todoItem.importance = importance
        
        do{
            do{
                try ViewContext.save()
                return true }
            
            catch{
                print("Failed to save new ToDoItem \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func fetchItems() -> [ToDoItem]{
        
        let fetch : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        do{
            return try ViewContext.fetch(fetch)
        }
        
        catch{
            print("Failed to fetch TO DO ITEMS: \(error.localizedDescription)")
            return []
            }
        }
    
    
    
    
    func deleteItems(item: ToDoItem){
    
        ViewContext.delete(item)
        do{
            try ViewContext.save()
        }
        catch{
            print("Failed to delete TO DO ITEM: \(error.localizedDescription)")
        }
    }
    
    func updateItems(item: ToDoItem, title: String, isCompleted: Bool? = nil, importance: Int16){
        
        if let isCompleted = isCompleted {
            
            item.title = title
            item.isCompleted = isCompleted
            item.importance = importance
        }
        
        do{
            try ViewContext.save()
        }
        catch{
            print("Failed to update TO DO ITEM: \(error.localizedDescription)")
        }
    }
}
    
    

