//
//  Utils.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

func afterDelay(_ delay: TimeInterval, performBlock block:@escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: block)
}

func adjustLabelFontSizeToFitRect(labelNode: SKLabelNode, rect: CGRect, insetPadding: CGFloat = 10.0) {

    // Determine the font scaling factor that should let the label text fit in the given rectangle.
    let scalingFactor = min(rect.width / (labelNode.frame.width + insetPadding), rect.height / (labelNode.frame.height + insetPadding))

    // Change the fontSize.
    labelNode.fontSize *= scalingFactor

    // Optionally move the SKLabelNode to the center of the rectangle.
    labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
}

func informativeTextLabel(origin: CGPoint, message: String) -> SKNode {
    let width:CGFloat = 500
    let helpOverlay = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: 100))
    helpOverlay.position = CGPoint(x: origin.x - (width / 2.0), y: origin.y)
    helpOverlay.fillColor = .white
    helpOverlay.strokeColor = .black
    helpOverlay.zPosition = 10

    // Label
    let helpLabel = SKLabelNode(text: message)
    let relativeOverlayRect = CGRect(origin: .zero, size: helpOverlay.frame.size)
    adjustLabelFontSizeToFitRect(labelNode: helpLabel, rect: relativeOverlayRect)
    helpLabel.zPosition = helpOverlay.zPosition
    helpLabel.fontColor = .black
    helpOverlay.addChild(helpLabel)

    return helpOverlay
}

func addSwipeGesture(to scene: SKScene, direction: UISwipeGestureRecognizerDirection, selector: Selector) {
    let swipeGesture = UISwipeGestureRecognizer(target: scene, action: selector)
    swipeGesture.direction = direction
    scene.view?.addGestureRecognizer(swipeGesture)
}
