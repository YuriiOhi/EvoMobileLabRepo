//
//  EntryViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/18.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
import CoreData

// Notes Adding and Saving VC
class CreateNoteViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapNewNote))
    }
    
    @objc func didTapNewNote() {
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            completion?(text, noteField.text)
        }
    }
}
