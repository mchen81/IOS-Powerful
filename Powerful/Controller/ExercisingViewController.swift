//
//  ExerciseTableViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit

class ExercisingViewController: UIViewController {
    
    var exercises: [Exercise]!
    
    @IBOutlet weak var exercisingTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exercisingManager : ExercisingManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisingTableView.delegate = self
        exercisingTableView.dataSource = self
        exercises = exercisingManager?.exercises
    }
    
    @IBAction func addExerciseButtonPressed(_ sender: UIButton) {
        // alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.exercisingManager.addExercise(name: textField.text!, part: "Chest")
                    self.updateUI()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new exercise"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addSetButtonPressed(sender: UIButton!){
        
        exercisingManager.addSingleSet(targetExerciseIndex: sender.tag)
        updateUI()
    }
    
    func updateUI(reloadTV: Bool = true){
        exercises = exercisingManager.exercises
        if(reloadTV){
            exercisingTableView.reloadData()
        }
    }
    
}


extension ExercisingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exercises[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // let footerView = UIView()
        
        let addSetButton = UIButton(type: .contactAdd)
        addSetButton.tag = section
        addSetButton.addTarget(self,
                               action: #selector(addSetButtonPressed),
                               for: .touchUpInside)
        
        return addSetButton
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sets = exercises[section].sets?.allObjects as? [SingleSet] {
            return sets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.ExerciseSetCell) as! SingleSetTVCell
        cell.delegate = self
        cell.repsTextField.delegate = self
        cell.weightTextField.delegate = self
        
        if let sets = exercises[indexPath.section].sets?.allObjects as? [SingleSet] {
            cell.textLabel?.text = sets[indexPath.row].previous
        }
        return cell
    }

}


//MARK: - SwipeTableViewCellDelegate
extension ExercisingViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.exercisingManager.deleteSingleSet(targetExerciseIndex: indexPath.section, targetSetIndex: indexPath.row)
            self.updateUI(reloadTV: false)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


//MARK: - text field
extension ExercisingViewController: UITextFieldDelegate{
    
}
