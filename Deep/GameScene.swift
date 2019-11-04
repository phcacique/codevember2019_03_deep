//
//  GameScene.swift
//  Deep
//
//  Created by Pedro Cacique on 03/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var grid = CircularGrid(numSectors: 180, numCircles: 100, isRandom: true, proportion: 30)
    var renderTime: TimeInterval = 0
    let duration: TimeInterval = 0.1
    var nodes:[SKShapeNode] = []
    let minRadius:CGFloat = 100
    let dark:UIColor = UIColor(red: 30/255, green: 31/255, blue: 38/255, alpha: 1)
    let color1:UIColor = UIColor(red: 77/255, green: 100/255, blue: 141/255, alpha: 1)
    let color2:UIColor = UIColor(red: 40/255, green: 54/255, blue: 85/255, alpha: 1)
    let color3:UIColor = UIColor(red: 208/255, green: 255/255, blue: 249/255, alpha: 1)
    
    override func didMove(to view: SKView) { 
        
        self.backgroundColor = dark
        restart()
    }
    
    func restart(){
        removeAllActions()
        removeAllChildren()
        setup()
        drawSectors()
        let circle = SKShapeNode(circleOfRadius: 80)
        circle.fillColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
        circle.lineWidth = 0
        circle.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        addChild(circle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        grid = CircularGrid(numSectors: 180, numCircles: 100, isRandom: true, proportion: 30)
        setup()
        restart()
    }
    
    func setup(){
        grid.addRule(CountRule(name: "Solitude", startState: .alive, endState: .dead, count: 2, type: .lessThan))
        grid.addRule(CountRule(name: "Survive2", startState: .alive, endState: .alive, count: 2, type: .equals))
        grid.addRule(CountRule(name: "Survive3", startState: .alive, endState: .alive, count: 3, type: .equals))
        grid.addRule(CountRule(name: "Overpopulation", startState: .alive, endState: .dead, count: 3, type: .greaterThan))
        grid.addRule(CountRule(name: "Birth", startState: .dead, endState: .alive, count: 3, type: .equals))
    }
    
    func showGen(){
        
        for n in nodes{
            n.removeAllActions()
            n.removeFromParent()
        }
        
        let step: Int = 360/grid.numSectors
        var radius: CGFloat = minRadius
        let base = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let h: CGFloat = (base / 2 - radius) / CGFloat(grid.numCircles)
        
        for j in 0..<grid.numCircles {
            var angle = 0
            for i in 0..<grid.numSectors {
                if grid.cells[i][j].state == .alive{
                    drawArc(center: CGPoint.zero, radius: radius, startAngle: angle, endAngle: angle + step, height: h, color:color2)
                }
                angle += step
            }
            radius += h
        }
    }
    
    func drawSectors(){
        let step: Int = 36
        var cont:Int = 0
        
        var angle = 0
        for _ in 0..<10 {
            let color: UIColor = (cont%2==0) ? color1 : color2
            drawArc(center: CGPoint.zero, radius: 80, startAngle: angle, endAngle: angle + step, height: 40 , color:color, randomAlpha: false, addToNodes: false)
            angle += step
            cont += 1
        }
    }

    func drawArc(center:CGPoint, radius:CGFloat = 100, startAngle:Int = 0, endAngle:Int = 30, height:CGFloat = 20, color:UIColor = .yellow, randomAlpha:Bool = true, addToNodes:Bool = true) {

        let startRad:CGFloat = CGFloat(startAngle) * .pi / 180
        let endRad:CGFloat = CGFloat(endAngle) * .pi / 180
        
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                  radius: radius,
                  startAngle: startRad,
                  endAngle: endRad,
                  clockwise: true)

        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: size.width/2, y: size.height/2)
        section.lineWidth = height
        section.strokeColor = color
        if randomAlpha {
            section.alpha = CGFloat.random(in: 0.3...1)
        } else {
            section.alpha = 0.2
        }
        addChild(section)
        
        if addToNodes {
            nodes.append(section)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if currentTime > renderTime {
            grid.applyRules()
            showGen()
            renderTime = currentTime + duration
        }
    }
}
