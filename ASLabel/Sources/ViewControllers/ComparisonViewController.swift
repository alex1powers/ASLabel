//
//  ComparisonViewController.swift
//  ASLabel
//
//  Created by Alexander Goremykin on 11.03.18.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import Foundation
import UIKit

class ComparisonViewController: UIViewController {

    // MARK: - Constructors

    init(aView: UIView?, bView: UIView?, fixHeight: Bool) {
        self.aView = aView
        self.bView = bView
        self.fixHeight = fixHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if let content = aView {
            view.addSubview(content)

            content.backgroundColor = .blue
            
            content.translatesAutoresizingMaskIntoConstraints = false
            content.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
            content.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
            content.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            content.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -50.0).isActive = fixHeight
        }

        if let content = bView {
            view.addSubview(content)

            content.backgroundColor = .red

            content.translatesAutoresizingMaskIntoConstraints = false
            content.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
            content.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60.0).isActive = true
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            content.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -50.0).isActive = fixHeight
        }
    }

    // MARK: - Private Methods

    private let aView: UIView?
    private let bView: UIView?

    private let fixHeight: Bool
    
}
