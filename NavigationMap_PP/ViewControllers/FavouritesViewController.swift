//
//  FavouritesViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var saveRoutes: String!
    
    var tasks: [Tasks] = []
     
    @IBAction func deleteButton(_ sender: Any) {
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
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    
}
