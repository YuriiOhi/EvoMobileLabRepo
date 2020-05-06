//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    let context = AppDelegate.shared.persistentContainer.viewContext
    var models: [SingleNoteMO] = []
    var filteredModels: [SingleNoteMO] = []
    var selectedNoteUUID: UUID?
    let searchController = UISearchController(searchResultsController: nil) // By initializing UISearchController with a nil value for searchResultsController, you’re telling the search controller that you want to use the same view you’re searching to display the results.
    //loadView 1st
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
        initialLoad()
        searchControllerConfig()
    }
    
    @IBAction func sortNotesBy() {
        uiActionSheet()
    }
    
    @IBAction func manageNotesActions() {

        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
            return
        }
        vc.currentState = .create
        vc.noteDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: SingleNoteMO
        if isFiltering {
            model = filteredModels[indexPath.row]
        } else {
            model = models[indexPath.row]
        }
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
            return
        }
        vc.currentState = .display
        vc.noteDelegate = self
        vc.noteTitle =  model.value(forKeyPath: "title") as! String
        vc.noteText = model.value(forKeyPath: "text") as! String
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            guard let vc = self.storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
                return }
            let model: SingleNoteMO
            if self.isFiltering {
                model = self.filteredModels[indexPath.row]
            } else {
                model = self.models[indexPath.row]
            }
            self.selectedNoteUUID = model.uuidString
            vc.currentState = .edit
            vc.noteDelegate = self
            vc.noteTitle = model.title!
            vc.noteText = model.text!
            completionHandler(true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.removeRow(at: indexPath)
            completionHandler(true)
        }
        edit.image = UIImage(named: "Edit")
        edit.backgroundColor = .clear
        delete.backgroundColor = .red
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredModels.count
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        let model: SingleNoteMO
        if isFiltering {
            model = filteredModels[indexPath.row]
        } else {
             model = models[indexPath.row]
        }
        if let date = model.value(forKeyPath: "creationTimeStamp") as? Date {
            cell.timeLabel?.text = formattedTimeString(date: date)
            cell.dateLabel?.text = formattedDateString(date: date)
        } else {
            print("Corrupted dateLabel again")
        }
        cell.titleLabel?.text = model.value(forKeyPath: "title") as? String
        cell.noteLabel?.text = model.value(forKeyPath: "text") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ViewController {
    
    func initialLoad() {
        let fetchRequest = NSFetchRequest<SingleNoteMO>(entityName: "SingleNote")
        do {
            models = try context.fetch(fetchRequest)
            tableView.reloadData()
            tableView.isHidden = false
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func uiActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: { (alertaction) in print("cancel")}))
        alertController.addAction(UIAlertAction(title: "Sorting by Alphabet",
                                                style: .default,
                                                handler: { (alertaction) in print("Date of Creation")}))
        alertController.addAction(UIAlertAction(title: "Sorting by the Date of Creation",
                                                style: .default,
                                                handler: { (alertaction) in print("Date of Creation")}))
        alertController.addAction(UIAlertAction(title: "Sorting by the Date of Editing ",
                                                style: .default,
                                                handler: { (alertaction) in print(" Date of Editing")}))
        present(alertController, animated: true, completion: nil)

    }
//        func limitLabelLength() {
//            if ([titleLabel.text length] > 15) {
//                // User cannot type more than 15 characters
//                self.categoryField.text = [self.categoryField.text, substringToIndex: 15]
//            }
//
//        }
    
    private func removeRow(at indexPath: IndexPath) {
        let noteToDelete = models[indexPath.row]
        models.remove(at: indexPath.row )//pull out the NSManObj object that I selected to delete
        context.delete(noteToDelete) //removes it from the managed object context,
        AppDelegate.shared.saveContext() // save changes in ManObjContext
        tableView.deleteRows(at: [indexPath], with: .fade)
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
    
}

extension ViewController: NoteDelegate {
    
    func createNote(title: String, text: String, creationStamp: Date, editingStamp: Date, uuidString: UUID) {
        let entity = NSEntityDescription.entity(forEntityName: "SingleNote", in: self.context)!
        let note = SingleNoteMO(entity: entity, insertInto: self.context)
        note.setValue(title, forKeyPath: "title")
        note.setValue(text, forKeyPath: "text")
        note.setValue(creationStamp, forKey: "creationTimeStamp")
        note.setValue(uuidString, forKey: "uuidString")
        note.setValue(editingStamp, forKey: "editingTimeStamp")
        do {
            self.models.append(note)
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateNote(title: String, text: String, editingStamp: Date) {
        models.forEach { model in
            if (selectedNoteUUID == model.uuidString) {
                model.title = title
                model.text = text
                model.editingTimeStamp = editingStamp
                do {
                    try self.context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            selectedNoteUUID = nil
        }
        
        tableView.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - SearchBar Implementation
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchControllerConfig() {
           searchController.searchResultsUpdater = self
           searchController.obscuresBackgroundDuringPresentation = false
           navigationItem.searchController = searchController
           definesPresentationContext = true
    }
    
    var isSearchBarEmpty: Bool { // computed property
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredModels = models.filter { (model: SingleNoteMO) -> Bool in
            return (model.text?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}
// сделать метод сетМодел инкапсулировать передачу данных/ модель нужна для передачи данных
// использование айди увеличивает возможность совершить ошибку. // может нужно было использовать Сет для хранения заметок
// можно добавить выбор фильтра по темам или тексту и показывать сколько заметок отфильтровано из всех
