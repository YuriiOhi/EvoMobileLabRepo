//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!//UITableView manages the basic appearance of the table, but your app provides the cells ( UITableViewCell objects) that display the actual content. The standard cell configurations display a simple combination of text and images, but you can define custom cells that display any content you want.
    @IBOutlet weak var titleLabel: UILabel! // UILabel. A view that displays one or more lines of read-only text, often used in conjunction with controls to describe their intended purpose.
    //Neither IBOutlet or IBAction affect how the code is compiled. They are , place markers written to tell Xcode that an object in the code can be connected to a UI component in Interface Builder. This allows the UI constructed in Interface Builder to receive messages from the code. Equally, the IBAction declaration is a place marker for Interface Builder, allowing us to connect calling actions in response to events happening in the UI to a method.
    var models: [(title: String, note: String)] = []
    
    override func viewDidLoad() {//ViewDidLoad is a function that gets called when the view (UI) loads on the screen. It's basically saying the device is ready to do stuff. If you have any other experience programming you can kind of think of it as the main() of your view con
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return//Storyboard. A storyboard is a visual representation of the user interface of an iOS application, showing screens of content and the connections between those screens. ... In addition, a storyboard enables you to connect a view to its controller object, and to manage the transfer of data between view controllers.
            // instantiateViewController Creates the view controller with the specified identifier and initializes it with the data from the storyboard.
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            self.models.append((title: noteTitle, note: note))
            self.titleLabel.isHidden = true // titleLabel use these properties primarily to configure the text of the button.
            self.tableView.isHidden = false
            
            self.tableView.reloadData()//Reloads the rows and sections of the table view.


        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        
        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated: true)
    }

}
