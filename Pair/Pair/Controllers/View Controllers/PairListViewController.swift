//
//  PairListViewController.swift
//  Pair
//
//  Created by Josh Sparks on 10/25/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import UIKit

class PairListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PairController.shared.addName(with: "adflads") { (success) -> (Void) in
        }
    }
    
    private func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: -Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentPersonAlert(for: nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        PairController.shared.pairs.shuffled()
        self.tableView.reloadData()
    }
    
    
    // MARK: -Helper Functions
    private func saveName(with text: String) {
        PairController.shared.addName(with: text) { (success) -> (Void) in
            if success {
                self.updateViews()
            }
        }
    }
    
    private func update(name: Pair) {
        PairController.shared.updateName(name) { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    private func presentPersonAlert(for name: Pair?) {
        let alertController = UIAlertController(title: "Person", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter person"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let name = name {
                textField.text = name.name
            }
        }
        
        let addNameAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            if let name = name {
                name.name = text
                self.update(name: name)
            } else {
                self.saveName(with: text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addNameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - Table view data source

extension PairListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView(_ tableView, numberOfRowsInSection: Int) > 0 {
            return PairController.shared.pairs.count / 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        
        let pair = PairController.shared.pairs[indexPath.row]
        cell.textLabel?.text = pair.name
        
        return cell
    }
    
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
}
