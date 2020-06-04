//
//  RoutineViewController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/4.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController {

    @IBOutlet weak var routineTableView: UITableView!
    
    let routines = ["Chest", "Shoulder", "Legs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineTableView.delegate = self
        routineTableView.dataSource = self
    }
}

extension RoutineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.RoutineCell)
        cell?.textLabel?.text = routines[indexPath.row]
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SeugueIdentifier.StartWorkingOut, sender: self)
    }
}
