//
//  WeekViewController.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

protocol WeekViewControllerDelegate: class {
    func controllerDidRefresh(_ controller: WeekViewController)
}

final class WeekViewController: UIViewController {
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.dataSource = self
            tableView.separatorInset = .zero
            tableView.estimatedRowHeight = 60.0
            tableView.showsVerticalScrollIndicator = false
            tableView.autoresizesSubviews = true
            tableView.refreshControl = refreshControl
        }
    }
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    var viewModel: WeekViewModel? {
        didSet {
            refreshControl.endRefreshing()
            if let viewModel = viewModel {
                setupViewModel(with: viewModel)
            }
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.base
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    weak var delegate: WeekViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupViewModel(with viewModel: WeekViewModel) {
        activityIndicatorView.stopAnimating()
        
        tableView.reloadData()
        tableView.isHidden = false
    }
}


extension WeekViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfDays ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayTableViewCell.reuseIdentifier,for: indexPath) as? WeekDayTableViewCell else {
            fatalError()
        }
        guard let viewModel = viewModel else { fatalError() }
        
        cell.configure(with: viewModel.viewModel(for: indexPath.row), count: indexPath.row)
        return cell
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        delegate?.controllerDidRefresh(self)
    }
    
    
}
