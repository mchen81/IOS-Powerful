//
//  ExerciseTableViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit

class ExercisingViewController: UIViewController {
    
    
    let exercisesSeciton:[FakeExercise] = [FakeExercise(name: "Brench Press"),
        FakeExercise(name: "Push-Up") , FakeExercise(name: "Chect Flying")]
    
    @IBOutlet weak var exercisingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisingTableView.delegate = self
        exercisingTableView.dataSource = self
        
    }


}

extension ExercisingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercisesSeciton.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exercisesSeciton[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesSeciton[section].sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.ExerciseSetCell)
        cell?.textLabel?.text = exercisesSeciton[indexPath.section].sets[indexPath.row]
        return cell!
        
    }
    
    
    
}

struct FakeExercise{
    let name: String
    let sets: [String] = ["Set1", "Set2", "Set3"]
}


