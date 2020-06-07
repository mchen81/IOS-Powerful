//
//  ExerciseTableViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class ExercisingViewController: UIViewController {
    
    var exercises: Results<Exercise>!
    @IBOutlet weak var exercisingTableView: UITableView!
    
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    var exercisingManager : ExercisingManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisingTableView.delegate = self
        exercisingTableView.dataSource = self
        exercises = exercisingManager?.exercises
        
        exerciseTitleLabel.text = exercisingManager.parentRutine?.name
    }
    
    @IBAction func addExerciseButtonPressed(_ sender: UIButton) {
        // alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.exercisingManager.addExercise(name: textField.text!, part: "Chest") // TODO hard-code
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
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.exercisingManager.finishExercising()
        }
        
    }
    func updateUI(reloadTV: Bool = true){
        exercises = exercisingManager.exercises
        if(reloadTV){
            exercisingTableView.reloadData()
        }
        
    }
    
    
}

//MARK: - Table View Setting
extension ExercisingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let exercise = exercises[section]
        return "\(exercise.order + 1). \(exercise.name)"
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
        return exercises[section].sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.ExerciseSetCell) as! SingleSetTVCell
        cell.delegate = self
        cell.repsTextField.delegate = self
        cell.repsTextField.tag = indexPath.section
        cell.repsTextField.order = indexPath.row
        
        cell.weightTextField.delegate = self
        cell.weightTextField.tag = indexPath.section
        cell.weightTextField.order = indexPath.row
        
        let sets = exercises[indexPath.section].sets
        let set = sets[indexPath.row]
        cell.previousLabel.text = set.previous
        cell.repsTextField.placeholder = String(set.reps)
        cell.weightTextField.placeholder = String(format: "%.2f", set.weight)
        cell.SetNumberLabel.text = String(set.order + 1)
        cell.isDoneImage.image = set.isDone ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        exercisingManager.updateSet(exerciseIndex: indexPath.section, setIndex: indexPath.row, newWeight: nil, newReps: nil, done: !exercises[indexPath.section].sets[indexPath.row].isDone)
        
        exercisingTableView.reloadData()
        exercisingTableView.deselectRow(at: indexPath, animated: false)
    }
    
    

}


//MARK: - SwipeTableViewCellDelegate Setting
extension ExercisingViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.exercisingManager.deleteSingleSet(targetExerciseIndex: indexPath.section, targetSetIndex: indexPath.row)
            self.updateUI(reloadTV: false)
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trach")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


//MARK: - Text Field For Weight and Reps
extension ExercisingViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let fieldIdentifier = textField.restorationIdentifier
        if let order = (textField as! TVCellTextField).order, let text = textField.text  {
            if fieldIdentifier == K.ComponentIdentifier.WeightTextField {
                let value = (text as NSString).floatValue
                exercisingManager.updateSet(exerciseIndex: textField.tag, setIndex: order, newWeight: value, newReps: nil)
                
            }else if fieldIdentifier == K.ComponentIdentifier.RepsTextField {
                let value = (text as NSString).integerValue
                exercisingManager.updateSet(exerciseIndex: textField.tag, setIndex: order, newWeight: nil, newReps: value)
                
            }
        }
    }
    
}

