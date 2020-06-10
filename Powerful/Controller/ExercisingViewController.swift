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
    
    var exercisingManager : ExercisingManager!
    var exercises: Results<Exercise>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = exercisingManager.exercises
        exercisingTableView.dataSource = self
        exercisingTableView.delegate = self
 
        exercisingTableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
    }
    @IBAction func addExercisePressed(_ sender: UIButton) {
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
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.exercisingManager.finishExercising()
        }
        
    }
    
    func updateUI(){
        exercises = exercisingManager.exercises
        exercisingTableView.reloadData()
    }
    
}


//MARK: - UI Table View
extension ExercisingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as! ExerciseCell
        // cell.parentTableView = exercisingTableView
        // prepare exercise manager
        cell.ecDelegate = self
        let setsManager = SingleSetsManager()
        setsManager.parentExercise = exercises[indexPath.row]
        cell.setsManager = setsManager
        cell.titleLabel.text = setsManager.parentExercise?.name
        cell.updateUI()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let exercise = exercises[indexPath.row]
        return CGFloat(exercise.sets.count * 36 + 70)
    }
    
}


extension ExercisingViewController: ECDelegate{
    
}
