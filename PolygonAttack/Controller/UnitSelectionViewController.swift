//
//  UnitSelectionViewController.swift
//  PolygonAttack
//
//  Created by Gavin Li on 5/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

protocol UnitSelectionViewControllerDelegate {
    func unitSelectionViewController(_ controller: UnitSelectionViewController, didSelectUnit unit: BoardSetupUnit)
}

class UnitSelectionViewController: UIViewController {
    
    var tableView: UITableView!
    
    var gameUnits: [BoardSetupUnit]?
    var completionHandler: ((BoardSetupUnit) -> Void)?
    var delegate: UnitSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "unitSelectionCell")
        addGameUnits(units: allAvailableUnit)
    }
    
    func addGameUnits(units: [BoardSetupUnit]) {
        self.gameUnits = units
        tableView.reloadData()
    }
}

extension UnitSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameUnits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitSelectionCell", for: indexPath)
        if let aUnit = gameUnits?[indexPath.row] {
            cell.imageView?.image = UIImage(named: aUnit.imageName)
            cell.textLabel?.text = aUnit.desc
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byTruncatingTail
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let gameUnit = gameUnits?[indexPath.row],
            let completionHandler = completionHandler else { return }
        completionHandler(gameUnit)
        dismissSelf()
    }
}

extension UnitSelectionViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) ->UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
        
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissSelf))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}
