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

extension Collection {
    /// Checks if every element in an array matches a precondition
    /// E.g. [2,3,4].all { $0 > 1 } // true
    /// [2,3,4,5].all { $0 > 3 } // false
    func all(_ condition:(Element) -> Bool) -> Bool {
        for elem in self where !condition(elem) {
            return false
        }
        return true
    }

    /// Checks if any element in an array passes a precondition
    func any(_ condition:(Element) -> Bool) -> Bool {
        for elem in self where condition(elem) {
            return true
        }
        return false
    }

    /// Returns first match where element can be cast to V.Type
    /// E.g. tiles.at(pos: currPos).grab(of: FloorTile.self)
    func grab<V>(of: V.Type) -> V? {
        return self.compactMap({ $0 as? V }).first
    }
}

// Because we communicate from GameManager -> GameScene with notifications,
// This extension attempts to prevent simulataneous access to game objects
// This is a bit of a kludge, but by having this separate, I can at least switch out this implementation
// with a better approach in future.
func gameNotif(name: String, userInfo: [AnyHashable : Any]? = nil) {
    afterDelay(0.01) {
        NotificationCenter.default.post(name: Notification.Name(name),
                                        object: nil,
                                        userInfo: userInfo)
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

func addSwipeGesture(to scene: SKScene, direction: UISwipeGestureRecognizer.Direction, selector: Selector) {
    let swipeGesture = UISwipeGestureRecognizer(target: scene, action: selector)
    swipeGesture.direction = direction
    scene.view?.addGestureRecognizer(swipeGesture)
}

func nowTime() -> TimeInterval {
    return CACurrentMediaTime()
}
