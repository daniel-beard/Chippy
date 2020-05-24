////
////  BugEntity.swift
////  Chippy
////
////  Created by Daniel Beard on 5/17/20.
////  Copyright © 2020 DanielBeard. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//
//class BugEntity: GKEntity, Tile, Monster {
//    var uuid: UUID = UUID()
//    var position: Position = Position(x: 0, y: 0)
//
//    required init(_ name: String) {fatalError("Not implemented") }
//
//    func update(delta: TimeInterval, gameManager: GameManager) {
//    }
//
//
//    required init(name: String, entityManager: EntityManager) {
//        super.init()
//        let texture = SKTexture(imageNamed: "bug")
//        let spriteComponent = SpriteComponent(texture: texture)
//        addComponent(spriteComponent)
//        addComponent(BugMoveComponent())
//    }
//
//    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//        super.init()
//        let texture = SKTexture(imageNamed: "bug")
//        let spriteComponent = SpriteComponent(texture: texture)
//        addComponent(spriteComponent)
//        addComponent(BugMoveComponent())
//    }
//
//    //MARK: Tile conformance
//    func layer() -> TileLayer { .three }
//    var name: String = "bug"
//}
