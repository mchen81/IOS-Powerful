//
//  EditingExerciseController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/10.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit

class EditingExerciseController: UIViewController {

    var settingView: UIView!
    
    var x: CGFloat?
    var y: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // x = 10
        // y = 10
        
        settingView = UIView(frame: CGRect(x: x!, y: y!, width: 300, height: 100))
        settingView.backgroundColor = .yellow
        installDeleteButton()
        
        
        
        view.addSubview(settingView)
        // Do any additional setup after loading the view.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != settingView {
                self.view.isHidden = true
            }
        }
    }
    
    
    func installDeleteButton(){
        let delete = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        delete.setTitle("Delete", for: .normal)
        delete.setTitleColor(.black, for: .normal)
        delete.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        settingView.addSubview(delete)
        
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton){
        print("delete got pressed")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
