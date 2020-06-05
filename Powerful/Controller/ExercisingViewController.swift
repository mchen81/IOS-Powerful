//
//  ExerciseTableViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit

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
}

extension ExercisingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exercises[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sets = exercises[section].sets?.allObjects as? [SingleSet] {
            return sets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.ExerciseSetCell)
        cell?.textLabel?.text = "Cannot find any elements"
        if let sets = exercises[indexPath.section].sets?.allObjects as? [SingleSet] {
            cell?.textLabel?.text = sets[indexPath.row].previous
        }
        return cell!
    }
    
    func updateUI(){
        exercises = exercisingManager.exercises
        exercisingTableView.reloadData()
    }
    
}

