//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var models: [SingleNote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
    }
    //
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] noteTitle, noteText in
            self?.navigationController?.popToRootViewController(animated: true)
            self?.models.append(SingleNote(noteTitle: noteTitle, noteText: noteText, noteTimeStamp: Date()))
            self?.titleLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.tableView.reloadData()//Reloads the rows and sections of the table view.
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].noteTitle
        cell.detailTextLabel?.text = models[indexPath.row].noteText
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDel = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success) in print("Delete")
        }
        swipeDel.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        let conf = UISwipeActionsConfiguration(actions: [swipeDel])
        conf.performsFirstActionWithFullSwipe = false
        return UISwipeActionsConfiguration(actions: [swipeDel])
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
        vc.noteTitle = model.noteTitle
        vc.noteText = model.noteText
        navigationController?.pushViewController(vc, animated: true)
    }

}
