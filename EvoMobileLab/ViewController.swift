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
        
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
                return
            }
            
            vc.title = "New Note"
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.completion = { [weak self] noteTitle, noteText in // items in a capture list get the strong ref by default
                self?.navigationController?.popToRootViewController(animated: true)
                self?.models.append(SingleNote(title: noteTitle, text: noteText, timeStamp: Date(), dateStamp: Date()))
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
    
    func formattedDateString(date: Date) -> String {
        var timeSince1970: Double
        timeSince1970 = date.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeSince1970))
    }
    
    func formattedTimeString(date: Date) -> String {
        var timeSince1970: Double
        timeSince1970 = date.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeSince1970))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        cell.timeLabel?.text = formattedTimeString(date: models[indexPath.row].timeStamp)
        cell.dateLabel?.text = formattedDateString(date: models[indexPath.row].dateStamp)
        cell.titleLabel?.text = models[indexPath.row].title
        cell.noteLabel?.text = models[indexPath.row].text
        
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
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? DisplayNoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.noteText = model.text
        navigationController?.pushViewController(vc, animated: true)
    }

}

