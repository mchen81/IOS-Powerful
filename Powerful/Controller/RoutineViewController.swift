//
//  RoutineViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class RoutineViewController: UIViewController{
    
    @IBOutlet weak var routineTableView: UITableView!
    
    
    var routineManager: RoutineManager!
    var routines: Results<Routine>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineManager = RoutineManager()
        routineManager.loadRoutine()
        
        routines = routineManager.routines
        
        routineTableView.delegate = self
        routineTableView.dataSource = self
        
        routineTableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        
        routineTableView.rowHeight = 80.0

    }
    
    @IBAction func addRoutinePressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Routine", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.routineManager.addRoutine(name: text)
                    self.updateUI()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new routine"
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // super.prepare(for: segue, sender: sender)
        let destinationVC = segue.destination as! ExercisingViewController
        
        if let indexPath = routineTableView.indexPathForSelectedRow {
            if let thisRutine = routineManager.routines?[indexPath.row]{
                let exerciseManager = ExercisingManager()
                exerciseManager.parentRutine = thisRutine
                destinationVC.exercisingManager = exerciseManager
            }
        }
    }
}

extension RoutineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.RoutineCell) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = routines[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SeugueIdentifier.StartWorkingOut, sender: self)
    }
    
    func updateUI(reloadTV: Bool = true){
        routines = routineManager.routines
        if reloadTV {
            routineTableView.reloadData()
        }
    }
}


extension RoutineViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.routineManager.deleteRoutine(targetIndex: indexPath.row)
            self.updateUI(reloadTV: false)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


