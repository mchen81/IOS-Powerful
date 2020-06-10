//
//  ExerciseCell.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/9.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

protocol ECDelegate {
    func updateUI()
}


class ExerciseCell: UITableViewCell { // AKA sets controller
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
 
    var setsManager :SingleSetsManager?
    var sets: Results<SingleSet>?
    
    var ecDelegate: ECDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.rowHeight = 36
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SingleSetCell", bundle: nil), forCellReuseIdentifier: "SingleSetCell")
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print("Edit Button Pressed")
    }
    
    @IBAction func addExercisedButtonPressed(_ sender: UIButton) {
        setsManager?.addSingleSet()
        ecDelegate.updateUI()
        updateUI()
     }
    
    func updateUI(reloadTableView: Bool = true){
        sets = setsManager?.sets
        if(reloadTableView){
            tableView.reloadData()
        }
    }
    
}

extension ExerciseCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsManager?.sets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSetCell") as! SingleSetCell
        if let setInfo = sets?[indexPath.row]{
            cell.delegate = self
            
            cell.delegate = self
            cell.repsTextField.delegate = self
            cell.repsTextField.tag = indexPath.row
            
            cell.weightTextField.delegate = self
            cell.weightTextField.tag = indexPath.row
            
            cell.previousLabel.text = setInfo.previous
            cell.repsTextField.placeholder = String(setInfo.reps)
            cell.weightTextField.placeholder = String(format: "%.2f", setInfo.weight)
            cell.SetNumberLabel.text = String(setInfo.order + 1)
            cell.doneImageView.image = setInfo.isDone ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
 
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let set = setsManager?.sets[indexPath.row] {
            setsManager!.setDone(at: indexPath.row, is: !set.isDone)
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
}

//MARK: - SwipeTableViewCellDelegate Setting
extension ExerciseCell: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.setsManager!.deleteSingleSet(at: indexPath.row)
            self.updateUI(reloadTableView: false)
            self.ecDelegate.updateUI()
        }
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
extension ExerciseCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let fieldIdentifier = textField.restorationIdentifier
        if let text = textField.text  {
            if fieldIdentifier == K.ComponentIdentifier.WeightTextField {
                let value = (text as NSString).floatValue
                setsManager!.updateSet(at: textField.tag, newWeight: value, newReps: nil)
                
            }else if fieldIdentifier == K.ComponentIdentifier.RepsTextField {
                let value = (text as NSString).integerValue
                setsManager!.updateSet(at: textField.tag, newWeight: nil, newReps: value)
                
            }
        }
    }
    
}
