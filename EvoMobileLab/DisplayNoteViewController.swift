//
//  NoteViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/18.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
// Saved Note VC
class DisplayNoteViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    public var noteTitle: String = ""
    public var noteText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = noteTitle
        noteField.text = noteText
        
        noteField.delegate = self
        titleField.delegate = self
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing))
        self.navigationItem.rightBarButtonItem = rightButton
        
        titleField.borderStyle = UITextField.BorderStyle.none
        noteField.borderStyle = UITextField.BorderStyle.none
        noteField.textAlignment = .left
        noteField.contentVerticalAlignment = .top
    }
}

extension DisplayNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //функция которая позволяет редактирование текстФилда
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isEditing == false {
            return false
        } else {
            return true
        }
    }
    
    //Изменение "Edit" на "Done"
    @objc func showEditing(sender: UIBarButtonItem) {
        if(isEditing == false) {
            isEditing = true
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            isEditing = false
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    func saveChanges() {
        
    }
}
