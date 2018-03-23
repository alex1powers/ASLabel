//
//  File.swift
//  ASLabelDummy
//
//  Created by Alexander Goremykin on 11.03.18.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import Foundation
import UIKit

class ASLabelDummy: UIView, FittingSizeHintable {
    
    // MARK: - Public Properties

    override var intrinsicContentSize: CGSize {
        guard let content = attributedText else { return CGSize(width: UIViewNoIntrinsicMetric, height: 0.0) }

        return content.boundingRect(
            with: CGSize(width: fittingSize?.width ?? bounds.width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
    }

    var fittingSize: CGSize? { didSet { invalidateIntrinsicContentSize() } }

    override var bounds: CGRect { didSet { setNeedsDisplay() } }

    var attributedText: NSAttributedString? { didSet { setNeedsDisplay() } }

    // MARK: - Public Methods

    @objc func _is_needsLayout() -> Bool {
        let objcMethodName = "_is_needsLayout"
        let objcSelector = Selector(objcMethodName)

        typealias targetCFunction = @convention(c) (AnyObject, Selector) -> Bool
        let target = class_getMethodImplementation(superclass!, objcSelector)
        let casted = unsafeBitCast(target, to: targetCFunction.self)
        let ret = casted(self, objcSelector)
        return ret
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if savedBounds == nil || savedBounds != bounds {
            invalidateIntrinsicContentSize()
        }

        savedBounds = bounds
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext(), let content = attributedText else { return }

        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)

        let path = CGMutablePath()
        path.addRect(bounds)

        let framesetter = CTFramesetterCreateWithAttributedString(content as CFAttributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, content.length), path, nil)
        CTFrameDraw(frame, ctx)
    }

    // MARK: - Private Properties

    private var savedBounds: CGRect?

}
