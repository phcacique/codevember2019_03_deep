//
//  Rule.swift
//  GameOfLife
//
//  Created by Pedro Cacique on 29/10/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation

//MARK: - RULE PROTOCOL
public protocol Rule {
    var name: String { get set }
    var startState: CellState { get set }
    var endState: CellState { get set }
    
    func apply(state:CellState, neighbors:[CircularCell]) -> CellState
}

//MARK: - COUNT RULE
public class CountRule: Rule {
    public var name: String
    public var startState: CellState
    public var endState: CellState
    public var count: Int
    public var type: CountRuleType
    
    public init(name:String, startState:CellState, endState:CellState, count:Int, type:CountRuleType = .greaterThan) {
        self.name = name
        self.startState = startState
        self.endState = endState
        self.count = count
        self.type = type
    }
    
    public func apply(state:CellState, neighbors:[CircularCell]) -> CellState{
        var newState:CellState = state
        if state == self.startState{
            if (self.type == .greaterThan && neighbors.count > self.count) ||
                (self.type == .lessThan && neighbors.count < self.count) ||
                (self.type == .equals && neighbors.count == self.count){
                newState = self.endState
            } else {
                newState = state
            }
        }
        return newState
    }
}

public enum CountRuleType{
    case greaterThan, lessThan, equals
}
