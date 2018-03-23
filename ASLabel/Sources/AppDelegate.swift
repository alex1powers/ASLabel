//
//  AppDelegate.swift
//  ASLabel
//
//  Created by Alexander Goremykin on 11.03.18.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Properties

    var window: UIWindow?

    // MARK: - Public Methods

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let window = UIWindow()

        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [
            { () -> UIViewController in
                let label = UILabel(frame: .zero)
                label.attributedText = attributedContent
                label.numberOfLines = 0

                return type(of: self).makePage(title: "SysLbl", only: label)
            }(),
            { () -> UIViewController in
                let label = ASLabelDummy(frame: .zero)
                label.attributedText = attributedContent

                return type(of: self).makePage(title: "ASLbl", only: label)
            }(),
            { () -> UIViewController in
                let aTuple = type(of: self).makeTableView(numberOfRows: 100) { [weak self] (cell: CommonTableCell<ASLabelDummy>) -> Void in
                    cell.content.attributedText = self?.attributedContent
                    cell.backgroundColor = .blue
                }

                let bTuple = type(of: self).makeTableView(numberOfRows: 100) { [weak self] (cell: CommonTableCell<UILabel>) -> Void in
                    cell.content.attributedText = self?.attributedContent
                    cell.content.numberOfLines = 0
                    cell.backgroundColor = .red
                }

                tableViewDrivers.append(aTuple.driver)
                tableViewDrivers.append(bTuple.driver)

                return type(of: self).makePage(title: "TV", aView: aTuple.view, bView: bTuple.view, fixHeight: true)
            }(),
            { () -> UIViewController in
                let aTuple = type(of: self).makeTableView(numberOfRows: 100) { [weak self] (cell: CommonTableCell<ASLabel>) -> Void in
                    cell.content.attributedText = self?.attributedContent
                    cell.backgroundColor = .blue
                }

                let bTuple = type(of: self).makeTableView(numberOfRows: 100) { [weak self] (cell: CommonTableCell<UILabel>) -> Void in
                    cell.content.attributedText = self?.attributedContent
                    cell.content.numberOfLines = 0
                    cell.backgroundColor = .red
                }

                tableViewDrivers.append(aTuple.driver)
                tableViewDrivers.append(bTuple.driver)

                return type(of: self).makePage(title: "TV (hack)", aView: aTuple.view, bView: bTuple.view, fixHeight: true)
            }()
        ]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    // MARK: - Private Properties
    
    private lazy var attributedContent: NSAttributedString = {
        return NSAttributedString(
            string: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            """,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.0),
                .foregroundColor: UIColor.white
            ]
        )
    }()

    private var tableViewDrivers: [TableViewDriver] = []

}

fileprivate extension AppDelegate {

    // MARK: - Private Methods

    private class func makePage(title: String, aView: UIView?, bView: UIView?, fixHeight: Bool = false) -> UIViewController {
        let page = ComparisonViewController(aView: aView, bView: bView, fixHeight: fixHeight)
        page.tabBarItem.title = title
        return page
    }

    private class func makePage(title: String, only view: UIView, fixHeight: Bool = false) -> UIViewController {
        return makePage(title: title, aView: view, bView: nil, fixHeight: fixHeight)
    }

    private class func makeTableView<CellType: UITableViewCell>(numberOfRows: Int, updater: @escaping (CellType) -> Void) ->
        (view: UITableView, driver: TableViewDriver)
    {
        let view = UITableView()
        let driver = SimpleTableViewDriver(cellType: CellType.self, numberOfRows: numberOfRows) { _, cell in
            (cell as? CellType).flatMap(updater)
        }

        view.drive(by: driver)

        return (view: view, driver: driver)
    }

}
