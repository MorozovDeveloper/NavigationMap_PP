//
//  FavouritesViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var saveRoutes: String!
    var tasks: [Tasks] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchRequest()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks != nil {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell

  }
    // Удаление строки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(tasks[indexPath.row])
            
            do {
                try context.save()
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
