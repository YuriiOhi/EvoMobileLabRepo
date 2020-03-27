//
//  NoteViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/18.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
// Saved Note VC
class NoteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextView!
    
    public var noteTitle: String = ""
    public var noteText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = noteText
        
        // Do any additional setup after loading the view.
    }

}
