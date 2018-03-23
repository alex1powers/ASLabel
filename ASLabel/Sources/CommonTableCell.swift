//
//  CommonTableCell.swift
//  ASLabel
//
//  Created by Alexander Goremykin on 11.03.18.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import Foundation
import UIKit

protocol FittingSizeHintable: class {
    var fittingSize: CGSize? { get set }
}

class CommonTableCell<Content: UIView>: UITableViewCell {

    // MARK: - Public Properties

    let content: Content

    // MARK: - Consturctors

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.content = Content(frame: .zero)
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        content.leftAnchor.constraint(equalTo: leftAnchor, constant: Layout.contentMargin).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor, constant: -Layout.contentMargin).isActive = true
        content.topAnchor.constraint(equalTo: topAnchor, constant: Layout.contentMargin / 2.0).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.contentMargin / 2.0).isActive = true

        content.isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize
    {
        if let content = content as? FittingSizeHintable {
            content.fittingSize = CGSize(
                width: targetSize.width - 2.0 * Layout.contentMargin,
                height: targetSize.height - Layout.contentMargin
            )
        }

        return super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
    }

    // MARK: - Private Nested

    private struct Layout {
        static var contentMargin: CGFloat { return 16.0 }
    }
    
}
