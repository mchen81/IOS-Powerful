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
    
    //MARK: - Outlet
    @IBOutlet weak var exercisingTableView: UITableView!
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    
    var exercisingManager : ExercisingManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisingTableView.dataSource = self
        exercisingTableView.delegate = self
        
        exercisingTableView.register(UINib(nibName: K.NibName.ExerciseCell, bundle: nil),
                                     forCellReuseIdentifier: K.CellIdentifier.ExerciseCell)
        
    }
    @IBAction func addExercisePressed(_ sender: UIButton) {
        // alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.exercisingManager?.addExercise(name: textField.text!, part: "None") // TODO hard-code
                    self.updateUI()
                    self.scrollToBottom()
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
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.exercisingManager?.finishExercising()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.exercisingManager?.finishExercising()
        }
    }
    
    
}


//MARK: - UI Table View
extension ExercisingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exManger = exercisingManager {
            return exManger.getExercisesCount()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.ExerciseCell) as? ExerciseCell {
            cell.ecDelegate = self
            let setsManager = SingleSetsManager()
            setsManager.parentExercise = exercisingManager?.exercises[indexPath.row]
            cell.setsManager = setsManager
            cell.editingExerciseDelegate = self
            cell.order = indexPath.row
            cell.titleLabel.text = setsManager.parentExercise?.name
            cell.updateCellUI()
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let exercise = exercisingManager?.exercises[indexPath.row]{
            return CGFloat(exercise.sets.count * 36 + 70)
        }
        return 0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if let manager = self.exercisingManager {
                let indexPath = IndexPath(row: manager.getExercisesCount() - 1, section: 0)
                self.exercisingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
}


extension ExercisingViewController: ExerciseCellDelegate{
    
    func updateUI(){
        exercisingTableView.reloadData()
    }
    
    func popUpViewController(with subViewController: EditingExerciseController) {
        self.addChild(subViewController)
        subViewController.view.frame = self.view.frame
        self.view.addSubview(subViewController.view)
        subViewController.didMove(toParent: self)
    }
    
    func resting(for seconds: Int) {
        let restView = UIStoryboard(name: K.NibName.Main, bundle: nil)
            .instantiateViewController(withIdentifier: K.ViewControllerIdentifier.RestingView) as! RestingViewController
        
        restView.totalTime = seconds
        
        self.addChild(restView)
        restView.view.frame = self.view.frame
        self.view.addSubview(restView.view)
        restView.didMove(toParent: self)
    }
    
}

extension ExercisingViewController: EditingExerciseDelegate{
    func delete(at index: Int) {
        print("Delete Target: \(index)")
        exercisingManager?.deleteExercise(targetIndex: index)
        updateUI()
    }
    
    func rename(at index: Int, name: String) {
        exercisingManager?.renameExercise(at: index, newName: name)
        updateUI()
    }
    
    func setTimer(at index: Int, seconds: Int) {
        exercisingManager?.setRestTimer(at: index, timeInSecond: seconds)
    }
    
    
}
