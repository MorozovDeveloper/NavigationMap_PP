//
//  CoreData.swift
//  NavigationMap_PP
//
//  Created by Oleg on 05.01.2022.
//

import UIKit
import CoreData

extension FavouritesViewController {
    
    func saveTask(withTitle title: String) {
        // добираемся до контекста
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // добираемся до нашей сущности которую создали
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
        // добираемся до объекта внутри нашей сущности
        let tasksObject = Tasks(entity: entity, insertInto: context)
        tasksObject.title = title
        
        do {
            try context.save()
            tasks.append(tasksObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteTask() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        if let tasks = try? context.fetch(fetchRequest){
            for task in tasks {
                context.delete(task)
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
}
