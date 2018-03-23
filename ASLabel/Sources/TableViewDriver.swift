//
//  TableViewDriver.swift
//  ASLabel
//
//  Created by Alexander Goremykin on 11.03.18.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewDriver: UITableViewDelegate, UITableViewDataSource {
    var drivenTableView: UITableView? { get set }
}

extension UITableView {

    func drive(by driver: TableViewDriver) {
        delegate = driver
        dataSource = driver
        driver.drivenTableView = self
    }

}

class SimpleTableViewDriver: NSObject, TableViewDriver {

    // MARK: - Public Properties

    weak var drivenTableView: UITableView?

    var cellForRowAtIndexPathUpdater: ((Int, UITableViewCell) -> ())? {
        didSet {
            drivenTableView?.reloadData()
        }
    }

    // MARK: - Constructors

    init(cellType: UITableViewCell.Type, numberOfRows: Int, cellForRowAtIndexPathUpdater: ((Int, UITableViewCell) -> ())? = nil) {
        self.cellType = cellType
        self.numberOfRows = numberOfRows
        self.cellForRowAtIndexPathUpdater = cellForRowAtIndexPathUpdater
        super.init()
    }

    // MARK: - Public Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView === drivenTableView else { assert(false); return 0 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tableView === drivenTableView else { assert(false); return UITableViewAutomaticDimension }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let update = cellForRowAtIndexPathUpdater, tableView === drivenTableView else {
            assert(false)
            return UITableViewCell()
        }

        let reuseIdentifier = "stvd-" + NSStringFromClass(cellType)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
                   cellType.init(style: .default, reuseIdentifier: reuseIdentifier)
        update(indexPath.row, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard tableView === drivenTableView else { assert(false); return false }
        return false
    }

    // MARK: - Private Properties

    private let cellType: UITableViewCell.Type
    private let numberOfRows: Int

}
