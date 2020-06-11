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

protocol ExerciseCellDelegate {
    func updateUI()
    func popUpViewController(with subViewController: EditingExerciseController)
}


class ExerciseCell: UITableViewCell { // AKA sets controller
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    var setsManager: SingleSetsManager?
    var ecDelegate: ExerciseCellDelegate?
    var editingExerciseDelegate: EditingExerciseDelegate?
    
    var order: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.rowHeight = 36
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.NibName.SingleSetCell, bundle: nil),
                           forCellReuseIdentifier: K.CellIdentifier.SingleSetCell)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let popview = UIStoryboard(name: K.NibName.Main, bundle: nil)
            .instantiateViewController(withIdentifier: K.ViewControllerIdentifier.EdtingExerciseView) as! EditingExerciseController
        
        // get the button absolute coordinate
        let buttonPosition = sender.convert(CGPoint.zero, to: self.superview?.superview)
        popview.buttonPosition = buttonPosition
        popview.delegate = editingExerciseDelegate
        popview.order = order
        
        ecDelegate?.popUpViewController(with: popview)
    }
    
    @IBAction func addExercisedButtonPressed(_ sender: UIButton) {
        setsManager?.addSingleSet()
        ecDelegate?.updateUI()
        updateCellUI()
     }
    
    
    func updateCellUI(){
        tableView.reloadData()
        
    }
    
}

extension ExerciseCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsManager?.sets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.SingleSetCell) as! SingleSetCell
        if let setInfo = setsManager?.sets[indexPath.row]{
            cell.delegate = self
            
            cell.delegate = self
            cell.repsTextField.delegate = self
            cell.repsTextField.tag = indexPath.row
            
            cell.weightTextField.delegate = self
            cell.weightTextField.tag = indexPath.row
            
            cell.previousLabel.text = setInfo.getPrevious()
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
            self.ecDelegate?.updateUI()
        }
        // deleteAction.image = UIImage(systemName: "trash")  Image is too big
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
