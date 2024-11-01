//
//  ViewController.swift
//  Journal
//
//  Created by Goutham Das T on 29/10/24.
//

import UIKit
import Combine

class JournalViewController: UIViewController {
    private var viewModel: JournalViewModelProtocol = JournalViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private let cellIdentifier: String = "JournalCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBindings()
        setupNavbar()
    }
    
    private func setupUI() {
        title = "Journal"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.entriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntryTapped))
    }
    
    @objc private func addEntryTapped() {
        let alert = UIAlertController(title: "New Journal Entry", message: "Enter your title and description", preferredStyle: .alert)
        
        // Add text fields for title and description
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Description"
            textField.text = "" // Optional: Set default text if needed
        }
        
        // Add the "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let title = alert?.textFields?[0].text, !title.isEmpty,
                  let description = alert?.textFields?[1].text, !description.isEmpty else {
                // Handle empty fields if needed
                return
            }
            
            // Call the addEntry method on the ViewModel
            self?.viewModel.addEntry(with: title, body: description)
        }
        
        alert.addAction(saveAction)
        
        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true)
    }
    
}

extension JournalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = viewModel.entries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = entry.title
        content.secondaryText = entry.date?.formatted(.dateTime)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (deleteAction, view, completionHandler) in
            // Call the ViewModel's delete function
            self?.viewModel.deleteEntry(at: indexPath.row)
            // Indicate that the action was completed
            completionHandler(true)
        }
        // Customize the appearance of the delete action
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        // Return the swipe actions as a configuration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true // Allow full swipe to delete
        return configuration
    }
    
    // Handle cell selection to update the entry
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = viewModel.entries[indexPath.row]
        
        // Present the update alert
        let alert = UIAlertController(title: "Update Journal Entry", message: "Update your title and description", preferredStyle: .alert)
        
        // Add text fields for title and description
        alert.addTextField { textField in
            textField.placeholder = "Title"
            textField.text = entry.title // Pre-fill with current title
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Description"
            textField.text = entry.content // Pre-fill with current content
        }
        
        // Add the "Update" action
        let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let self = self,
                  let title = alert.textFields?[0].text, !title.isEmpty,
                  let description = alert.textFields?[1].text, !description.isEmpty else {
                // Handle empty fields if needed
                return
            }
            
            // Call the update method on the ViewModel
            self.viewModel.updateEntry(entry, with: title, body: description)
            self.tableView.reloadData() // Refresh the table view after the update
        }
        
        alert.addAction(updateAction)
        
        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true)
        
        // Deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

