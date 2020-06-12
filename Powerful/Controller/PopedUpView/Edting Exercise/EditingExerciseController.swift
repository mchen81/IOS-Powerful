//
//  EditingExerciseController.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/10.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit

protocol EditingExerciseDelegate{
    func delete(at index: Int)
    func rename(at index: Int, name: String)
    func setTimer(at index: Int, seconds: Int)
}


class EditingExerciseController: UIViewController {

    var settingView: UIView?
    var buttonPosition: CGPoint?
    var delegate: EditingExerciseDelegate?
    var order: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let position = buttonPosition {
            var x, y: CGFloat
            let height = CGFloat(150)
            let width = CGFloat(100)
            
            x = position.x - width
            
            let offset = CGFloat(30)
            if position.y > (view.frame.height / 2) { // showing above the button
                y = position.y - height + offset
            } else {  // showing down
                y = position.y + offset
            }

            settingView = UIView(frame:
                CGRect(x: x, y: y, width: width, height: height))
            
            settingView?.layer.cornerRadius = 10
            settingView!.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.2235294118, blue: 0.3764705882, alpha: 1)
            installRenameButton()
            installSetTimerButton()
            installDeleteButton()
            view.addSubview(settingView!)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != settingView {
                self.leave()
            }
        }
    }
    
    func installRenameButton(){
        let renameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        renameButton.setTitle("Rename", for: .normal)
        renameButton.setTitleColor(.white, for: .normal)
        renameButton.addTarget(self, action: #selector(renameButtonPressed), for: .touchUpInside)
        settingView!.addSubview(renameButton)
    }
    
    func installSetTimerButton(){
        let setTimerButton = UIButton(frame: CGRect(x: 0, y: 50, width: 100, height: 50))
        setTimerButton.setTitle("Set Timer", for: .normal)
        setTimerButton.setTitleColor(.yellow, for: .normal)
        setTimerButton.addTarget(self, action: #selector(setTimerButtonPressed), for: .touchUpInside)
        settingView!.addSubview(setTimerButton)
    }
    
    func installDeleteButton(){
        let deleteButton = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 50))
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        settingView!.addSubview(deleteButton)
    }
    
    @objc func renameButtonPressed(_ sender: UIButton){
        print("edit got pressed")
        var textField = UITextField()
        let alert = UIAlertController(title: "New Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.delegate?.rename(at: self.order, name: text)
                    self.leave()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Give a new name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func setTimerButtonPressed(_ sender: UIButton){
        print("time set got pressed")
        
        var textField = UITextField()
        textField.keyboardType = .numberPad
        
        let alert = UIAlertController(title: "New Timer", message: "unit: second", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = textField.text{
                if(!text.isEmpty){
                    self.delegate?.setTimer(at: self.order, seconds: Int(text) ?? 0)
                    self.leave()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Give a new timer"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton){
        print("delete got pressed")
        delegate?.delete(at: self.order)
        leave()
    }

}


extension EditingExerciseController: WillBePopedUpViewController{
    func leave() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
