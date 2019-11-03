//
//  Grid.swift
//  GameOfLife
//
//  Created by Pedro Cacique on 29/10/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation

public class CircularGrid{
    public var numSectors:Int
    public var numCircles:Int
    public var cells: [[CircularCell]]
    public var rules: [Rule] = []
    
    public init(numSectors:Int = 10, numCircles:Int = 10, isRandom:Bool = false, proportion:Int = 50) {
        self.numSectors = numSectors
        self.numCircles = numCircles
        self.cells = []
        
        if isRandom{
            initRandomGrid(numSectors, numCircles, proportion)
        } else {
            initEmptyGrid(numSectors, numCircles)
        }
    }
    
    public func initEmptyGrid(_ numSectors: Int, _ numCircles: Int) {
        cells = []
        for i in 0..<numSectors{
            var row:[CircularCell] = []
            for j in 0..<numCircles{
                row.append(CircularCell(sector: i, radius: j , state: .dead))
            }
            cells.append(row)
        }
    }
    
    public func initRandomGrid(_ numSectors: Int, _ numCircles: Int, _ proportion:Int = 50) {
        cells = []
        for i in 0..<numSectors{
            var row:[CircularCell] = []
            for j in 0..<numCircles{
                let state:CellState = (Int.random(in: 0 ..< 100)>proportion) ? .alive : .dead
                row.append(CircularCell(sector: i, radius: j , state: state))
            }
            cells.append(row)
        }
    }
    
    public func getLiveNeighbors(cell:CircularCell) -> [CircularCell] {
        let i:Int = cell.sector
        let j:Int = cell.radius
        let state:CellState = .alive
        var neighbors:[CircularCell] = []
        //circle above (radius +1)
        if j>0 {
            if i>0 && self.cells[i-1][j-1].state == state{
                    neighbors.append(self.cells[i-1][j-1])
            } else if i==0 && self.cells[cells.count-1][j-1].state == state{
                neighbors.append(self.cells[cells.count-1][j-1])
            }
            if self.cells[i][j-1].state == state{
                neighbors.append(self.cells[i][j-1])
            }
            if i<self.numSectors-1 && self.cells[i+1][j-1].state == state {
                neighbors.append(self.cells[i+1][j-1])
            } else if i==self.numSectors-1 && self.cells[0][j-1].state == state {
                neighbors.append(self.cells[0][j-1])
            }

        }
        
        //current circle
        if i>0 && cells[i-1][j].state == state {
            neighbors.append(self.cells[i-1][j])
        } else if i==0 && cells[cells.count-1][j].state == state {
            neighbors.append(self.cells[cells.count-1][j])
        }
        if i<self.numSectors-1 && self.cells[i+1][j].state == state {
            neighbors.append(self.cells[i+1][j])
        } else if i==self.numSectors-1 && self.cells[0][j].state == state {
            neighbors.append(self.cells[0][j])
        }
        
        //circle beyond (radius -1)
        if j<self.numCircles-1 {
            if i>0 && self.cells[i-1][j+1].state == state {
                neighbors.append(self.cells[i-1][j+1])
            } else if i==0 && self.cells[cells.count-1][j+1].state == state {
                neighbors.append(self.cells[cells.count-1][j+1])
            }
            if self.cells[i][j+1].state == state {
                neighbors.append(self.cells[i][j+1])
            }
            if i<self.numSectors-1 && self.cells[i+1][j+1].state == state {
                neighbors.append(self.cells[i+1][j+1])
            } else if i==self.numSectors-1 && self.cells[0][j+1].state == state {
                neighbors.append(self.cells[0][j+1])
            }
        }
        
        return neighbors
    }
    
    public func getCellState(i:Int, j:Int) -> CellState{
        return self.cells[i][j].state
    }
    
    public func setCellState(i:Int, j:Int, state:CellState){
        self.cells[i][j].state = state
    }
    
    public func clear(){
        initEmptyGrid(self.numSectors, self.numCircles)
    }
    
    public func addRule(_ rule:Rule){
        self.rules.append(rule)
    }
    
    public func applyRules(){
        var newCells = cells
        for i in 0..<numSectors{
            for j in 0..<numCircles{
                let n:[CircularCell] = getLiveNeighbors(cell: cells[i][j])
                var newState:CellState = .dead
                let oldState:CellState = cells[i][j].state

                for rule in rules {
                    newState = rule.apply(state: oldState, neighbors: n)
                    if newState != oldState {
                        break
                    }
                }
                
                newCells[i][j] = CircularCell(sector: i, radius: j, state: newState)
            }
        }
        cells = newCells
    }
}
