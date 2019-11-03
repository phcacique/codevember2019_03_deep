//
//  Cell.swift
//  GameOfLife
//
//  Created by Pedro Cacique on 29/10/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation

public class CircularCell{
    public var sector:Int
    public var radius:Int
    public var state:CellState
    
    public init(sector:Int, radius:Int, state:CellState = .dead) {
        self.sector = sector
        self.radius = radius
        self.state = state
    }
}

public enum CellState{
    case alive, dead
}
